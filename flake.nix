{
  description = "Flake to build devshell for Comfyui";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs =
    { self, nixpkgs }:
    let
      forAllSystems =
        function:
        nixpkgs.lib.genAttrs
          [
            "x86_64-linux"
            "aarch64-linux"
          ]
          (
            system:
            function (
              import nixpkgs {
                inherit system;
                config.allowUnfree = true;
                overlays = [ ];
              }
            )
          );
    in
    {
      devShells = forAllSystems (pkgs: {
        default = throw "You need to specify which output you want: CPU, ROCm, or CUDA.";
        cpu = import ./impl.nix {
          inherit pkgs;
          variant = "CPU";
        };
        cuda = import ./impl.nix {
          inherit pkgs;
          variant = "CUDA";
        };
        cuda-beta = import ./impl.nix {
          inherit pkgs;
          variant = "CUDA-BETA";
        };
        rocm = import ./impl.nix {
          inherit pkgs;
          variant = "ROCM";
        };
      });
    };
}
