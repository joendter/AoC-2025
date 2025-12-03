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
    raw = readFile ./input.txt;
    lines = nicesplit "\n" raw;
    relevant_lines = filter (x: stringLength x > 0) lines;
    find_best_in_line = line:
    with rec {
        nums = map (x: fromJSON x) (as_char_array line);
        n1 = foldl' (pkgs.lib.trivial.max) 0 (tail (reverse nums));
        n2 = foldl' (pkgs.lib.trivial.max) 0 (
            pkgs.lib.lists.drop (index_of (x: x == n1) nums + 1) nums
        );
    };
    n1 * 10 + n2;
};
sum (map find_best_in_line relevant_lines)
