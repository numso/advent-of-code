defmodule Advent03 do
  @moduledoc """
  --- Day 3: No Matter How You Slice It ---
  The Elves managed to locate the chimney-squeeze prototype fabric for Santa's suit (thanks to someone who helpfully wrote its box IDs on the wall of the warehouse in the middle of the night). Unfortunately, anomalies are still affecting them - nobody can even agree on how to cut the fabric.

  The whole piece of fabric they're working on is a very large square - at least 1000 inches on each side.

  Each Elf has made a claim about which area of fabric would be ideal for Santa's suit. All claims have an ID and consist of a single rectangle with edges parallel to the edges of the fabric. Each claim's rectangle is defined as follows:

  The number of inches between the left edge of the fabric and the left edge of the rectangle.
  The number of inches between the top edge of the fabric and the top edge of the rectangle.
  The width of the rectangle in inches.
  The height of the rectangle in inches.
  A claim like #123 @ 3,2: 5x4 means that claim ID 123 specifies a rectangle 3 inches from the left edge, 2 inches from the top edge, 5 inches wide, and 4 inches tall. Visually, it claims the square inches of fabric represented by # (and ignores the square inches of fabric represented by .) in the diagram below:

  ...........
  ...........
  ...#####...
  ...#####...
  ...#####...
  ...#####...
  ...........
  ...........
  ...........
  The problem is that many of the claims overlap, causing two or more claims to cover part of the same areas. For example, consider the following claims:

  #1 @ 1,3: 4x4
  #2 @ 3,1: 4x4
  #3 @ 5,5: 2x2
  Visually, these claim the following areas:

  ........
  ...2222.
  ...2222.
  .11XX22.
  .11XX22.
  .111133.
  .111133.
  ........
  The four square inches marked with X are claimed by both 1 and 2. (Claim 3, while adjacent to the others, does not overlap either of them.)

  If the Elves all proceed with their own plans, none of them will have enough fabric. How many square inches of fabric are within two or more claims?

  --- Part Two ---
  Amidst the chaos, you notice that exactly one claim doesn't overlap by even a single square inch of fabric with any other claim. If you can somehow draw attention to it, maybe the Elves will be able to make Santa's suit after all!

  For example, in the claims above, only claim 3 is intact after all claims are made.

  What is the ID of the only claim that doesn't overlap?
  """

  def input, do: File.read!("inputs/03.in")

  @doc ~S"""
  ## Examples
      iex> Advent03.part1("#1 @ 1,3: 4x4\n#2 @ 3,1: 4x4\n#3 @ 5,5: 2x2")
      4

      iex> Advent03.part1
      120408
  """
  def part1, do: part1(input())

  def part1(input) do
    parts = String.split(input, "\n")
    fabric = Enum.reduce(parts, %{}, &add_claim/2)
    Enum.count(Map.values(fabric), &(&1 >= 2))
  end

  def parse(str) do
    re = ~r/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/
    [_, id, left, top, width, height] = Regex.run(re, str)
    position = {String.to_integer(left), String.to_integer(top)}
    size = {String.to_integer(width), String.to_integer(height)}
    {id, position, size}
  end

  def add_claim(str, map) do
    xys = get_xys(parse(str))
    Enum.reduce(xys, map, &Map.update(&2, &1, 1, fn x -> x + 1 end))
  end

  def range(from, length), do: from..(from + length - 1)

  def get_xys({_, {left, top}, {width, height}}) do
    for x <- range(left, width), y <- range(top, height), do: {x, y}
  end

  @doc ~S"""
  ## Examples
      iex> Advent03.part2("#1 @ 1,3: 4x4\n#2 @ 3,1: 4x4\n#3 @ 5,5: 2x2")
      "3"

      iex> Advent03.part2
      "1276"
  """
  def part2, do: part2(input())

  def part2(input) do
    parts = String.split(input, "\n")
    fabric = Enum.reduce(parts, %{}, &add_claim/2)
    str = Enum.find(parts, &is_uniq?(fabric, &1))
    elem(parse(str), 0)
  end

  def is_uniq?(fabric, str) do
    xys = get_xys(parse(str))
    Enum.all?(xys, &(Map.get(fabric, &1) == 1))
  end
end
