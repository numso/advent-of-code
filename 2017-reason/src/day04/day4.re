module IntPair: Map.OrderedType = {
  type t = string;
  let compare = compare;
};

module PairsMap = Map.Make(IntPair);

external halp : string => PairsMap.key = "%identity";

let input1 = Node.Fs.readFileSync("./day4-input.txt", `ascii);

let split = (sep, str) => Array.to_list(Js.String.split(sep, str));

let checkValid = (format, input) => {
  let words = split(" ", input);
  let wordMap = ref(PairsMap.empty);
  List.for_all(
    (word) => {
      let key = halp(format(word));
      let exists = PairsMap.mem(key, wordMap^);
      wordMap := PairsMap.add(key, 1, wordMap^);
      ! exists
    },
    words
  )
};

let solve = (format, input) => {
  let isValid = checkValid(format);
  let lines = split("\n", input);
  let result = List.map((line) => isValid(line) ? 1 : 0, lines);
  List.fold_left((+), 0, result)
};

let solve1 = solve((a) => a);

let fn2 = (word) => {
  let letters = split("", word);
  let sorted = List.fast_sort(compare, letters);
  List.fold_left((a, b) => a ++ b, "", sorted)
};

let solve2 = solve(fn2);

Js.log(solve1("aa bb cc dd ee")); /* 1 */

Js.log(solve1("aa bb cc dd aa")); /* 0 */

Js.log(solve1("aa bb cc dd aaa")); /* 1 */

Js.log(solve1(input1)); /* 466 */

Js.log(solve2("abcde fghij")); /* 1 */

Js.log(solve2("abcde xyz ecdab")); /* 0 */

Js.log(solve2("a ab abc abd abf abj")); /* 1 */

Js.log(solve2("iiii oiii ooii oooi oooo")); /* 1 */

Js.log(solve2("oiii ioii iioi iiio")); /* 0 */

Js.log(solve2(input1)); /* 251 */