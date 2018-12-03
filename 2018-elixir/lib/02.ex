defmodule Advent02 do
  @moduledoc """
  --- Day 2: Inventory Management System ---
  You stop falling through time, catch your breath, and check the screen on the device. "Destination reached. Current Year: 1518. Current Location: North Pole Utility Closet 83N10." You made it! Now, to find those anomalies.

  Outside the utility closet, you hear footsteps and a voice. "...I'm not sure either. But now that so many people have chimneys, maybe he could sneak in that way?" Another voice responds, "Actually, we've been working on a new kind of suit that would let him fit through tight spaces like that. But, I heard that a few days ago, they lost the prototype fabric, the design plans, everything! Nobody on the team can even seem to remember important details of the project!"

  "Wouldn't they have had enough fabric to fill several boxes in the warehouse? They'd be stored together, so the box IDs should be similar. Too bad it would take forever to search the warehouse for two similar box IDs..." They walk too far away to hear any more.

  Late at night, you sneak to the warehouse - who knows what kinds of paradoxes you could cause if you were discovered - and use your fancy wrist device to quickly scan every box and produce a list of the likely candidates (your puzzle input).

  To make sure you didn't miss any, you scan the likely candidate boxes again, counting the number that have an ID containing exactly two of any letter and then separately counting those with exactly three of any letter. You can multiply those two counts together to get a rudimentary checksum and compare it to what your device predicts.

  For example, if you see the following box IDs:

  abcdef contains no letters that appear exactly two or three times.
  bababc contains two a and three b, so it counts for both.
  abbcde contains two b, but no letter appears exactly three times.
  abcccd contains three c, but no letter appears exactly two times.
  aabcdd contains two a and two d, but it only counts once.
  abcdee contains two e.
  ababab contains three a and three b, but it only counts once.
  Of these box IDs, four of them contain a letter which appears exactly twice, and three of them contain a letter which appears exactly three times. Multiplying these together produces a checksum of 4 * 3 = 12.

  What is the checksum for your list of box IDs?

  --- Part Two ---
  Confident that your list of box IDs is complete, you're ready to find the boxes full of prototype fabric.

  The boxes will have IDs which differ by exactly one character at the same position in both strings. For example, given the following box IDs:

  abcde
  fghij
  klmno
  pqrst
  fguij
  axcye
  wvxyz
  The IDs abcde and axcye are close, but they differ by two characters (the second and fourth). However, the IDs fghij and fguij differ by exactly one character, the third (h and u). Those must be the correct boxes.

  What letters are common between the two correct box IDs? (In the example above, this is found by removing the differing character from either ID, producing fgij.)
  """

  def input, do: File.read!("inputs/02.in")

  @doc ~S"""
  ## Examples
      iex> Advent02.part1("abcdef\nbababc\nabbcde\nabcccd\naabcdd\nabcdee\nababab")
      12

      iex> Advent02.part1
      6000
  """
  def part1, do: part1(input())

  def part1(input) do
    ids = String.split(input, "\n")
    twos = Enum.filter(ids, &has_two?/1)
    threes = Enum.filter(ids, &has_three?/1)
    Enum.count(twos) * Enum.count(threes)
  end

  def has_x?(str, num) do
    letters = String.graphemes(str)
    grouped = Enum.group_by(letters, & &1)
    values = Map.values(grouped)
    Enum.any?(values, &(length(&1) === num))
  end

  def has_two?(str), do: has_x?(str, 2)
  def has_three?(str), do: has_x?(str, 3)

  @doc ~S"""
  ## Examples
      iex> Advent02.part2("abcde\nfghij\nklmno\npqrst\nfguij\naxcye\nwvxyz")
      "fgij"

      iex> Advent02.part2
      "pbykrmjmizwhxlqnasfgtycdv"
  """
  def part2, do: part2(input())

  def part2(input) do
    ids = String.split(input, "\n")
    {id, id2} = find_common_pairs!(ids)
    get_common_letters(id, id2)
  end

  def find_common_pairs!([]), do: raise("No Common Pairs Found")

  def find_common_pairs!([id | rest]) do
    case Enum.find(rest, &off_by_one?(id, &1)) do
      nil -> find_common_pairs!(rest)
      id2 -> {id, id2}
    end
  end

  def off_by_one?(id1, id2), do: find_num_differences(id1, id2) == 1

  def find_num_differences(id1, id2) do
    zipped = Enum.zip(String.graphemes(id1), String.graphemes(id2))
    Enum.count(zipped, fn {a, b} -> a != b end)
  end

  def get_common_letters(id1, id2) do
    zipped = Enum.zip(String.graphemes(id1), String.graphemes(id2))
    filtered = Enum.filter(zipped, fn {a, b} -> a == b end)
    {answer, _} = Enum.unzip(filtered)
    Enum.join(answer)
  end
end
