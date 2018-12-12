defmodule Advent06 do
  @moduledoc """
  --- Day 6: Chronal Coordinates ---
  The device on your wrist beeps several times, and once again you feel like you're falling.

  "Situation critical," the device announces. "Destination indeterminate. Chronal interference detected. Please specify new target coordinates."

  The device then produces a list of coordinates (your puzzle input). Are they places it thinks are safe or dangerous? It recommends you check manual page 729. The Elves did not give you a manual.

  If they're dangerous, maybe you can minimize the danger by finding the coordinate that gives the largest distance from the other points.

  Using only the Manhattan distance, determine the area around each coordinate by counting the number of integer X,Y locations that are closest to that coordinate (and aren't tied in distance to any other coordinate).

  Your goal is to find the size of the largest area that isn't infinite. For example, consider the following list of coordinates:

  1, 1
  1, 6
  8, 3
  3, 4
  5, 5
  8, 9
  If we name these coordinates A through F, we can draw them on a grid, putting 0,0 at the top left:

  ..........
  .A........
  ..........
  ........C.
  ...D......
  .....E....
  .B........
  ..........
  ..........
  ........F.
  This view is partial - the actual grid extends infinitely in all directions. Using the Manhattan distance, each location's closest coordinate can be determined, shown here in lowercase:

  aaaaa.cccc
  aAaaa.cccc
  aaaddecccc
  aadddeccCc
  ..dDdeeccc
  bb.deEeecc
  bBb.eeee..
  bbb.eeefff
  bbb.eeffff
  bbb.ffffFf
  Locations shown as . are equally far from two or more coordinates, and so they don't count as being closest to any.

  In this example, the areas of coordinates A, B, C, and F are infinite - while not shown here, their areas extend forever outside the visible grid. However, the areas of coordinates D and E are finite: D is closest to 9 locations, and E is closest to 17 (both including the coordinate's location itself). Therefore, in this example, the size of the largest area is 17.

  What is the size of the largest area that isn't infinite?

  --- Part Two ---
  On the other hand, if the coordinates are safe, maybe the best you can do is try to find a region near as many coordinates as possible.

  For example, suppose you want the sum of the Manhattan distance to all of the coordinates to be less than 32. For each location, add up the distances to all of the given coordinates; if the total of those distances is less than 32, that location is within the desired region. Using the same coordinates as above, the resulting region looks like this:

  ..........
  .A........
  ..........
  ...###..C.
  ..#D###...
  ..###E#...
  .B.###....
  ..........
  ..........
  ........F.
  In particular, consider the highlighted location 4,3 located at the top middle of the region. Its calculation is as follows, where abs() is the absolute value function:

  Distance to coordinate A: abs(4-1) + abs(3-1) =  5
  Distance to coordinate B: abs(4-1) + abs(3-6) =  6
  Distance to coordinate C: abs(4-8) + abs(3-3) =  4
  Distance to coordinate D: abs(4-3) + abs(3-4) =  2
  Distance to coordinate E: abs(4-5) + abs(3-5) =  3
  Distance to coordinate F: abs(4-8) + abs(3-9) = 10
  Total distance: 5 + 6 + 4 + 2 + 3 + 10 = 30
  Because the total distance to all coordinates (30) is less than 32, the location is within the region.

  This region, which also includes coordinates D and E, has a total size of 16.

  Your actual region will need to be much larger than this example, though, instead including all locations with a total distance of less than 10000.

  What is the size of the region containing all locations which have a total distance to all given coordinates of less than 10000?
  """

  def input, do: File.read!("inputs/06.in")
  def sample, do: File.read!("inputs/06-sample.in")

  @doc """
  ## Examples
      iex> Advent06.part1(Advent06.sample())
      17

      iex> Advent06.part1
      3620
  """
  def part1, do: part1(input())

  def part1(input) do
    coords = parse(input)
    size = get_size(coords)
    map_coords = for x <- 0..size, y <- 0..size, do: {x, y}

    {counts, invalid} =
      Enum.reduce(map_coords, {%{}, %{}}, fn coord, {counts, invalid} ->
        key = find_closest(coords, coord)
        new_counts = Map.update(counts, key, 1, &(&1 + 1))
        new_invalid = update_invalid(invalid, key, coord, size - 1)
        {new_counts, new_invalid}
      end)

    filtered = Enum.filter(counts, fn {key, _} -> !Map.has_key?(invalid, key) end)
    mapped = Enum.map(filtered, fn {_, val} -> val end)
    List.last(Enum.sort(mapped))
  end

  def parse(input) do
    lines = String.split(input, "\n")

    Enum.map(lines, fn line ->
      [x, y] = String.split(line, ", ")
      {String.to_integer(x), String.to_integer(y)}
    end)
  end

  def get_size(coords) do
    Enum.reduce(coords, 0, fn {x, y}, num -> max(max(x, y), num) end) + 1
  end

  def manhattan({x, y}, {x2, y2}), do: abs(x - x2) + abs(y - y2)

  def find_closest(coords, target) do
    indexed = Enum.with_index(coords)
    distances = Enum.map(indexed, fn {coord, i} -> {manhattan(coord, target), i} end)

    case Enum.sort(distances) do
      [{d, _}, {d, _} | _] -> "."
      [{_, i} | _] -> i
    end
  end

  def get_closest(), do: 0

  def update_invalid(invalid, key, {0, _}, _), do: Map.put(invalid, key, true)
  def update_invalid(invalid, key, {_, 0}, _), do: Map.put(invalid, key, true)
  def update_invalid(invalid, key, {x, _}, x), do: Map.put(invalid, key, true)
  def update_invalid(invalid, key, {_, x}, x), do: Map.put(invalid, key, true)
  def update_invalid(invalid, _, _, _), do: invalid

  @doc """
  ## Examples
      iex> Advent06.part2(Advent06.sample(), 32)
      16

      iex> Advent06.part2
      39930
  """
  def part2, do: part2(input(), 10_000)

  def part2(input, dist) do
    coords = parse(input)
    size = get_size(coords)
    map_coords = for x <- 0..size, y <- 0..size, do: {x, y}
    Enum.count(map_coords, &(total_manhattan(coords, &1) < dist))
  end

  def total_manhattan(coords, coord) do
    Enum.sum(Enum.map(coords, &manhattan(coord, &1)))
  end
end
