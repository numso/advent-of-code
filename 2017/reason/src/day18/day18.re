let example = Node.Fs.readFileSync("./example.txt", `ascii);

let input = Node.Fs.readFileSync("./input.txt", `ascii);

exception Invalid_instruction(array(string));

let parse = (input) => {
  let lines = Js.String.split("\n", input);
  Array.map(Js.String.split(" "), lines)
};

let tick = (instruction, (registers, i)) =>
  switch instruction {
  | [|"snd", x|] => 0
  | [|"set", x, y|] => 0
  | [|"add", x, y|] => 0
  | [|"mul", x, y|] => 0
  | [|"mod", x, y|] => 0
  | [|"rcv", x|] => 0
  | [|"jgz", x, y|] => 0
  | _ => raise(Invalid_instruction(instruction))
  };

let rec runProgram = (instructions, registers, i) => {
  let (registers, i, sound, answer) = tick(instructions[i], (registers, i));
  ()
};

let solve1 = (input) => {
  let instructions = parse(input);
  let registers = Array.make(25, 0);
  let i = 0;
  runProgram(instructions, registers, i)
};

let driver = () => {
  Js.log(solve1(example)); /* 4 */
  Js.log(solve1(input)) /*  */
};

driver();