let generatePattern = (len) => {
  let arr = Array.init(len, (num) => num + len - 1);
  let nums = Array.to_list(arr);
  let reversed = List.rev(nums);
  List.concat([List.tl(reversed), List.tl(nums)])
};

let solve = (input) => {
  let num2 = ceil(sqrt(float_of_int(input)));
  let num3 = int_of_float(num2) mod 2 === 0 ? num2 +. 1.0 : num2;
  let groupNumber = int_of_float(ceil(num3 /. 2.0));
  let length = (groupNumber - 1) * 2;
  let foo = (int_of_float(num3) - 2) * (int_of_float(num3) - 2);
  let bar = input - foo - 1;
  let index = bar mod length;
  let pattern = generatePattern(groupNumber);
  /* Instead of generating a pattern, just take the index and try to use MATH */
  input <= 1 ? 0 : List.nth(pattern, index)
};

let input1 = 361527;

Js.log(solve(1)); /* 0 */

Js.log(solve(2)); /* 1 */

Js.log(solve(3)); /* 2 */

Js.log(solve(4)); /* 1 */

Js.log(solve(12)); /* 3 */

Js.log(solve(23)); /* 2 */

Js.log(solve(1024)); /* 31 */

Js.log(solve(input1)); /* 326 */