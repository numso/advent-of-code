module StringPair: Map.OrderedType = {
  type t = string;
  let compare = compare;
};

module PairsMap = Map.Make(StringPair);

external halp : string => PairsMap.key = "%identity";

exception Invalid_String_Format(string);

exception Unknown_Comparator(string);

let input1 = Node.Fs.readFileSync("./day8-input.txt", `ascii);

let example1 = Node.Fs.readFileSync("./day8-example.txt", `ascii);

let readState = (reg, state) =>
  switch (PairsMap.find(halp(reg), state)) {
  | value => value
  | exception Not_found => 0
  };

let writeState = (reg, fn, state) => {
  let val_ = readState(reg, state);
  PairsMap.add(halp(reg), fn(val_), state)
};

let runComparison = (val_, comp, unparsedNum) => {
  let num = int_of_string(unparsedNum);
  switch comp {
  | ">" => val_ > num
  | "<" => val_ < num
  | ">=" => val_ >= num
  | "<=" => val_ <= num
  | "==" => val_ === num
  | "!=" => val_ !== num
  | _ => raise(Unknown_Comparator(comp))
  }
};

let getMax = (state) => PairsMap.fold((_) => max, state, 0);

let runInstruction = ((maxVal, state), instr) =>
  switch (Js.String.split(" ", instr)) {
  | [|reg, comp, num, _, reg2, comp2, num2|] =>
    let truthy = runComparison(readState(reg2, state), comp2, num2);
    let operator = comp === "inc" ? (+) : (-);
    let nextState =
      truthy ? writeState(reg, (num2) => operator(num2, int_of_string(num)), state) : state;
    let nextMax = max(maxVal, getMax(nextState));
    (nextMax, nextState)
  | _ => raise(Invalid_String_Format(instr))
  };

let solve = (input) => {
  let instructions = Js.String.split("\n", input);
  Array.fold_left(runInstruction, (0, PairsMap.empty), instructions)
};

let solve1 = (input) => getMax(snd(solve(input)));

let solve2 = (input) => fst(solve(input));

Js.log(solve1(example1)); /* 1 */

Js.log(solve1(input1)); /* 5849 */

Js.log(solve2(example1)); /* 10 */

Js.log(solve2(input1)); /* 6702 */