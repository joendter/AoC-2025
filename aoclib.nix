with builtins;
rec {
    pkgs = import <nixpkgs> {};
    mod = n: modulus: pkgs.lib.trivial.mod ((pkgs.lib.trivial.mod n modulus)+ modulus) modulus;
    nicesplit = (splitOn: string: filter (x: isString x) (split splitOn string));
    range = pkgs.lib.lists.range;
    sum = list: foldl' add 0 list;
    ceil = a: b: (a - 1) / b + 1;
    raw = readFile ./input.txt;
    reverse = pkgs.lib.lists.reverseList;
    tail = pkgs.lib.lists.tail;
    index_of = predicate: list: 
    if predicate (head list) then 0 else (index_of predicate (tail list) + 1);
    max = list: foldl' pkgs.lib.trivial.max 0 list;
    drop = pkgs.lib.lists.drop;
    digits = n: if n < 10 then 1 else (digits (n / 10)) + 1;
    power = base: exponent: if exponent == 0 then 1 else (power base (exponent - 1)) * base;
}
