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

let tick = (dancers, step) =>
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

let rec recSolve2 = (memo, dancers, dance) => {
  let nextDancers = solve1(dancers, dance);
  switch (List.find((item) => item === nextDancers, memo)) {
  | _ =>
    let i = 1000000000 mod List.length(memo);
    Array.of_list(memo)[i]
  | exception Not_found => recSolve2(List.append(memo, [nextDancers]), nextDancers, dance)
  }
};

let solve2 = (dancers) => recSolve2([dancers], dancers);

let driver = () => {
  Js.log(solve1("abcde", "s1,x3/4,pe/b")); /* baedc */
  Js.log(solve1("abcdefghijklmnop", input)); /* cknmidebghlajpfo */
  Js.log(solve2("abcdefghijklmnop", input)) /* cbolhmkgfpenidaj */
};

driver();