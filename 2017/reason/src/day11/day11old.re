let input1 = Node.Fs.readFileSync("./day11-input.txt", `ascii);

exception Invalid_string(string);

let opposites = [|(0, 3), (1, 4), (2, 5)|];

let neighbors = [|(0, 1, 2), (1, 2, 3), (2, 3, 4), (3, 4, 5), (4, 5, 0), (5, 0, 1)|];

let emptyStore = () => [|0, 0, 0, 0, 0, 0|];

let increment = (curStore, dir) => {
  switch dir {
  | "n" => curStore[0] = curStore[0] + 1
  | "ne" => curStore[1] = curStore[1] + 1
  | "se" => curStore[2] = curStore[2] + 1
  | "s" => curStore[3] = curStore[3] + 1
  | "sw" => curStore[4] = curStore[4] + 1
  | "nw" => curStore[5] = curStore[5] + 1
  | other => raise(Invalid_string(other))
  };
  curStore
};

let reduceOpposite = (store, (a, b)) => {
  if (store[a] > store[b]) {
    store[a] = store[a] - store[b];
    store[b] = 0
  } else {
    store[b] = store[b] - store[a];
    store[a] = 0
  };
  store
};

let reduceOpposites = (s0) => Array.fold_left(reduceOpposite, s0, opposites);

let reduceNeighbor = (store, (a, b, c)) => {
  if (store[a] > store[c]) {
    store[b] = store[b] + store[c];
    store[a] = store[a] - store[c];
    store[c] = 0
  } else {
    store[b] = store[b] + store[a];
    store[c] = store[c] - store[a];
    store[a] = 0
  };
  store
};

let reduceNeighbors = (s0) => Array.fold_left(reduceNeighbor, s0, neighbors);

let getDistance = (path) => {
  let initial = Array.fold_left(increment, emptyStore(), path);
  let nums = Array.init(1, (a) => a);
  let final =
    Array.fold_left((store, _) => reduceNeighbors(reduceOpposites(store)), initial, nums);
  Array.fold_left((+), 0, final)
};

let solve1 = (input) => getDistance(Js.String.split(",", input));

let solve2 = (input) => {
  let path = Js.String.split(",", input);
  let nums = Array.init(Array.length(path), (a) => a);
  let distances = Array.map((num) => getDistance(Array.sub(path, 0, num + 1)), nums);
  Array.fold_left(max, 0, distances)
};

Js.log(solve1("ne,ne,ne")); /* 3 */

Js.log(solve1("ne,ne,sw,sw")); /* 0 */

Js.log(solve1("ne,ne,s,s")); /* 2 */

Js.log(solve1("se,sw,se,sw,sw")); /* 3 */

Js.log(solve1(input1)); /* 805 */

Js.log(solve2(input1)); /* 1535 */