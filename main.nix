with builtins;
with rec {
    pkgs = import <nixpkgs> {};
    mod = n: modulus: pkgs.lib.trivial.mod ((pkgs.lib.trivial.mod n modulus)+ modulus) modulus;
    nicesplit = (splitOn: string: filter (x: isString x) (split splitOn string));
    range = pkgs.lib.lists.range;
    sum = list: foldl' add 0 list;
    ceil = a: b: (a - 1) / b + 1;
    digits = n: if n < 10 then 1 else (digits (n / 10)) + 1;
    raw = readFile ./input.txt;
    ranges = map (s: (map fromJSON (nicesplit "-" s))) (nicesplit "," raw);
    power = base: exponent: if exponent == 0 then 1 else (power base (exponent - 1)) * base;
    invalid_ids_in_range = l: r: 
    (
        if digits l < digits r then
        let border = (power 10 (digits l)); in
        invalid_ids_in_range l (border - 1)
        ++
        invalid_ids_in_range border r
        else
        if mod (digits l) 2 == 1 then [] 
        else
        with rec {
            exp = (digits l) / 2;
            mult = (power 10 exp) + 1;
            start = ceil l mult;
            end = r / mult;
        };
        map (x: x * mult) (range start end)
    );
};
sum (map (a: sum (invalid_ids_in_range (elemAt a 0) (elemAt a 1))) ranges)
