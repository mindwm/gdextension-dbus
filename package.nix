{ lib
, pkgs
, stdenv
, scons
, godot-cpp
, withPlatform ? "linux"
, withTarget ? "template_release"
}:

let
  mkSconsFlagsFromAttrSet = lib.mapAttrsToList (k: v:
    if builtins.isString v
    then "${k}=${v}"
    else "${k}=${builtins.toJSON v}");
in
stdenv.mkDerivation {
  name = "godot-extension-dbus";
  src = ./.;

  nativeBuildInputs = with pkgs; [ scons pkg-config ];
  buildInputs = with pkgs; [ dbus godot-cpp ];
  enableParallelBuilding = true;
  BUILD_NAME = "nix-flake";

  sconsFlags = mkSconsFlagsFromAttrSet {
    platform = withPlatform;
    target = withTarget;
  };

  outputs = [ "out" ];

  preBuild = ''
    cp -av "${godot-cpp}" ./godot-cpp
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    cp addons/dbus/bin/*.so $out/bin/
    cp addons/dbus/dbus.gdextension $out/
  '';

  meta = with lib; {
    homepage = "https://github.com/mindwm/gdextension-dbus";
    description = "A Godot extension to communicate with DBus";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ omgbebebe ];
  };
}
