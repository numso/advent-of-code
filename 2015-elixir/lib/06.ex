defmodule Advent06 do
  @moduledoc """
  --- Day 6: Probably a Fire Hazard ---
  Because your neighbors keep defeating you in the holiday house decorating contest year after year, you've decided to deploy one million lights in a 1000x1000 grid.

  Furthermore, because you've been especially nice this year, Santa has mailed you instructions on how to display the ideal lighting configuration.

  Lights in your grid are numbered from 0 to 999 in each direction; the lights at each corner are at 0,0, 0,999, 999,999, and 999,0. The instructions include whether to turn on, turn off, or toggle various inclusive ranges given as coordinate pairs. Each coordinate pair represents opposite corners of a rectangle, inclusive; a coordinate pair like 0,0 through 2,2 therefore refers to 9 lights in a 3x3 square. The lights all start turned off.

  To defeat your neighbors this year, all you have to do is set up your lights by doing the instructions Santa sent you in order.

  For example:

  turn on 0,0 through 999,999 would turn on (or leave on) every light.
  toggle 0,0 through 999,0 would toggle the first line of 1000 lights, turning off the ones that were on, and turning on the ones that were off.
  turn off 499,499 through 500,500 would turn off (or leave off) the middle four lights.
  After following the instructions, how many lights are lit?

  --- Part Two ---
  You just finish implementing your winning light pattern when you realize you mistranslated Santa's message from Ancient Nordic Elvish.

  The light grid you bought actually has individual brightness controls; each light can have a brightness of zero or more. The lights all start at zero.

  The phrase turn on actually means that you should increase the brightness of those lights by 1.

  The phrase turn off actually means that you should decrease the brightness of those lights by 1, to a minimum of zero.

  The phrase toggle actually means that you should increase the brightness of those lights by 2.

  What is the total brightness of all lights combined after following Santa's instructions?

  For example:

  turn on 0,0 through 0,0 would increase the total brightness by 1.
  toggle 0,0 through 999,999 would increase the total brightness by 2000000.
  """

  def input, do: File.read!("inputs/06.in")

  @doc """
  ## Examples
      iex> Advent06.part1("turn on 0,0 through 999,999")
      1000000

      iex> Advent06.part1("turn on 499,499 through 500,500")
      4

      iex> Advent06.part1("turn on 0,0 through 5,1\nturn off 4,0 through 10,10")
      8

      iex> Advent06.part1("turn on 0,0 through 5,1\ntoggle 4,0 through 10,10")
      117

      iex> Advent06.part1
      377891
  """
  def part1, do: part1(input())

  def part1(input) do
    parsed = parse_input(input)
    finished = Enum.reduce(parsed, %{}, &perform_action/2)
    Enum.sum(Map.values(finished))
  end

  def parse_input(input) do
    re = ~r/(.*) ([0-9]*),([0-9]*) through ([0-9]*),([0-9]*)/
    strs = String.split(input, "\n")
    parsed = Enum.map(strs, fn str -> Regex.run(re, str) end)

    Enum.map(parsed, fn [_, action, x1, y1, x2, y2] ->
      {action, {String.to_integer(x1), String.to_integer(y1)},
       {String.to_integer(x2), String.to_integer(y2)}}
    end)
  end

  def get_action("turn on"), do: {1, fn _ -> 1 end}
  def get_action("turn off"), do: {0, fn _ -> 0 end}
  def get_action("toggle"), do: {1, fn val -> rem(val + 1, 2) end}

  def perform_action({action, from, to}, map) do
    cover(map, from, to, get_action(action))
  end

  def cover(map, {x1, y1}, {x2, y2}, {default_val, my_function}) do
    Enum.reduce(x1..x2, map, fn x, map ->
      Enum.reduce(y1..y2, map, fn y, map ->
        Map.update(map, {x, y}, default_val, my_function)
      end)
    end)
  end

  @doc """
  ## Examples
      iex> Advent06.part2("turn on 0,0 through 0,0")
      1

      iex> Advent06.part2("toggle 0,0 through 999,999")
      2000000

      iex> Advent06.part2
      14110788
  """
  def part2, do: part2(input())

  def part2(input) do
    parsed = parse_input(input)
    finished = Enum.reduce(parsed, %{}, &perform_action_v2/2)
    Enum.sum(Map.values(finished))
  end

  def get_action_v2("turn on"), do: {1, fn val -> val + 1 end}
  def get_action_v2("turn off"), do: {0, fn val -> max(val - 1, 0) end}
  def get_action_v2("toggle"), do: {2, fn val -> val + 2 end}

  def perform_action_v2({action, from, to}, map) do
    cover(map, from, to, get_action_v2(action))
  end
end
