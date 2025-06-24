{ pkgs, variant, ... }:

let
  hardware_deps =
    with pkgs;
    if variant == "CUDA" || variant == "CUDA-BETA" then
      [
        cudaPackages.cudatoolkit
        xorg.libXi
        xorg.libXmu
        freeglut
        xorg.libXext
        xorg.libX11
        xorg.libXv
        xorg.libXrandr
        zlib

        # for xformers
        gcc
      ]
      ++ (if variant == "CUDA" then [ linuxPackages.nvidia_x11 ] else [ linuxPackages.nvidia_x11_beta ])
    else if variant == "ROCM" then
      [
        rocmPackages.rocm-runtime
        pciutils
      ]
    else if variant == "CPU" then
      [
      ]
    else
      throw "You need to specify which variant you want: CPU, ROCm, or CUDA.";
in
pkgs.mkShell rec {
  name = "comfyui-shell";

  buildInputs =
    with pkgs;
    hardware_deps
    ++ [
      git # The program instantly crashes if git is not present, even if everything is already downloaded
      (python312.withPackages (
        p: with p; [
          pip
        ]
      ))
      stdenv.cc.cc.lib
      stdenv.cc
      ncurses5
      binutils
      gitRepo
      gnupg
      autoconf
      curl
      procps
      gnumake
      util-linux
      m4
      gperf
      unzip
      libGLU
      libGL
      glib
    ];

  venvDir = ".venv";
  packages = with pkgs.python310Packages; [
    venvShellHook
  ];

  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;
  CUDA_PATH = pkgs.lib.optionalString (variant == "CUDA") pkgs.cudaPackages.cudatoolkit;
  EXTRA_LDFLAGS = pkgs.lib.optionalString (
    variant == "CUDA"
  ) "-L${pkgs.linuxPackages.nvidia_x11_beta}/lib";
}
