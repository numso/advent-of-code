let input1 = Node.Fs.readFileSync("./day7-input.txt", `ascii);

let example1 = Node.Fs.readFileSync("./day7-example.txt", `ascii);

let parseWeight = (str) => int_of_string(String.sub(str, 1, String.length(str) - 2));

let parseLine = (line) =>
  switch (Js.String.split(" ", line)) {
  | [|parent, weight|] => (parent, parseWeight(weight), [||])
  | other =>
    let [|_, children|] = Js.String.split(" -> ", line);
    (other[0], parseWeight(other[1]), Js.String.split(", ", children))
  };

exception Did_not_match(array((int, (string, int, array(string)))));

let parse = (input) => {
  let lines = Js.String.split("\n", input);
  Array.map(parseLine, lines)
};

let solve1 = (input) => {
  let parsed = parse(input);
  let parents = Array.to_list(Array.map(((a, _, _)) => a, parsed));
  let childGroups = Array.map(((_, _, a)) => a, parsed);
  let children = Array.to_list(Array.fold_left(Array.append, [||], childGroups));
  let roots = List.filter((name) => ! List.exists((dep) => dep === name, children), parents);
  List.hd(roots)
};

let getChild = (items, name) => List.find(((other, _, _)) => other === name, items);

let rec checkWeight = (items, name) => {
  let (_, weight, children) = getChild(items, name);
  switch children {
  | [||] => weight
  | _ =>
    let weights =
      Array.map((child) => (checkWeight(items, child), getChild(items, child)), children);
    let childWeight =
      Array.fold_left(
        (memo, (nextWeight, _)) => memo === nextWeight ? memo : raise(Did_not_match(weights)),
        fst(weights[0]),
        weights
      );
    weight + childWeight * Array.length(children)
  }
};

let separateOddOneOut = (input) => {
  let a = fst(input[0]) === fst(input[1]);
  let b = fst(input[1]) === fst(input[2]);
  switch (a, b) {
  | (true, _) => (input[2], input[0])
  | (_, true) => (input[0], input[1])
  | _ => (input[1], input[0])
  }
};

let solve2 = (input) => {
  let root = solve1(input);
  let parsed = Array.to_list(parse(input));
  try (checkWeight(parsed, root)) {
  | Did_not_match(children) =>
    let (bad, normal) = separateOddOneOut(children);
    let offset = fst(bad) - fst(normal);
    let (_, weight, _) = snd(bad);
    weight - offset
  }
};

Js.log(solve1(example1)); /* tknk */

Js.log(solve1(input1)); /* vtzay */

Js.log(solve2(example1)); /* 60 */

Js.log(solve2(input1)); /* 910 */