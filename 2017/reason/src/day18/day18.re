let example = Node.Fs.readFileSync("./example.txt", `ascii);

let input = Node.Fs.readFileSync("./input.txt", `ascii);

type action =
  | PlaySound(float)
  | RecoverSound
  | SetRegister(string, float)
  | Jump(float)
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

let tick = (instruction, get) =>
  switch instruction {
  | [|"snd", x|] => PlaySound(get(x))
  | [|"set", x, y|] => SetRegister(x, get(y))
  | [|"add", x, y|] => SetRegister(x, get(x) +. get(y))
  | [|"mul", x, y|] => SetRegister(x, get(x) *. get(y))
  | [|"mod", x, y|] => SetRegister(x, mod_float(get(x), get(y)))
  | [|"rcv", x|] => get(x) === 0.0 ? Noop : RecoverSound
  | [|"jgz", x, y|] => get(x) > 0.0 ? Jump(get(y)) : Noop
  | _ => raise(Invalid_instruction(instruction))
  };

let rec runProgram = (instructions, registers, i, savedSound) =>
  switch (tick(instructions[i], getter(registers))) {
  | PlaySound(sound) => runProgram(instructions, registers, i + 1, sound)
  | RecoverSound => savedSound
  | SetRegister(key, value) =>
    runProgram(instructions, set(registers, key, value), i + 1, savedSound)
  | Jump(num) => runProgram(instructions, registers, i + int_of_float(num), savedSound)
  | Noop => runProgram(instructions, registers, i + 1, savedSound)
  };

let solve1 = (input) => runProgram(parse(input), Array.make(26, 0.0), 0, 0.0);

let driver = () => {
  Js.log(solve1(example)); /* 4 */
  Js.log(solve1(input)) /* 2951 */
};

driver();