defmodule Advent11 do
  @moduledoc """
  --- Day 11: Chronal Charge ---
  You watch the Elves and their sleigh fade into the distance as they head toward the North Pole.

  Actually, you're the one fading. The falling sensation returns.

  The low fuel warning light is illuminated on your wrist-mounted device. Tapping it once causes it to project a hologram of the situation: a 300x300 grid of fuel cells and their current power levels, some negative. You're not sure what negative power means in the context of time travel, but it can't be good.

  Each fuel cell has a coordinate ranging from 1 to 300 in both the X (horizontal) and Y (vertical) direction. In X,Y notation, the top-left cell is 1,1, and the top-right cell is 300,1.

  The interface lets you select any 3x3 square of fuel cells. To increase your chances of getting to your destination, you decide to choose the 3x3 square with the largest total power.

  The power level in a given fuel cell can be found through the following process:

  Find the fuel cell's rack ID, which is its X coordinate plus 10.
  Begin with a power level of the rack ID times the Y coordinate.
  Increase the power level by the value of the grid serial number (your puzzle input).
  Set the power level to itself multiplied by the rack ID.
  Keep only the hundreds digit of the power level (so 12345 becomes 3; numbers with no hundreds digit become 0).
  Subtract 5 from the power level.
  For example, to find the power level of the fuel cell at 3,5 in a grid with serial number 8:

  The rack ID is 3 + 10 = 13.
  The power level starts at 13 * 5 = 65.
  Adding the serial number produces 65 + 8 = 73.
  Multiplying by the rack ID produces 73 * 13 = 949.
  The hundreds digit of 949 is 9.
  Subtracting 5 produces 9 - 5 = 4.
  So, the power level of this fuel cell is 4.

  Here are some more example power levels:

  Fuel cell at  122,79, grid serial number 57: power level -5.
  Fuel cell at 217,196, grid serial number 39: power level  0.
  Fuel cell at 101,153, grid serial number 71: power level  4.
  Your goal is to find the 3x3 square which has the largest total power. The square must be entirely within the 300x300 grid. Identify this square using the X,Y coordinate of its top-left fuel cell. For example:

  For grid serial number 18, the largest total 3x3 square has a top-left corner of 33,45 (with a total power of 29); these fuel cells appear in the middle of this 5x5 region:

  -2  -4   4   4   4
  -4   4   4   4  -5
  4   3   3   4  -4
  1   1   2   4  -3
  -1   0   2  -5  -2
  For grid serial number 42, the largest 3x3 square's top-left is 21,61 (with a total power of 30); they are in the middle of this region:

  -3   4   2   2   2
  -4   4   3   3   4
  -5   3   3   4  -4
  4   3   3   4  -3
  3   3   3  -5  -1
  What is the X,Y coordinate of the top-left fuel cell of the 3x3 square with the largest total power?
  """

  @doc """
  ## Examples
      # iex> Advent11.part1(18)
      # {33, 45}

      # iex> Advent11.part1(5791)
      # {20, 68}
  """
  def part1(input) do
    power_levels =
      for x <- 1..300, y <- 1..300, into: %{} do
        {{x, y}, calculate_cell({x, y}, input)}
      end

    {coord, _} =
      Enum.reduce(power_levels, {{-1, -1}, -10_000}, fn {coord, _}, {a, power} ->
        power2 = get_3x3_square(power_levels, coord)

        case power2 > power do
          true -> {coord, power2}
          false -> {a, power}
        end
      end)

    coord
  end

  def get_3x3_square(_, {x, y}) when x > 298 or y > 298, do: -10_000

  def get_3x3_square(levels, {x, y}) do
    Enum.sum(for i <- 0..2, j <- 0..2, do: Map.get(levels, {x + i, y + j}))
  end

  @doc """
  ## Examples
      # iex> Advent11.part2(18)
      # {33, 45}

      # iex> Advent11.part2(5791)
      # {20, 68}
  """
  def part2(input) do
    power_levels = get_power_levels(input)

    {coord, size, _} =
      Enum.reduce(2..300, {{-1, -1}, -1, -10_000}, fn size, {a, b, power} ->
        IO.puts(size)

        Enum.reduce(power_levels, {a, b, power}, fn {coord, _}, {a, b, power} ->
          power2 = get_xxx_square(power_levels, size, coord)

          case power2 > power do
            true ->
              # IO.inspect({coord, size, power2})
              {coord, size, power2}

            false ->
              {a, b, power}
          end
        end)
      end)

    {coord, size}
  end

  def get_power_levels(input) do
    for x <- 1..300, y <- 1..300, into: %{} do
      {{x, y}, calculate_cell({x, y}, input)}
    end
  end

  def get_xxx_square(_, size, {x, y}) when x > 300 - size + 1 or y > 300 - size + 1, do: -10_000

  def get_xxx_square(levels, size, {x, y}) do
    Enum.sum(for i <- 0..(size - 1), j <- 0..(size - 1), do: Map.get(levels, {x + i, y + j}))
  end

  @doc """
  ## Examples
      iex> Advent11.calculate_cell({3,5}, 8)
      4

      iex> Advent11.calculate_cell({122,79}, 57)
      -5

      iex> Advent11.calculate_cell({217,196}, 39)
      0

      iex> Advent11.calculate_cell({101,153}, 71)
      4
  """
  def calculate_cell({x, y}, serial_number) do
    rack_id = x + 10
    power_level = rack_id * y
    power_level = power_level + serial_number
    power_level = power_level * rack_id
    get_hundreds_digit(power_level) - 5
  end

  def get_hundreds_digit(num), do: rem(div(num, 100), 10)
end
