let input = Node.Fs.readFileSync("./input.txt", `ascii);

exception Invalid_step(string);

let spin = (dancers, num) => {
  let dancersStr = Js.Array.joinWith("", dancers);
  let moveEm = String.sub(dancersStr, String.length(dancersStr) - num, num);
  let newStr = moveEm ++ String.sub(dancersStr, 0, String.length(dancersStr) - num);
  Js.String.split("", newStr)
};

let exchange = (dancers, x, y) => {
  let temp = dancers[x];
  dancers[x] = dancers[y];
  dancers[y] = temp;
  dancers
};

let partner = (dancers, a, b) => {
  let dancersStr = Js.Array.joinWith("", dancers);
  let x = String.index(dancersStr, a);
  let y = String.index(dancersStr, b);
  let temp = dancers[x];
  dancers[x] = dancers[y];
  dancers[y] = temp;
  dancers
};

let tick = (dancers, step: string) =>
  switch (step.[0], String.sub(step, 1, String.length(step) - 1)) {
  | ('s', instr) => spin(dancers, int_of_string(instr))
  | ('x', instr) =>
    switch (Js.String.split("/", instr)) {
    | [|x, y|] => exchange(dancers, int_of_string(x), int_of_string(y))
    | _ => raise(Invalid_step(step))
    }
  | ('p', instr) => partner(dancers, instr.[0], instr.[2])
  | _ => raise(Invalid_step(step))
  };

let solve1 = (inp1, inp2) => {
  let dancers = Js.String.split("", inp1);
  let dance = Js.String.split(",", inp2);
  let finished = Array.fold_left(tick, dancers, dance);
  Js.Array.joinWith("", finished)
};

let solve2 = (inp1, inp2) => {
  let dancers = ref(inp1);
  for (_ in 1 to 1000000000) {
    dancers := solve1(dancers^, inp2)
  };
  dancers
};

let driver = () => {
  Js.log(solve1("abcde", "s1,x3/4,pe/b")); /* baedc */
  Js.log(solve1("abcdefghijklmnop", input)); /* cknmidebghlajpfo */
  Js.log(solve2("abcdefghijklmnop", input)) /*  */
};

driver();