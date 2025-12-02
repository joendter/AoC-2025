with builtins;
with rec {
    pkgs = import <nixpkgs> {};
    mod = n: modulus: pkgs.lib.trivial.mod ((pkgs.lib.trivial.mod n modulus)+ modulus) modulus;
    nicesplit = (splitOn: string: filter (x: isString x) (split splitOn string));
    raw = readFile ./input.txt;
    lines = nicesplit "\n" raw;
    relevant_lines = filter (x: stringLength x > 0) lines;
};
lines
