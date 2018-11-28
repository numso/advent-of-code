defmodule Advent05 do
  @moduledoc """
  --- Day 5: Doesn't He Have Intern-Elves For This? ---
  Santa needs help figuring out which strings in his text file are naughty or nice.

  A nice string is one with all of the following properties:

  It contains at least three vowels (aeiou only), like aei, xazegov, or aeiouaeiouaeiou.
  It contains at least one letter that appears twice in a row, like xx, abcdde (dd), or aabbccdd (aa, bb, cc, or dd).
  It does not contain the strings ab, cd, pq, or xy, even if they are part of one of the other requirements.
  For example:

  ugknbfddgicrmopn is nice because it has at least three vowels (u...i...o...), a double letter (...dd...), and none of the disallowed substrings.
  aaa is nice because it has at least three vowels and a double letter, even though the letters used by different rules overlap.
  jchzalrnumimnmhp is naughty because it has no double letter.
  haegwjzuvuyypxyu is naughty because it contains the string xy.
  dvszwmarrgswjxmb is naughty because it contains only one vowel.
  How many strings are nice?

  --- Part Two ---
  Realizing the error of his ways, Santa has switched to a better model of determining whether a string is naughty or nice. None of the old rules apply, as they are all clearly ridiculous.

  Now, a nice string is one with all of the following properties:

  It contains a pair of any two letters that appears at least twice in the string without overlapping, like xyxy (xy) or aabcdefgaa (aa), but not like aaa (aa, but it overlaps).
  It contains at least one letter which repeats with exactly one letter between them, like xyx, abcdefeghi (efe), or even aaa.
  For example:

  qjhvhtzxzqqjkmpb is nice because is has a pair that appears twice (qj) and a letter that repeats with exactly one letter between them (zxz).
  xxyxx is nice because it has a pair that appears twice and a letter that repeats with one between, even though the letters used by each rule overlap.
  uurcxstgmygtbstg is naughty because it has a pair (tg) but no repeat with a single letter between them.
  ieodomkazucvgmuy is naughty because it has a repeating letter with one between (odo), but no pair that appears twice.
  How many strings are nice under these new rules?
  """

  def input, do: File.read!("inputs/05.in")

  @doc """
  ## Examples
      iex> Advent05.part1("ugknbfddgicrmopn")
      1

      iex> Advent05.part1("aaa")
      1

      iex> Advent05.part1("jchzalrnumimnmhp")
      0

      iex> Advent05.part1("haegwjzuvuyypxyu")
      0

      iex> Advent05.part1("dvszwmarrgswjxmb")
      0

      iex> Advent05.part1
      238
  """
  def part1, do: part1(input())

  def part1(input) do
    strings = String.split(input, "\n")
    nums = Enum.map(strings, fn str -> if is_nice?(str), do: 1, else: 0 end)
    Enum.sum(nums)
  end

  def is_vowel(letter), do: String.contains?(letter, ["a", "e", "i", "o", "u"])

  def is_nice?(str) do
    chars = String.graphemes(str)
    num_vowels = length(Enum.filter(chars, &is_vowel/1))
    has_double = chars != Enum.dedup(chars)
    has_bad_double = String.contains?(str, ["ab", "cd", "pq", "xy"])
    num_vowels >= 3 && has_double && !has_bad_double
  end

  @doc """
  ## Examples
      iex> Advent05.part2("qjhvhtzxzqqjkmpb")
      1

      iex> Advent05.part2("xxyxx")
      1

      iex> Advent05.part2("uurcxstgmygtbstg")
      0

      iex> Advent05.part2("ieodomkazucvgmuy")
      0

      iex> Advent05.part2
      69
  """
  def part2, do: part2(input())

  def part2(input) do
    strings = String.split(input, "\n")
    nums = Enum.map(strings, fn str -> if is_nice_v2?(str), do: 1, else: 0 end)
    Enum.sum(nums)
  end

  def is_nice_v2?(str) do
    chars = String.graphemes(str)
    has_duplicate?(chars) && has_repeating?(chars)
  end

  # def has_duplicate?([x, y | rest]) when String.contains?(List.to_string(rest), x <> y), do: true
  def has_duplicate?([x, y | rest]) do
    duplicate_exists = String.contains?(List.to_string(rest), x <> y)
    if duplicate_exists, do: true, else: has_duplicate?([y] ++ rest)
  end

  def has_duplicate?([_ | rest]), do: has_duplicate?(rest)
  def has_duplicate?([]), do: false

  def has_repeating?([x, _, x | _]), do: true
  def has_repeating?([_ | rest]), do: has_repeating?(rest)
  def has_repeating?([]), do: false
end
