{ lib
, stdenv
, installShellFiles
, libX11
, libinput
, libxcb
, libxkbcommon
, pixman
, pkg-config
, substituteAll
, wayland-scanner
, wayland
, wayland-protocols
, wlroots_0_17
, writeText
, xcbutilwm
, xwayland
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dwl";
  version = "0.6";

  src = builtins.fetchGit {
    url =  "file://./.";
    rev = "v${finalAttrs.version}";
    hash = "sha256-U/vqGE1dJKgEGTfPMw02z5KJbZLWY1vwDJWnJxT8urM=";
  };

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    libinput
    libxcb
    libxkbcommon
    pixman
    wayland
    wayland-protocols
    wlroots_0_17
    libX11
    xcbutilwm
    xwayland
  ];

  outputs = [ "out" "man" ];

  makeFlags = [
    "PKG_CONFIG=${stdenv.cc.targetPrefix}pkg-config"
    "WAYLAND_SCANNER=wayland-scanner"
    "PREFIX=$(out)"
    "MANDIR=$(man)/share/man"
  ];

  buildPhase = ''
    make clean
    make
  '';

  meta = {
    homepage = "https://codeberg.org/dwl/dwl";
    description = "Dynamic window manager for Wayland";
    longDescription = ''
    dwl is a compact, hackable compositor for Wayland based on wlroots. It is intended to fill the same space in the Wayland world that dwm does in X11, primarily in terms of functionality, and secondarily in terms of philosophy. Like dwm, dwl is:

      - Easy to understand, hack on, and extend with patches
      - One C source file (or a very small number) configurable via config.h
      - Tied to as few external dependencies as possible
    '';
    changelog = "https://github.com/djpohly/dwl/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.AndersonTorres ];
    inherit (wayland.meta) platforms;
    mainProgram = "dwl";
  };
})
