defmodule Advent03 do
  @moduledoc """
  --- Day 3: Perfectly Spherical Houses in a Vacuum ---
  Santa is delivering presents to an infinite two-dimensional grid of houses.

  He begins by delivering a present to the house at his starting location, and then an elf at the North Pole calls him via radio and tells him where to move next. Moves are always exactly one house to the north (^), south (v), east (>), or west (<). After each move, he delivers another present to the house at his new location.

  However, the elf back at the north pole has had a little too much eggnog, and so his directions are a little off, and Santa ends up visiting some houses more than once. How many houses receive at least one present?

  For example:

  > delivers presents to 2 houses: one at the starting location, and one to the east.
  ^>v< delivers presents to 4 houses in a square, including twice to the house at his starting/ending location.
  ^v^v^v^v^v delivers a bunch of presents to some very lucky children at only 2 houses.

  --- Part Two ---
  The next year, to speed up the process, Santa creates a robot version of himself, Robo-Santa, to deliver presents with him.

  Santa and Robo-Santa start at the same location (delivering two presents to the same starting house), then take turns moving based on instructions from the elf, who is eggnoggedly reading from the same script as the previous year.

  This year, how many houses receive at least one present?

  For example:

  ^v delivers presents to 3 houses, because Santa goes north, and then Robo-Santa goes south.
  ^>v< now delivers presents to 3 houses, and Santa and Robo-Santa end up back where they started.
  ^v^v^v^v^v now delivers presents to 11 houses, with Santa going one direction and Robo-Santa going the other.
  """

  def input, do: File.read!("inputs/03.in")

  @doc """
  ## Examples
      iex> Advent03.part1(">")
      2

      iex> Advent03.part1("^>v<")
      4

      iex> Advent03.part1("^v^v^v^v^v")
      2

      iex> Advent03.part1
      2565
  """
  def part1, do: part1(input())

  def part1(input) do
    moves = String.graphemes(input)
    Map.size(travel(moves))
  end

  def travel(moves, map \\ Map.new([{{0, 0}, 1}]), location \\ {0, 0})
  def travel([], map, _), do: map

  def travel([dir | rest], map, location) do
    next_location = get_next_location(dir, location)
    next_map = Map.put(map, next_location, 1)
    travel(rest, next_map, next_location)
  end

  def get_next_location("^", {x, y}), do: {x, y - 1}
  def get_next_location("v", {x, y}), do: {x, y + 1}
  def get_next_location("<", {x, y}), do: {x - 1, y}
  def get_next_location(">", {x, y}), do: {x + 1, y}

  @doc """
  ## Examples
      iex> Advent03.part2("^v")
      3

      iex> Advent03.part2("^>v<")
      3

      iex> Advent03.part2("^v^v^v^v^v")
      11

      iex> Advent03.part2
      2639
  """
  def part2, do: part2(input())

  def part2(input) do
    moves = String.graphemes(input)
    {moves1, moves2} = split_every_other(moves)
    map = travel(moves1)
    finishedMap = travel(moves2, map)
    Map.size(finishedMap)
  end

  def first(tuple), do: elem(tuple, 0)

  def split_every_other(enum) do
    indexed_enum = Enum.with_index(enum)
    {enum1, enum2} = Enum.split_with(indexed_enum, fn {_, i} -> rem(i, 2) == 0 end)
    {Enum.map(enum1, &first/1), Enum.map(enum2, &first/1)}
  end
end
