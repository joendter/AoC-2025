with builtins;
with (import ./aoclib.nix);
with rec {
    raw = readFile ./input.txt;
    lines = nicesplit "\n" raw;
    relevant_lines = filter (x: stringLength x > 0) lines;
    stuff = map (l: nicesplit0 " " l) relevant_lines;
    rotated = map (x: map (y:
        elemAt2d stuff {x=x; y=y;}
    ) (range_across stuff)) 
    (range_across (elemAt stuff 0));
    solve_problem = problem: 
    let p = reverse problem; in
    foldl' (if head p == "+" then add else mul)
    (if head p == "+" then 0 else 1)
    (map fromJSON (tail p));
};
sum (map solve_problem rotated)
