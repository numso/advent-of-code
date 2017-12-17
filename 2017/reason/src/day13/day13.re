let example = Node.Fs.readFileSync("./example.txt", `ascii);

let input = Node.Fs.readFileSync("./input.txt", `ascii);

exception Invalid_input(string);

let parseLine = (line) =>
  switch (Js.String.split(": ", line)) {
  | [|depth, range|] => (int_of_string(depth), int_of_string(range))
  | _ => raise(Invalid_input(line))
  };

let parse = (input) => Array.map(parseLine, Js.String.split("\n", input));

let collides = (delay, (depth, range)) => (depth + delay) mod ((range - 1) * 2) === 0;

let collidesAdd = (delay, (depth, range)) => collides(delay, (depth, range)) ? depth * range : 0;

let solve1 = (input) => {
  let data = parse(input);
  let datums = Array.map(collidesAdd(0), data);
  Array.fold_left((+), 0, datums)
};

let rec solve2 = (delay, input) => {
  let data = Array.to_list(parse(input));
  List.exists(collides(delay), data) ? solve2(delay + 1, input) : delay
};

Js.log(solve1(example)); /* 24 */

Js.log(solve1(input)); /* 1960 */

Js.log(solve2(0, example)); /* 10 */

Js.log(solve2(0, input)); /* 3903378 */