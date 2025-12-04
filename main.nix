with builtins;
with (import ./aoclib.nix);
with rec {
    pkgs = import <nixpkgs> {};
    raw = readFile ./input.txt;
    lines = nicesplit "\n" raw;
    relevant_lines = filter (x: stringLength x > 0) lines;
    grid = map as_char_array relevant_lines;
    xpadded_grid = map (l: ["."] ++ l ++ ["."]) grid;
    padded_grid = let padline = map (x: ".") (elemAt xpadded_grid 1); in
        [padline] ++ xpadded_grid ++ [padline];
    adjacencies = x: y:
        with rec {
            xrange = map (dx: x + dx) (range (-1) 1);
            yrange = map (dy: y + dy) (range (-1) 1);
            poss = map (x: map (y: {x = x; y = y;}) yrange) xrange;
        };
        pkgs.lib.lists.flatten poss;
    val_at = pos: grid:
        elemAt (elemAt grid pos.y) pos.x;
    accessible = x: y: grid:
        if val_at {x = x; y = y;} grid != "@" then false
        else
        sum (map (x: if x == "@" then 1 else 0) (map (pos: val_at pos grid) (adjacencies x y))) < 5;
};
with rec {
    xrange = map (dx: dx) (range (1) (length (head padded_grid) - 2));
    yrange = map (dy: dy) (range (1) (length padded_grid - 2));
    poss = pkgs.lib.lists.flatten (map (x: map (y: {x = x; y = y;}) yrange) xrange);
};
sum (map (pos: if accessible pos.x pos.y padded_grid then 1 else 0) poss)
