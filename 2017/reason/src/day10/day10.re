let input1 = "227,169,3,166,246,201,0,47,1,255,2,254,96,3,97,144";

let example = "3,4,1,5";

let parse = (input) => Array.map(int_of_string, Js.String.split(",", input));

let buildNums = (size) => Array.init(size, (a) => a);

let swap = (arr, i1, i2) => {
  let ii1 = i1 mod Array.length(arr);
  let ii2 = i2 mod Array.length(arr);
  let temp = arr[ii1];
  arr[ii1] = arr[ii2];
  arr[ii2] = temp
};

let reverseChunk = (nums, index, length) =>
  for (i in 0 to length / 2) {
    swap(nums, index + i, index + length - i)
  };

let iterate = ((nums, index, skipSize), length) => {
  reverseChunk(nums, index, length - 1);
  (nums, index + length + skipSize, skipSize + 1)
};

let convertToAscii = (input) => Array.map((a) => int_of_char(a.[0]), Js.String.split("", input));

let smallHash = Array.fold_left(iterate);

let hexDigit = (num) =>
  switch num {
  | 15 => "f"
  | 14 => "e"
  | 13 => "d"
  | 12 => "c"
  | 11 => "b"
  | 10 => "a"
  | other => string_of_int(other)
  };

let toHex = (num) => hexDigit(num / 16) ++ hexDigit(num mod 16);

let solve1 = (size, input) => {
  let nums = buildNums(size);
  let lengths = parse(input);
  let (final, _, _) = smallHash((nums, 0, 0), lengths);
  final[0] * final[1]
};

let solve2 = (input) => {
  let parsed = convertToAscii(input);
  let lengths = Array.append(parsed, [|17, 31, 73, 47, 23|]);
  let nums = buildNums(256);
  let iterations = buildNums(64);
  let (sparseHash, _, _) =
    Array.fold_left((curState, _) => smallHash(curState, lengths), (nums, 0, 0), iterations);
  let denseHash = buildNums(16);
  for (i in 0 to 15) {
    let nextNum = ref(0);
    for (j in 0 to 15) {
      let k = i * 16 + j;
      nextNum := nextNum^ lxor sparseHash[k]
    };
    denseHash[i] = nextNum^
  };
  let hexes = Array.map(toHex, denseHash);
  Array.fold_left((++), "", hexes)
};

Js.log(solve1(5, example)); /* 12 */

Js.log(solve1(256, input1)); /* 13760 */

Js.log(solve2("")); /* a2582a3a0e66e6e86e3812dcb672a272 */

Js.log(solve2("AoC 2017")); /* 33efeb34ea91902bb2f59c9920caa6cd */

Js.log(solve2("1,2,3")); /* 3efbe78a8d82f29979031a4aa0b16a9d */

Js.log(solve2("1,2,4")); /* 63960835bcdc130f0b66d7ff4f6a5a8e */

Js.log(solve2(input1)); /* 2da93395f1a6bb3472203252e3b17fe5 */