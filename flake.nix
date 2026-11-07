{
  description = "Development enviromnent for Zathura.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            inputsFrom = [
              pkgs.zathuraPkgs.zathura_core
            ];

            packages = with pkgs; [
              meson
              ninja
              pkg-config
              gdb
            ];

            shellHook = ''
              export ZATHURA_PLUGINS_PATH="${pkgs.zathura}/lib/zathura"

              meson setup build \
                --libdir=lib \
                --buildtype=debug

              build-zathura() {
                meson compile -C build
              }
            '';
          };
        }
      );
    };
}
