let input1 = Node.Fs.readFileSync("./day9-input.txt", `ascii);

type state =
  | Normal
  | Garbage
  | Ignore;

let tick = ((curState, score, num, garbage), char) =>
  switch (curState, char) {
  | (Ignore, _) => (Garbage, score, num, garbage)
  | (Garbage, "!") => (Ignore, score, num, garbage)
  | (Garbage, ">") => (Normal, score, num, garbage)
  | (Garbage, _) => (Garbage, score, num, garbage + 1)
  | (Normal, "{") => (Normal, score + num, num + 1, garbage)
  | (Normal, "}") => (Normal, score, num - 1, garbage)
  | (Normal, "<") => (Garbage, score, num, garbage)
  | _ => (Normal, score, num, garbage)
  };

let solve = (input) => {
  let chars = Js.String.split("", input);
  let (_, score, _, garbage) = Array.fold_left(tick, (Normal, 0, 1, 0), chars);
  (score, garbage)
};

let solve1 = (input) => fst(solve(input));

let solve2 = (input) => snd(solve(input));

Js.log(solve1("{}")); /* 1 */

Js.log(solve1("{{{}}}")); /* 6 */

Js.log(solve1("{{},{}}")); /* 5 */

Js.log(solve1("{{{},{},{{}}}}")); /* 16 */

Js.log(solve1("{<a>,<a>,<a>,<a>}")); /* 1 */

Js.log(solve1("{{<ab>},{<ab>},{<ab>},{<ab>}}")); /* 9 */

Js.log(solve1("{{<!!>},{<!!>},{<!!>},{<!!>}}")); /* 9 */

Js.log(solve1("{{<a!>},{<a!>},{<a!>},{<ab>}}")); /* 3 */

Js.log(solve1(input1)); /* 14212 */

Js.log(solve2("<>")); /* 0 */

Js.log(solve2("<random characters>")); /* 17 */

Js.log(solve2("<<<<>")); /* 3 */

Js.log(solve2("<{!>}>")); /* 2 */

Js.log(solve2("<!!>")); /* 0 */

Js.log(solve2("<!!!>>")); /* 0 */

Js.log(solve2("<{o\"i!a,<{i<a>")); /* 1 */

Js.log(solve2(input1)); /* 6569 */