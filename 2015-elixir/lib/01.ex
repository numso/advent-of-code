defmodule Advent01 do
  @moduledoc """
  --- Day 1: Not Quite Lisp ---
  Santa was hoping for a white Christmas, but his weather machine's "snow" function is powered by stars, and he's fresh out! To save Christmas, he needs you to collect fifty stars by December 25th.

  Collect stars by helping Santa solve puzzles. Two puzzles will be made available on each day in the advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!

  Here's an easy puzzle to warm you up.

  Santa is trying to deliver presents in a large apartment building, but he can't find the right floor - the directions he got are a little confusing. He starts on the ground floor (floor 0) and then follows the instructions one character at a time.

  An opening parenthesis, (, means he should go up one floor, and a closing parenthesis, ), means he should go down one floor.

  The apartment building is very tall, and the basement is very deep; he will never find the top or bottom floors.

  For example:

  (()) and ()() both result in floor 0.
  ((( and (()(()( both result in floor 3.
  ))((((( also results in floor 3.
  ()) and ))( both result in floor -1 (the first basement level).
  ))) and )())()) both result in floor -3.
  To what floor do the instructions take Santa?
  """

  def input, do: File.read!("inputs/01.in")

  @doc """
  ## Examples
      iex> Advent01.part1("(())")
      0

      iex> Advent01.part1("()()")
      0

      iex> Advent01.part1("(((")
      3

      iex> Advent01.part1("(()(()(")
      3

      iex> Advent01.part1("))(((((")
      3

      iex> Advent01.part1("())")
      -1

      iex> Advent01.part1("))(")
      -1

      iex> Advent01.part1(")))")
      -3

      iex> Advent01.part1(")())())")
      -3

      iex> Advent01.part1()
      74
  """
  def part1, do: part1(input())

  def part1(input) do
    parens = String.graphemes(input)
    countFloors(parens)
  end

  def countFloors(parens), do: countFloors(0, parens)
  def countFloors(count, []), do: count

  def countFloors(count, ["(" | rest]), do: countFloors(count + 1, rest)
  def countFloors(count, [")" | rest]), do: countFloors(count - 1, rest)

  @doc """
  ## Examples
      iex> Advent01.part2(")")
      1

      iex> Advent01.part2("()())")
      5

      iex> Advent01.part2()
      1795
  """
  def part2, do: part2(input())

  def part2(input) do
    parens = String.graphemes(input)
    findBasement(parens)
  end

  def findBasement(parens), do: findBasement(0, 0, parens)
  def findBasement(-1, index, _), do: index

  def findBasement(floor, index, ["(" | rest]) do
    findBasement(floor + 1, index + 1, rest)
  end

  def findBasement(floor, index, [")" | rest]) do
    findBasement(floor - 1, index + 1, rest)
  end
end
