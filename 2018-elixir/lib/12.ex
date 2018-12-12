defmodule Advent12 do
  @moduledoc """
  --- Day 12: Subterranean Sustainability ---
  The year 518 is significantly more underground than your history books implied. Either that, or you've arrived in a vast cavern network under the North Pole.

  After exploring a little, you discover a long tunnel that contains a row of small pots as far as you can see to your left and right. A few of them contain plants - someone is trying to grow things in these geothermally-heated caves.

  The pots are numbered, with 0 in front of you. To the left, the pots are numbered -1, -2, -3, and so on; to the right, 1, 2, 3.... Your puzzle input contains a list of pots from 0 to the right and whether they do (#) or do not (.) currently contain a plant, the initial state. (No other pots currently contain plants.) For example, an initial state of #..##.... indicates that pots 0, 3, and 4 currently contain plants.

  Your puzzle input also contains some notes you find on a nearby table: someone has been trying to figure out how these plants spread to nearby pots. Based on the notes, for each generation of plants, a given pot has or does not have a plant based on whether that pot (and the two pots on either side of it) had a plant in the last generation. These are written as LLCRR => N, where L are pots to the left, C is the current pot being considered, R are the pots to the right, and N is whether the current pot will have a plant in the next generation. For example:

  A note like ..#.. => . means that a pot that contains a plant but with no plants within two pots of it will not have a plant in it during the next generation.
  A note like ##.## => . means that an empty pot with two plants on each side of it will remain empty in the next generation.
  A note like .##.# => # means that a pot has a plant in a given generation if, in the previous generation, there were plants in that pot, the one immediately to the left, and the one two pots to the right, but not in the ones immediately to the right and two to the left.
  It's not clear what these plants are for, but you're sure it's important, so you'd like to make sure the current configuration of plants is sustainable by determining what will happen after 20 generations.

  For example, given the following input:

  initial state: #..#.#..##......###...###

  ...## => #
  ..#.. => #
  .#... => #
  .#.#. => #
  .#.## => #
  .##.. => #
  .#### => #
  #.#.# => #
  #.### => #
  ##.#. => #
  ##.## => #
  ###.. => #
  ###.# => #
  ####. => #
  For brevity, in this example, only the combinations which do produce a plant are listed. (Your input includes all possible combinations.) Then, the next 20 generations will look like this:

                  1         2         3
        0         0         0         0
  0: ...#..#.#..##......###...###...........
  1: ...#...#....#.....#..#..#..#...........
  2: ...##..##...##....#..#..#..##..........
  3: ..#.#...#..#.#....#..#..#...#..........
  4: ...#.#..#...#.#...#..#..##..##.........
  5: ....#...##...#.#..#..#...#...#.........
  6: ....##.#.#....#...#..##..##..##........
  7: ...#..###.#...##..#...#...#...#........
  8: ...#....##.#.#.#..##..##..##..##.......
  9: ...##..#..#####....#...#...#...#.......
  10: ..#.#..#...#.##....##..##..##..##......
  11: ...#...##...#.#...#.#...#...#...#......
  12: ...##.#.#....#.#...#.#..##..##..##.....
  13: ..#..###.#....#.#...#....#...#...#.....
  14: ..#....##.#....#.#..##...##..##..##....
  15: ..##..#..#.#....#....#..#.#...#...#....
  16: .#.#..#...#.#...##...#...#.#..##..##...
  17: ..#...##...#.#.#.#...##...#....#...#...
  18: ..##.#.#....#####.#.#.#...##...##..##..
  19: .#..###.#..#.#.#######.#.#.#..#.#...#..
  20: .#....##....#####...#######....#.#..##.
  The generation is shown along the left, where 0 is the initial state. The pot numbers are shown along the top, where 0 labels the center pot, negative-numbered pots extend to the left, and positive pots extend toward the right. Remember, the initial state begins at pot 0, which is not the leftmost pot used in this example.

  After one generation, only seven plants remain. The one in pot 0 matched the rule looking for ..#.., the one in pot 4 matched the rule looking for .#.#., pot 9 matched .##.., and so on.

  In this example, after 20 generations, the pots shown as # contain plants, the furthest left of which is pot -2, and the furthest right of which is pot 34. Adding up all the numbers of plant-containing pots after the 20th generation produces 325.

  After 20 generations, what is the sum of the numbers of all pots which contain a plant?

  --- Part Two ---
  You realize that 20 generations aren't enough. After all, these plants will need to last another 1500 years to even reach your timeline, not to mention your future.

  After fifty billion (50000000000) generations, what is the sum of the numbers of all pots which contain a plant?
  """

  def sample, do: File.read!("inputs/12-sample.in")

  def input, do: File.read!("inputs/12.in")

  @doc """
  ## Examples
      iex> Advent12.part1(Advent12.sample())
      325

      iex> Advent12.part1
      4818
  """
  def part1, do: part1(input())

  def part1(input) do
    length = 20
    {state, rules} = parse(input)

    {last_gen, offset} =
      Enum.reduce(1..length, {state, 0}, fn _, {gen, offset} ->
        padded = String.graphemes("...." <> gen <> "....")
        dotted = get_next_gen(padded, rules)
        strip_dots(dotted, offset)
      end)

    count_gens(last_gen, offset)
  end

  def count_gens("." <> rest, num), do: count_gens(rest, num + 1)
  def count_gens("#" <> rest, num), do: num + count_gens(rest, num + 1)
  def count_gens("", _), do: 0

  def get_next_gen([a, b, c, d, e | rest], rules) do
    next_char = Map.get(rules, a <> b <> c <> d <> e, ".")
    next_char <> get_next_gen([b, c, d, e | rest], rules)
  end

  def get_next_gen(_, _), do: ""

  def strip_dots(gen, offset) do
    [leading] = Regex.run(~r/^\.*/, gen)
    stripped = String.replace(gen, ~r/^\.*|\.*$/, "")
    {stripped, offset - 2 + String.length(leading)}
  end

  def parse(["initial state: " <> state, _ | rest]) do
    split = Enum.map(rest, &String.split(&1, " => "))
    rules = for [key, val] <- split, into: %{}, do: {key, val}
    {state, rules}
  end

  def parse(input), do: parse(String.split(input, "\n"))

  @doc """
  ## Examples
      iex> Advent12.part2(Advent12.sample())
      999999999374

      iex> Advent12.part2
      5100000001377
  """
  def part2, do: part2(input())

  def part2(input) do
    {state, rules} = parse(input)
    {initial, next, i} = find_match(rules, state)
    increment = next - initial
    initial + (50_000_000_000 - i) * increment
  end

  def find_match(rules, gen, offset \\ 0, i \\ 0) do
    padded = String.graphemes("...." <> gen <> "....")
    dotted = get_next_gen(padded, rules)
    {next_gen, next_offset} = strip_dots(dotted, offset)

    case next_gen == gen do
      true ->
        {count_gens(gen, offset), count_gens(next_gen, next_offset), i}

      false ->
        find_match(rules, next_gen, next_offset, i + 1)
    end
  end
end
