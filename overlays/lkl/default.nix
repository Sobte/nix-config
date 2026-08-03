_: prev: {
  lkl = prev.lkl.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ./cptofs-mem.patch
    ];
  });
}
