with builtins;
with (import ./aoclib.nix);
with rec {
    raw = readFile ./input.txt;
    lines = nicesplit "\n" raw;
    relevant_lines = filter (x: stringLength x > 0) lines;
    stuff = map (l: nicesplit "" l) relevant_lines;
    rotated = map (x: map (y:
        elemAt2d stuff {x=x; y=y;}
    ) (range_across stuff)) 
    (range_across (elemAt stuff 0));
    solve_problem = problem: 
    let p = reverse problem; in
    foldl' (if head p == "+" then add else mul)
    (if head p == "+" then 0 else 1)
    ((tail p));
    slice_head_tail = s: substring 1 (stringLength s - 2) s ;
    fold_fun = previous: new:
    with rec {
        maybeop = last new;
        operation = if elem maybeop ["*" "+"] then maybeop else previous.operation;
        rest = reverse (tail (reverse new));
        evaluate = all (x: elem x ["" " "]) rest;
        numbers = if evaluate then [] else previous.numbers ++ [(fromJSON (
        concatStrings rest
        ))];
        total = if evaluate then
        previous.total + solve_problem (previous.numbers ++ [operation])
        else
        previous.total;
        results = if evaluate then previous.results ++ [(total - previous.total)] else previous.results;
    };
    {
        operation = operation;
        numbers = numbers;
        total = total;
        results = results;
    };
};
foldl' fold_fun {operation = "+"; numbers = []; total = 0; results = [];} rotated
