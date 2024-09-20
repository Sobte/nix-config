{
  lib,
  inputs,
  namespace,
  system,
  target,
  format,
  virtual,
  systems,
  host,
  config,
  ...
}:
let
  inherit (lib)
    optionals
    optionalAttrs
    mkDefault
    mkOption
    types
    any
    concatMapAttrs
    intersectLists
    mergeAttrsList
    foldl'
    ;

  cfg = config.${namespace}.containers;

  bridgeName = "nixctr0";

  servicesEnum = [
    "postgresql"
    "vaultwarden"
  ];
  sharedServicesEnum = [
    "wg-quick"
    "openssh"
  ];

  # type
  containerType = types.submodule (
    { name, ... }:
    {
      options = with types; {
        autoStart = lib.mkEnableOption "Whether the container is automatically started at boot-time." // {
          default = true;
        };
        modules = mkOption {
          type = listOf raw;
          default = [ ];
        };
        userName = mkOption {
          type = str;
          default = "root";
        };
        networkMode = mkOption {
          type = enum [
            "host"
            "bridge"
            "none"
          ];
          default = "bridge";
          description = ''
            `none` -- Completely isolate a container from the host and other containers. none is not available for Swarm services.
          '';
        };
        hostBridge = mkOption {
          type = nullOr str;
          default = bridgeName;
          example = "br0";
          description = ''
            Put the host-side of the veth-pair into the named bridge.
            Only one of hostAddress* or hostBridge can be given.
            Only enabled when networkMode is bridge.
          '';
        };
        forwardPorts = mkOption {
          type = listOf attrs;
          default = [ ];
          example = [
            {
              protocol = "tcp";
              hostPort = 8080;
              containerPort = 80;
            }
          ];
          description = ''
            List of forwarded ports from host to container. Each forwarded port
            is specified by protocol, hostPort and containerPort. By default,
            protocol is tcp and hostPort and containerPort are assumed to be
            the same if containerPort is not explicitly given.
          '';
        };
        hostAddress = mkOption {
          type = nullOr str;
          default = null;
          example = "10.231.136.1";
        };
        hostAddress6 = mkOption {
          type = nullOr str;
          default = null;
          example = "fc00::1";
        };
        localAddress = mkOption {
          type = nullOr str;
          default = null;
          example = "10.231.136.2";
        };
        localAddress6 = mkOption {
          type = nullOr str;
          default = null;
          example = "fc00::2";
        };
        bindMounts = mkOption {
          type = attrs;
          default = { };
          example = literalExpression ''
            { "/home" = { hostPath = "/home/alice";
                          isReadOnly = false; };
            }
          '';
          description = ''
            An extra list of directories that is bound to the container.
          '';
        };
        hostModules = {
          enable = lib.mkEnableOption "Using host Modules." // {
            default = true;
          };
          src = mkOption {
            type = listOf path;
            default = [
              ./../../nixos
              ./../../shared
            ];
            description = ''
              The source of the modules.
              Relative paths are relative to the `modules/nixos/container/default.nix`
            '';
          };
          # Automatically load and start
          autoLoader = {
            services = mkOption {
              type = listOf (enum servicesEnum);
              default = intersectLists [ "${name}" ] servicesEnum;
            };
            shared.services = mkOption {
              type = listOf (enum sharedServicesEnum);
              default = intersectLists [ "${name}" ] sharedServicesEnum;
            };
            bindSecretsEtcSymlink = lib.mkEnableOption ''
              Binding host decryption secrets etc symlink.
              The secret to enable the corresponding service.
            '';
          };
        };
        specialArgs = mkOption {
          type = types.attrsOf types.unspecified;
          default = { };
          description = ''
            A set of special arguments to be passed to NixOS modules.
            This will be merged into the `specialArgs` used to evaluate
            the NixOS configurations.
          '';
        };
        config = mkOption {
          type = attrs;
          default = { };
        };
        extraOptions = mkOption {
          type = attrs;
          default = { };
        };
      };
    }
  );
