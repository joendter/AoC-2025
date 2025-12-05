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

    merge_range = range1: range2:
        if elemAt range1 0 <= elemAt range2 1 && 
           elemAt range1 1 >= elemAt range2 0
        then
            [[(pkgs.lib.trivial.min (elemAt range1 0) (elemAt range2 0))
             (pkgs.lib.trivial.max (elemAt range1 1) (elemAt range2 1))
            ]]
            else
            [range1 range2];
    rangesort = ranges: pkgs.lib.lists.sort (a: b: elemAt a 1 > elemAt b 1) ranges;
    merge_with_ranges = ranges: range:
        if length ranges == 0 then [range] else
        with rec {
            sorted = rangesort ranges;
            merged = merge_range range (head sorted);
            rest = tail sorted;
        };
        if length merged == 2 then (rest ++ merged) else
        merge_with_ranges rest (elemAt merged 0);


};
sum (
map (range: elemAt range 1 - elemAt range 0 + 1) 
(foldl' (merged: range: 
    merge_with_ranges merged range
) [] 
(reverse (rangesort ranges))
)
)
