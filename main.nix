with builtins;
let a = rec {
    pkgs = import <nixpkgs> {};
    mod = n: modulus: pkgs.lib.trivial.mod ((pkgs.lib.trivial.mod n modulus)+ modulus) modulus;
    nicesplit = (splitOn: string: filter (x: isString x) (split splitOn string));
    raw = readFile ./input.txt;
    lines = nicesplit "\n" raw;
    relevant_lines = filter (x: stringLength x > 0) lines;
    to_integer = (string: fromJSON (replaceStrings ["L" "R"] ["-" ""] string));
    intlist = map to_integer relevant_lines;
}; in
(builtins.foldl' 
(x: y: 
let next = ((x.x+y)); in 
{zero_crossings = x.zero_crossings + 
    (if next <= 0 then
        (-next) / 100 + (if x.x > 0 then 1 else 0)
    else
        next / 100) 
; x = a.mod next 100;}
) {zero_crossings = 0; x = 50;} a.intlist).zero_crossings
