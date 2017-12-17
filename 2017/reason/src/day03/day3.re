module IntPair: Map.OrderedType = {
  type t = (int, int);
  let compare = ((x0, y0), (x1, y1)) =>
    switch (compare(x0, x1)) {
    | 0 => compare(y0, y1)
    | c => c
    };
};

module PairsMap = Map.Make(IntPair);

external halp : ((int, int)) => PairsMap.key = "%identity";

type direction =
  | Right
  | Up
  | Left
  | Down;

type state = {
  data: PairsMap.t(int),
  direction,
  index: int,
  x: int,
  y: int
};

type result =
  | Next(int)
  | Answer(int);

let initialState = {data: PairsMap.empty, direction: Right, index: 1, x: 0, y: 0};

let getNextCoords = (x, y, dir) =>
  switch dir {
  | Right => (x + 1, y)
  | Up => (x, y - 1)
  | Left => (x - 1, y)
  | Down => (x, y + 1)
  };

let nextDirection = (dir) =>
  switch dir {
  | Right => Up
  | Up => Left
  | Left => Down
  | Down => Right
  };

let shouldTurn = ({x, y, direction, data}) => {
  let nextDirection = nextDirection(direction);
  let (x2, y2) = getNextCoords(x, y, nextDirection);
  ! PairsMap.mem(halp((x2, y2)), data)
};

let updateState = (curState, data) => {
  let direction =
    if (curState.index === 0) {
      curState.direction
    } else if (shouldTurn(curState)) {
      nextDirection(curState.direction)
    } else {
      curState.direction
    };
  let index = curState.index + 1;
  let (x, y) = getNextCoords(curState.x, curState.y, direction);
  {data, direction, index, x, y}
};

let rec tick = (curState, fn) =>
  switch (fn(curState)) {
  | Next(num) =>
    let data = PairsMap.add(halp((curState.x, curState.y)), num, curState.data);
    let nextState = updateState(curState, data);
    tick(nextState, fn)
  | Answer(num) => num
  };

let solve = tick(initialState);

let fn1 = (num, state) => state.index === num ? Answer(abs(state.x) + abs(state.y)) : Next(1);

let get = (data, key) =>
  switch (PairsMap.find(halp(key), data)) {
  | num => num
  | exception Not_found => 0
  };

let sumSiblings = ({data, x, y}) =>
  get(data, (x + 1, y + 1))
  + get(data, (x, y + 1))
  + get(data, (x - 1, y + 1))
  + get(data, (x + 1, y))
  + get(data, (x - 1, y))
  + get(data, (x + 1, y - 1))
  + get(data, (x, y - 1))
  + get(data, (x - 1, y - 1));

let fn2 = (num, state) =>
  switch (state.x, state.y) {
  | (0, 0) => Next(1)
  | _ =>
    let currentNumber = sumSiblings(state);
    currentNumber > num ? Answer(currentNumber) : Next(currentNumber)
  };

let solve1 = (num) => solve(fn1(num));

let solve2 = (num) => solve(fn2(num));

let input1 = 361527;

Js.log(solve1(1)); /* 0 */

Js.log(solve1(2)); /* 1 */

Js.log(solve1(3)); /* 2 */

Js.log(solve1(4)); /* 1 */

Js.log(solve1(12)); /* 3 */

Js.log(solve1(23)); /* 2 */

Js.log(solve1(1024)); /* 31 */

Js.log(solve1(input1)); /* 326 */

Js.log(solve2(1)); /* 1 */

Js.log(solve2(2)); /* 1 */

Js.log(solve2(3)); /* 2 */

Js.log(solve2(4)); /* 4 */

Js.log(solve2(5)); /* 5 */

Js.log(solve2(input1)); /* 363010 */