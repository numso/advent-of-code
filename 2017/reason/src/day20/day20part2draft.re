let example1 = Node.Fs.readFileSync("./example1.txt", `utf8);

let example2 = Node.Fs.readFileSync("./example2.txt", `utf8);

let input = Node.Fs.readFileSync("./input.txt", `utf8);

let triplet = (str) => {
  let substr = String.sub(str, 3, String.length(str) - 4);
  let [|x, y, z|] = Js.String.split(",", substr);
  (int_of_string(x), int_of_string(y), int_of_string(z))
};

let parseLine = (line) => {
  let [|p, v, a|] = Js.String.split(">, ", line);
  (triplet(p ++ ">"), triplet(v ++ ">"), triplet(a))
};

let parse = (input) => Array.map(parseLine, Js.String.split("\n", input));

let dist = ((x, y, z)) => abs(x) + abs(y) + abs(z);

let arrayFilter = (fn, arr) => Array.of_list(List.filter(fn, Array.to_list(arr)));

let tick = (((x, y, z), (dx, dy, dz), (ax, ay, az))) => (
  (x + dx + ax, y + dy + ay, z + dz + az),
  (dx + ax, dy + ay, dz + az),
  (ax, ay, az)
);

let sum = Array.fold_left((+), 0);

let rec simulate = (points, iterations) =>
  switch iterations {
  | 0 => points
  | _ =>
    let nextPoints = Array.map(tick, points);
    simulate(nextPoints, iterations - 1)
  };

let solve1 = (input) => {
  let data = parse(input);
  let lastPoints = simulate(data, 1000000);
  let distances = Array.map(((pos, _, _)) => dist(pos), lastPoints);
  let min = Array.fold_left((a, b) => a < b ? a : b, distances[0], distances);
  sum(Array.mapi((i, value) => value === min ? i : 0, distances))
};

let solve2 = (a) => 0;

let driver = () => {
  Js.log(solve1(example1)); /* 0 */
  Js.log(solve1(input)); /* 119 */
  Js.log(solve2(example2)); /* 1 */
  Js.log(solve2(input)) /*  */
};

driver();