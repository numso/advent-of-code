let split = (sep, str) => Array.to_list(Js.String.split(sep, str));

let parse = (input) => {
  let values = input |> split("\n") |> List.map(split(" "));
  List.map(List.map(int_of_string), values)
};

let applyMany = (fn, nums) => List.fold_left(fn, List.nth(nums, 0), nums);

let getMinMaxDiff = (list) => applyMany(max, list) - applyMany(min, list);

let rec getDivisibleResult = (list) => {
  let [num, ...rest] = list;
  switch (List.find((a) => num mod a === 0 || a mod num === 0, rest)) {
  | res => res mod num === 0 ? res / num : num / res
  | exception Not_found => getDivisibleResult(rest)
  }
};

let sum = List.fold_left((+), 0);

let solve = (fn, input) => sum(List.map(fn, input));

let solve1 = solve(getMinMaxDiff);

let solve2 = solve(getDivisibleResult);

let example1 = "5 1 9 5\n7 5 3\n2 4 6 8";

let example2 = "5 9 2 8\n9 4 7 3\n3 8 6 5";

let input1 = "5048 177 5280 5058 4504 3805 5735 220 4362 1809 1521 230 772 1088 178 1794\n6629 3839 258 4473 5961 6539 6870 4140 4638 387 7464 229 4173 5706 185 271\n5149 2892 5854 2000 256 3995 5250 249 3916 184 2497 210 4601 3955 1110 5340\n153 468 550 126 495 142 385 144 165 188 609 182 439 545 608 319\n1123 104 567 1098 286 665 1261 107 227 942 1222 128 1001 122 69 139\n111 1998 1148 91 1355 90 202 1522 1496 1362 1728 109 2287 918 2217 1138\n426 372 489 226 344 431 67 124 120 386 348 153 242 133 112 369\n1574 265 144 2490 163 749 3409 3086 154 151 133 990 1002 3168 588 2998\n173 192 2269 760 1630 215 966 2692 3855 3550 468 4098 3071 162 329 3648\n1984 300 163 5616 4862 586 4884 239 1839 169 5514 4226 5551 3700 216 5912\n1749 2062 194 1045 2685 156 3257 1319 3199 2775 211 213 1221 198 2864 2982\n273 977 89 198 85 1025 1157 1125 69 94 919 103 1299 998 809 478\n1965 6989 230 2025 6290 2901 192 215 4782 6041 6672 7070 7104 207 7451 5071\n1261 77 1417 1053 2072 641 74 86 91 1878 1944 2292 1446 689 2315 1379\n296 306 1953 3538 248 1579 4326 2178 5021 2529 794 5391 4712 3734 261 4362\n2426 192 1764 288 4431 2396 2336 854 2157 216 4392 3972 229 244 4289 1902";

Js.log(solve1(parse(example1))); /* 18 */

Js.log(solve1(parse(input1))); /* 58975 */

Js.log(solve2(parse(example2))); /* 9 */

Js.log(solve2(parse(input1))); /* 308 */