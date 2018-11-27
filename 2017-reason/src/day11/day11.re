let input1 = Node.Fs.readFileSync("./day11-input.txt", `ascii);

exception Invalid_string(string);

let increment = ((ns, we), dir) =>
  switch dir {
  | "n" => (ns + 2, we)
  | "ne" => (ns + 1, we + 1)
  | "se" => (ns - 1, we + 1)
  | "s" => (ns - 2, we)
  | "sw" => (ns - 1, we - 1)
  | "nw" => (ns + 1, we - 1)
  | other => raise(Invalid_string(other))
  };

let distance = ((ns, we)) => (abs(ns) + abs(we)) / 2;

let solve =
  Array.fold_left(
    ((total, most), dir) => {
      let newTotal = increment(total, dir);
      (newTotal, max(most, distance(newTotal)))
    },
    ((0, 0), 0)
  );

let solve1 = (input) => distance(fst(solve(Js.String.split(",", input))));

let solve2 = (input) => snd(solve(Js.String.split(",", input)));

Js.log(solve1("ne,ne,ne")); /* 3 */

Js.log(solve1("ne,ne,sw,sw")); /* 0 */

Js.log(solve1("ne,ne,s,s")); /* 2 */

Js.log(solve1("se,sw,se,sw,sw")); /* 3 */

Js.log(solve1(input1)); /* 805 */

Js.log(solve2(input1)); /* 1535 */