let input1 = "2 8 8 5 4 2 3 1 5 5 1 2 15 13 5 14";

let stringify = (nums) => Js.Array.joinWith(" ", nums);

let parse = (input) => Array.map(int_of_string, Js.String.split(" ", input));

let getIndexOf = (needle, haystack) => {
  let returnVal = ref((-1));
  Array.iteri(
    (i, value) => needle === value && returnVal^ === (-1) ? returnVal := i : (),
    haystack
  );
  returnVal^
};

let findLargestIndex = (nums) => {
  let maxNum = Array.fold_left(max, nums[0], nums);
  getIndexOf(maxNum, nums)
};

let redistribute = (nums) => {
  let index = findLargestIndex(nums);
  let num = nums[index];
  nums[index] = 0;
  for (x in 1 to num) {
    let i = (index + x) mod Array.length(nums);
    nums[i] = nums[i] + 1
  };
  nums
};

let rec tick = (seen, iteration) => {
  let currentPattern = seen[0];
  let parsed = parse(currentPattern);
  let next = redistribute(parsed);
  let nextPattern = stringify(next);
  switch (getIndexOf(nextPattern, seen)) {
  | (-1) => tick(Array.append([|nextPattern|], seen), iteration + 1)
  | index => (iteration, index)
  }
};

let solve = (input) => tick([|input|], 1);

let solve1 = (input) => fst(solve(input));

let solve2 = (input) => snd(solve(input)) + 1;

let example1 = "0 2 7 0";

Js.log(solve1(example1)); /* 5 */

Js.log(solve1(input1)); /* 3156 */

Js.log(solve2(example1)); /* 4 */

Js.log(solve2(input1)); /* 1610 */