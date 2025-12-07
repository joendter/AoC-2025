with builtins;
with (import ./aoclib.nix);
with rec {
    raw = readFile ./input.txt;
    lines = nicesplit "\n" raw;
    relevant_lines = filter (x: stringLength x > 0) lines;
    process_line = previous_stuff: line: 
    with rec {
        chrs = as_char_array line;
        previous = previous_stuff.state;
        in_bounds = i: 0 <= i && i < length chrs;
        the_range = (range 0 (length chrs - 1));
        state = map (i: 
        (let ii = i - 1; in
            if in_bounds ii && elemAt chrs ii == "^" then elemAt previous ii else 0) +
            (if elemAt chrs (i) != "^" then elemAt previous i else 0) +
        (let ii = i + 1; in
            if in_bounds ii && elemAt chrs ii == "^" then elemAt previous ii else 0) 
        )
        the_range;
        count = sum (map (i: bool_to_int (elemAt chrs i == "^" && elemAt previous i > 0)) the_range) + previous_stuff.count;
    };
    {state = state; count = count;};
    initial = {state = map (c: bool_to_int (c == "S")) (as_char_array (head relevant_lines)); count = 0;};
};
(
foldl' 
process_line
initial
(tail relevant_lines)
)
