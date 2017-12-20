let example1 = Node.Fs.readFileSync("./example1.txt", `utf8);

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

let parse = (input) => {
  let lines = Js.String.split("\n", input);
  Array.map(parseLine, lines)
};

let dist = ((x, y, z)) => abs(x) + abs(y) + abs(z);

let arrayFilter = (fn, arr) => Array.of_list(List.filter(fn, Array.to_list(arr)));

let filterBy = (fn, points) => {
  let value = (item) => fn(snd(item));
  let min = value(Array.fold_left((a, b) => value(a) < value(b) ? a : b, points[0], points));
  arrayFilter((item) => value(item) === min, points)
};

let solve1 = (input) => {
  let data = parse(input);
  let distances = Array.map(((p, v, a)) => (dist(p), dist(v), dist(a)), data);
  let one = Array.mapi((i, dists) => (i, dists), distances);
  let two = filterBy(((_, _, a)) => a, one);
  Js.log(two);
  let three = filterBy(((_, v, _)) => v, two);
  let four = filterBy(((p, _, _)) => p, three);
  switch four {
  | [|a|] => a
  | _ => raise(Not_found)
  }
};

let driver = () => {
  Js.log(solve1(example1)); /* 0 */
  Js.log(solve1(input)) /* 119 */
};

driver();