let example = Node.Fs.readFileSync("./example.txt", `ascii);

let input = Node.Fs.readFileSync("./input.txt", `ascii);

exception Oops;

type direction =
  | Up
  | Down
  | Left
  | Right;

let parse = (input) => {
  let lines = Js.String.split("\n", input);
  Array.map(Js.String.split(""), lines)
};

let sum = Array.fold_left((+), 0);

let findStarting = (map) => sum(Array.mapi((i, a) => a === "|" ? i : 0, map[0]));

let getNextDirection = (map, x, y, dx, dy) =>
  switch (dx, dy) {
  | (0, _) =>
    switch (map[x + 1][y], map[x - 1][y]) {
    | (" ", " ") => raise(Oops)
    | (_, " ") => (1, 0)
    | (" ", _) => ((-1), 0)
    | _ => raise(Oops)
    }
  | (_, 0) =>
    switch (map[x][y + 1], map[x][y - 1]) {
    | (" ", " ") => raise(Oops)
    | (_, " ") => (0, 1)
    | (" ", _) => (0, (-1))
    | _ => raise(Oops)
    }
  | _ => raise(Oops)
  };

let rec iterate = (map, (str, count), (x, y), (dx, dy)) =>
  switch map[x][y] {
  | "-"
  | "|" => iterate(map, (str, count + 1), (x + dx, y + dy), (dx, dy))
  | " " => (str, count)
  | "+" =>
    let (newDx, newDy) = getNextDirection(map, x, y, dx, dy);
    iterate(map, (str, count + 1), (x + newDx, y + newDy), (newDx, newDy))
  | letter => iterate(map, (str ++ letter, count + 1), (x + dx, y + dy), (dx, dy))
  };

let solve = (input) => {
  let map = parse(input);
  let y = findStarting(map);
  iterate(map, ("", 0), (0, y), (1, 0))
};

let solve1 = (input) => fst(solve(input));

let solve2 = (input) => snd(solve(input));

let driver = () => {
  Js.log(solve1(example)); /* ABCDEF */
  Js.log(solve1(input)); /* VTWBPYAQFU */
  Js.log(solve2(example)); /* 38 */
  Js.log(solve2(input)) /* 17358 */
};

driver();