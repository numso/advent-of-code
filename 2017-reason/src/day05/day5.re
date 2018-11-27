let input1 = Node.Fs.readFileSync("./day5-input.txt", `ascii);

let parse = (input) => {
  let nums = Js.String.split("\n", input);
  Array.map(int_of_string, nums)
};

let rec tick = (fn, nums, position, count) => {
  let instruction = nums[position];
  nums[position] = fn(instruction);
  let nextPosition = position + instruction;
  nextPosition >= Array.length(nums) ? count + 1 : tick(fn, nums, nextPosition, count + 1)
};

let solve = (fn, input) => {
  let nums = parse(input);
  tick(fn, nums, 0, 0)
};

let solve1 = solve((+)(1));

let solve2 = solve((num) => num >= 3 ? num - 1 : num + 1);

let sample1 = "0\n3\n0\n1\n-3";

Js.log(solve1(sample1)); /* 5 */

Js.log(solve1(input1)); /* 325922 */

Js.log(solve2(sample1)); /* 10 */

Js.log(solve2(input1)); /* 24490906 */