with builtins;
with (import ./aoclib.nix);
with rec {
    raw = readFile ./input.txt;
    stuff = map (x: filter (x: x != "") (nicesplit "\n" x)) (nicesplit "\n\n" raw);
    ranges = map (s: map fromJSON (nicesplit "-" s)) (elemAt stuff 0);
    ids = map fromJSON (elemAt stuff 1);

    in_range = id: range: 
        elemAt range 0 <= id &&
        elemAt range 1 >= id;
};
length (filter (id: any (l: in_range id l) ranges) ids)
