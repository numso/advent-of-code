defmodule Advent14 do
  @moduledoc """
  """

  def sample, do: File.read!("inputs/14-sample.in")

  def input, do: File.read!("inputs/14.in")

  @doc """
  ## Examples
      iex> Advent14.part1(9)
      0

      iex> Advent14.part1(5)
      0

      iex> Advent14.part1(793061)
      0
  """
  def part1, do: part1(input())

  def part1(input) do
    generate_recipes([3, 7], 0, 1, input - 2)
  end

  def find_next_ten(current, a, b, next) do
    case length(next) >= 10 do
      true ->
        next

      false ->
        digits = get_next_nums(current, a, b)
        next_current = current ++ digits
        next_a = rem(a + Enum.at(current, a) + 1, length(next_current))
        next_b = rem(b + Enum.at(current, b) + 1, length(next_current))
        find_next_ten(next_current, next_a, next_b, next ++ digits)
    end
  end

  def generate_recipes(current, a, b, count) when count <= 0 do
    start =
      case count < 0 do
        true ->
          [a | _] = Enum.reverse(current)
          [a]

        false ->
          []
      end

    last = find_next_ten(current, a, b, start)
    Enum.join(last)
  end

  def generate_recipes(current, a, b, count) do
    IO.puts(count)
    digits = get_next_nums(current, a, b)
    next_current = current ++ digits
    next_a = rem(a + Enum.at(current, a) + 1, length(next_current))
    next_b = rem(b + Enum.at(current, b) + 1, length(next_current))
    generate_recipes(next_current, next_a, next_b, count - length(digits))
  end

  def get_next_nums(current, a, b) do
    sum = Enum.at(current, a) + Enum.at(current, b)
    get_digits(sum)
  end

  def get_digits(num) do
    str = to_string(num)
    parts = String.graphemes(str)
    Enum.map(parts, &String.to_integer/1)
  end

  @doc """
  ## Examples
      iex> Advent14.part2(Advent14.sample())
      0

      iex> Advent14.part2
      0
  """
  def part2, do: part2(input())

  def part2(input) do
    0
  end
end
