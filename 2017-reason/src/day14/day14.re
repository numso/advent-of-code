let example = "flqrgnkx";

let input = "jzgqcdpd";

exception Invalid_hex(string);

let to_binary = (hex) =>
  switch hex {
  | "0" => "0000"
  | "1" => "0001"
  | "2" => "0010"
  | "3" => "0011"
  | "4" => "0100"
  | "5" => "0101"
  | "6" => "0110"
  | "7" => "0111"
  | "8" => "1000"
  | "9" => "1001"
  | "a" => "1010"
  | "b" => "1011"
  | "c" => "1100"
  | "d" => "1101"
  | "e" => "1110"
  | "f" => "1111"
  | other => raise(Invalid_hex(other))
  };

let generateBinaryLine = (key, num) => {
  let hexString = Day10.solve2(key ++ "-" ++ num);
  let binaryString = Js.Array.joinWith("", Array.map(to_binary, Js.String.split("", hexString)));
  let bits = Js.String.split("", binaryString);
  Array.map(int_of_string, bits)
};

let generateBinaryMap = (input) => {
  let looper = Array.init(128, string_of_int);
  Array.map(generateBinaryLine(input), looper)
};

let sum = Array.fold_left((+), 0);

let needsRemoved = (binary, x, y) =>
  x >= 0 && y >= 0 && x <= 127 && y <= 127 && binary[x][y] === 1;

let rec removeGroup = (binary, toRemove) =>
  switch toRemove {
  | [] => ()
  | [(x, y), ...others] =>
    needsRemoved(binary, x, y) ?
      {
        binary[x][y] = 0;
        removeGroup(binary, List.append(others, [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]))
      } :
      removeGroup(binary, others)
  };

let solve1 = (input) => sum(Array.map(sum, generateBinaryMap(input)));

let solve2 = (input) => {
  let binary = generateBinaryMap(input);
  let count = ref(0);
  Array.iteri(
    (i, row) =>
      Array.iteri(
        (j, column) =>
          column === 0 ?
            () :
            {
              count := count^ + 1;
              removeGroup(binary, [(i, j)])
            },
        row
      ),
    binary
  );
  count^
};

let driver = () => {
  Js.log(solve1(example)); /* 8108 */
  Js.log(solve1(input)); /* 8074 */
  Js.log(solve2(example)); /* 1242 */
  Js.log(solve2(input)) /* 1212 */
};

driver();