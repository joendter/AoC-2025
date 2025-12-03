with builtins;
with rec {
    pkgs = import <nixpkgs> {};
    mod = n: modulus: pkgs.lib.trivial.mod ((pkgs.lib.trivial.mod n modulus)+ modulus) modulus;
    nicesplit = (splitOn: string: filter (x: isString x) (split splitOn string));
    range = pkgs.lib.lists.range;
    sum = list: foldl' add 0 list;
    ceil = a: b: (a - 1) / b + 1;
    as_char_array = string: filter (x: stringLength x > 0) (nicesplit "" string); 
    reverse = pkgs.lib.lists.reverseList;
    tail = pkgs.lib.lists.tail;
    index_of = predicate: list: 
    if predicate (head list) then 0 else (index_of predicate (tail list) + 1);
    max = list: foldl' pkgs.lib.trivial.max 0 list;
    drop = pkgs.lib.lists.drop;
    digits = n: if n < 10 then 1 else (digits (n / 10)) + 1;
    power = base: exponent: if exponent == 0 then 1 else (power base (exponent - 1)) * base;

    raw = readFile ./input.txt;
    lines = nicesplit "\n" raw;
    relevant_lines = filter (x: stringLength x > 0) lines;
    find_total = nums: to_go:
    if to_go == 0 then 0 else
    with rec {
        n = max (drop (to_go - 1) (reverse nums));
        rest = drop (index_of (x: x == n) nums + 1) nums;
        rest_result = find_total rest (to_go - 1);
        mult = power 10 (digits rest_result);
    };
    n * mult + rest_result;

    find_best_in_line = line:
    with rec {
        nums = map (x: fromJSON x) (as_char_array line);
    };
    (find_total nums 12) / 10;
};
sum (map find_best_in_line relevant_lines)
