let example = Node.Fs.readFileSync("./example2.txt", `ascii);

let input = Node.Fs.readFileSync("./input.txt", `ascii);

type action =
  | Send(float)
  | Receive(string)
  | SetRegister(string, float)
  | Jump(float)
  | Wait
  | Noop;

type code =
  | Wait
  | Count
  | Noop;

exception Invalid_instruction(array(string));

let parse = (input) => {
  let lines = Js.String.split("\n", input);
  Array.map(Js.String.split(" "), lines)
};

let letters = Js.String.split("", "abcdefghijklmnopqrstuvwxyz");

let sum = Array.fold_left((+), 0);

let indexFor = (b) => sum(Array.mapi((i, a) => a === b ? i : 0, letters));

let getter = (registers, letter) =>
  switch (float_of_string(letter)) {
  | num => num
  | exception (Failure("float_of_string")) => registers[indexFor(letter)]
  };

let set = (registers, key, value) => {
  registers[indexFor(key)] = value;
  registers
};

let tick = (instruction, get, queue) =>
  switch instruction {
  | [|"snd", x|] => Send(get(x))
  | [|"set", x, y|] => SetRegister(x, get(y))
  | [|"add", x, y|] => SetRegister(x, get(x) +. get(y))
  | [|"mul", x, y|] => SetRegister(x, get(x) *. get(y))
  | [|"mod", x, y|] => SetRegister(x, mod_float(get(x), get(y)))
  | [|"rcv", x|] => List.length(queue) === 0 ? Wait : Receive(x)
  | [|"jgz", x, y|] => get(x) > 0.0 ? Jump(get(y)) : Noop
  | _ => raise(Invalid_instruction(instruction))
  };

let evaluate = ((instructions, registers, i), q, q2) =>
  switch (tick(instructions[i], getter(registers), q)) {
  | SetRegister(key, value) => ((instructions, set(registers, key, value), i + 1), q, q2, Noop)
  | Jump(num) => ((instructions, registers, i + int_of_float(num)), q, q2, Noop)
  | Noop => ((instructions, registers, i + 1), q, q2, Noop)
  | Send(value) => ((instructions, registers, i + 1), q, List.append(q2, [value]), Count)
  | Receive(key) => ((instructions, set(registers, key, List.hd(q)), i + 1), List.tl(q), q2, Noop)
  | Wait => ((instructions, registers, i), q, q2, Wait)
  };

let rec runPrograms = (args1, args2, queue1, queue2, count) => {
  let (nextArgs1, nqueue1, nqueue2, status1) = evaluate(args1, queue1, queue2);
  let (nextArgs2, nextQueue2, nextQueue1, status2) = evaluate(args2, nqueue2, nqueue1);
  switch (status1, status2) {
  | (Wait, Wait) => count
  | (_, Count) => runPrograms(nextArgs1, nextArgs2, nextQueue1, nextQueue2, count + 1)
  | _ => runPrograms(nextArgs1, nextArgs2, nextQueue1, nextQueue2, count)
  }
};

let solve2 = (input) => {
  let instructions = parse(input);
  let registers1 = Array.make(26, 0.0);
  let registers2 = Array.make(26, 0.0);
  registers2[indexFor("p")] = 1.0;
  let args1 = (instructions, registers1, 0);
  let args2 = (instructions, registers2, 0);
  runPrograms(args1, args2, [], [], 0)
};

let driver = () => {
  Js.log(solve2(example)); /* 3 */
  Js.log(solve2(input)) /* 7366 */
};

driver();