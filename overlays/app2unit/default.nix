_: prev: {
  app2unit = prev.app2unit.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ./app2unit-scd-fix.patch
    ];
  });
}
