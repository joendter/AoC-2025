with builtins;
with (import ./aoclib.nix);
with rec {
    pkgs = import <nixpkgs> {};
    lines = nicesplit "\n" raw;
    relevant_lines = filter (x: stringLength x > 0) lines;
};
lines
