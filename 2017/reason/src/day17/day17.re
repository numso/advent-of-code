let example = 3;

let input = 349;

let tick = (state, position, index, jumpNum) => {
  let nextPosition = (position + jumpNum) mod Array.length(state) + 1;
  let arr1 = Array.sub(state, 0, nextPosition);
  let arr2 = Array.sub(state, nextPosition, Array.length(state) - nextPosition);
  let nextState = Array.append(arr1, Array.append([|index|], arr2));
  (nextState, nextPosition)
};

let solve1 = (num) => {
  let state = ref([|0|]);
  let position = ref(0);
  for (i in 1 to 2017) {
    let (nextState, nextPosition) = tick(state^, position^, i, num);
    state := nextState;
    position := nextPosition
  };
  state^[position^ + 1]
};

let solve2 = (num) => {
  let position = ref(0);
  let answer = ref(0);
  for (length in 1 to 50000000) {
    position := (position^ + num) mod length + 1;
    if (position^ === 1) {
      answer := length
    }
  };
  answer^
};

let driver = () => {
  Js.log(solve1(example)); /* 638 */
  Js.log(solve1(input)); /* 640 */
  Js.log(solve2(input)) /* 47949463 */
};

driver();