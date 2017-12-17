let example = (65.0, 8921.0);

let input = (591.0, 393.0);

let to_16_bit_binary = (num) => {
  let binaryStr = "0000000000000000" ++ Js.Float.toStringWithRadix(~radix=2, num);
  String.sub(binaryStr, String.length(binaryStr) - 16, 16)
};

let solve = (getNext, iterations, (gen1, gen2)) => {
  let count = [|0|];
  let values = [|gen1, gen2|];
  for (_ in 1 to iterations) {
    values[0] = getNext(values[0], 16807.0, 4.0);
    values[1] = getNext(values[1], 48271.0, 8.0);
    if (to_16_bit_binary(values[0]) === to_16_bit_binary(values[1])) {
      count[0] = count[0] + 1
    }
  };
  count[0]
};

let getNextValid1 = (start, multiplier, _) => mod_float(start *. multiplier, 2147483647.0);

let rec getNextValid2 = (start, multiplier, multiple) => {
  let next = getNextValid1(start, multiplier, multiple);
  mod_float(next, multiple) === 0.0 ? next : getNextValid2(next, multiplier, multiple)
};

let solve1 = solve(getNextValid1);

let solve2 = solve(getNextValid2);

let driver = () => {
  Js.log(solve1(5, example)); /* 1 */
  Js.log(solve1(40000000, example)); /* 588 */
  Js.log(solve1(40000000, input)); /* 619 */
  Js.log(solve2(5, example)); /* 0 */
  Js.log(solve2(5000000, example)); /* 309 */
  Js.log(solve2(5000000, input)) /* 290 */
};

driver();