{ lib, ... }:
with builtins;
let
  shares = lib.importTOML ./shares.toml;
in
rec {

  inherit (shares) users;

  users-dict = listToAttrs (
    map (u: {
      name = "${u.gn}.${toString u.sn}";
      value = u;
    }) users
  );

}