in
{
  options.${namespace}.containers = mkOption {
    type = types.attrsOf containerType;
    default = { };
    description = "using `machinectl`";
  };

  config = {
    containers = concatMapAttrs (name: ctr: {
      ${name} = {
        inherit (ctr)
          autoStart
          forwardPorts
          hostAddress
          hostAddress6
          localAddress
          localAddress6
          ;

        privateNetwork = ctr.networkMode != "host";
        hostBridge = if ctr.networkMode == "bridge" then ctr.hostBridge else null;
        bindMounts =
          let
            autoLoaderSecrets = lib.mkIf ctr.hostModules.autoLoader.bindSecretsEtcSymlink (
              (foldl' (
                acc: name:
                acc
                // (
                  let
                    service = config.${namespace}.services.${name};
                    path = service.secrets.dirPathInEtc or "";
                    enable = service.secrets.enable or false;
                  in
                  optionalAttrs (enable && path != "") {
                    "/etc/${path}".isReadOnly = true;
                  }
                )
              ) { } ctr.hostModules.autoLoader.services)
              // (foldl' (
                acc: name:
                acc
                // (
                  let
                    service = config.${namespace}.shared.services.${name};
                    path = service.secrets.dirPathInEtc or "";
                    enable = service.secrets.enable or false;
                  in
                  optionalAttrs (enable && path != "") {
                    "/etc/${path}".isReadOnly = true;
                  }
                )
              ) { } ctr.hostModules.autoLoader.shared.services)
            );
          in
          autoLoaderSecrets // ctr.bindMounts;

        config =
          let
            hostModules =
              with inputs;
              [
                # These are fixed values, unfortunately I have to import them manually
                agenix.nixosModules.default
                home-manager.nixosModules.home-manager
                lanzaboote.nixosModules.lanzaboote
                vscode-server.nixosModules.default
                nixos-wsl.nixosModules.default
                nix-gaming.nixosModules.pipewireLowLatency
                snowfall-lib.nixosModules.user
              ]
              ++ (builtins.concatLists (
                map (
                  src: builtins.attrValues (lib.snowfall.module.create-modules { inherit src; })
                ) ctr.hostModules.src
              ));
            userAttrs =
              if ctr.hostModules.enable then
                { ${namespace}.user.name = ctr.userName; }
              else
                {
                  users.users.${ctr.userName} = lib.mkIf (ctr.userName != "root") {
                    isNormalUser = true;
                    uid = 1000;
                    group = "users";
                    home = "/home/${ctr.userName}";
                    extraGroups = [ "wheel" ];
                  };
                };
            autoLoader = {
              ${namespace} = {
                services = mergeAttrsList (
                  map (service: {
                    ${service}.enable = mkDefault true;
                  }) ctr.hostModules.autoLoader.services
                );
                shared.services = mergeAttrsList (
                  map (service: {
                    ${service}.enable = mkDefault true;
                  }) ctr.hostModules.autoLoader.shared.services
                );
              };
            };
          in
          {
            imports = ctr.modules ++ (optionals ctr.hostModules.enable hostModules);
            system.stateVersion = mkDefault config.system.stateVersion;
          }
          // userAttrs
          // ctr.config
          // autoLoader;

        specialArgs =
          ctr.specialArgs
          // (optionalAttrs ctr.hostModules.enable {
            inherit
              namespace
              inputs
              system
              target
              format
              virtual
              systems
              host
              lib
              ;
          });
      } // ctr.extraOptions;
    }) cfg;

    # network
    ${namespace}.system.network =
      let
        isBridge = any (x: x.networkMode == "bridge") (builtins.attrValues cfg);
      in
      {
        # bridge
        bridges = lib.mkIf isBridge {
          ${bridgeName} = {
            interfaces = [ "eth0" ];
            ipv4.addresses = [
              {
                address = "172.18.0.1";
                prefixLength = 16;
              }
            ];
          };
        };
      };
  };
}
