let example = Node.Fs.readFileSync("./example.txt", `ascii);

let input = Node.Fs.readFileSync("./input.txt", `ascii);

exception Invalid_input(string);

let parseLine = (line) =>
  switch (Js.String.split(" <-> ", line)) {
  | [|source, neighbors|] => (
      int_of_string(source),
      Array.to_list(Array.map(int_of_string, Js.String.split(", ", neighbors)))
    )
  | _ => raise(Invalid_input(input))
  };

let parse = (input) => Array.to_list(Array.map(parseLine, Js.String.split("\n", input)));

let rec iterate = (relationships, toVisit, visited) =>
  switch toVisit {
  | [] => (visited, relationships)
  | [current, ...nextToVisit] =>
    List.exists((name) => name === current, visited) ?
      iterate(relationships, nextToVisit, visited) :
      {
        let (_, neighbors) = List.find(((name, _)) => name === current, relationships);
        let nextRelationships = List.filter(((name, _)) => name !== current, relationships);
        iterate(nextRelationships, List.append(nextToVisit, neighbors), [current, ...visited])
      }
  };

let rec iterate2 = (count, relationships) => {
  let initialVisitList = [fst(List.hd(relationships))];
  let (_, nextRelationships) = iterate(relationships, initialVisitList, []);
  List.length(nextRelationships) === 0 ? count : iterate2(count + 1, nextRelationships)
};

let solve1 = (input) => List.length(fst(iterate(parse(input), [0], [])));

let solve2 = (input) => iterate2(1, parse(input));

Js.log(solve1(example)); /* 6 */

Js.log(solve1(input)); /* 380 */

Js.log(solve2(example)); /* 2 */

Js.log(solve2(input)); /* 181 */