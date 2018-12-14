defmodule Advent13 do
  @moduledoc """
  """

  def sample, do: File.read!("inputs/13-sample.in")
  def sample2, do: File.read!("inputs/13-sample2.in")
  def input, do: File.read!("inputs/13.in")

  @doc """
  ## Examples
      iex> Advent13.part1(Advent13.sample())
      {7,3,14,0,1}

      iex> Advent13.part1
      {14,42,197,3,16}
  """
  def part1, do: part1(input())

  def part1(input) do
    {carts, map} = parse(input)
    find_collision(carts, map, 1)
  end

  def find_collision(carts, map, time) do
    new_carts = Enum.map(carts, &move_cart(&1, map))

    case get_collision(new_carts ++ carts) do
      {:collides, x, y, id1, id2} -> {x, y, time, {id1, id2, new_carts}}
      _ -> find_collision(new_carts, map, time + 1)
    end
  end

  def move_cart({x, y, id, {dir, next_turn}}, map) do
    case Map.get(map, {x, y}) do
      "-" ->
        {x2, y2} = get_next_coord(dir, x, y)
        {x2, y2, id, {dir, next_turn}}

      ">" ->
        {x2, y2} = get_next_coord(dir, x, y)
        {x2, y2, id, {dir, next_turn}}

      "<" ->
        {x2, y2} = get_next_coord(dir, x, y)
        {x2, y2, id, {dir, next_turn}}

      "|" ->
        {x2, y2} = get_next_coord(dir, x, y)
        {x2, y2, id, {dir, next_turn}}

      "^" ->
        {x2, y2} = get_next_coord(dir, x, y)
        {x2, y2, id, {dir, next_turn}}

      "v" ->
        {x2, y2} = get_next_coord(dir, x, y)
        {x2, y2, id, {dir, next_turn}}

      "+" ->
        next_dir = turn(dir, next_turn)
        next_next_turn = get_next_turn(next_turn)
        {x2, y2} = get_next_coord(next_dir, x, y)
        {x2, y2, id, {next_dir, next_next_turn}}

      "/" ->
        next_dir = turn(dir)
        {x2, y2} = get_next_coord(next_dir, x, y)
        {x2, y2, id, {next_dir, next_turn}}

      "\\" ->
        next_dir = turn2(dir)
        {x2, y2} = get_next_coord(next_dir, x, y)
        {x2, y2, id, {next_dir, next_turn}}
    end
  end

  def turn(:left), do: :down
  def turn(:down), do: :left
  def turn(:up), do: :right
  def turn(:right), do: :up

  def turn2(:left), do: :up
  def turn2(:up), do: :left
  def turn2(:right), do: :down
  def turn2(:down), do: :right

  def turn(dir, :straight), do: dir
  def turn(:left, :left), do: :down
  def turn(:right, :left), do: :up
  def turn(:up, :left), do: :left
  def turn(:down, :left), do: :right
  def turn(:left, :right), do: :up
  def turn(:right, :right), do: :down
  def turn(:up, :right), do: :right
  def turn(:down, :right), do: :left

  def get_next_coord(:left, x, y), do: {x - 1, y}
  def get_next_coord(:right, x, y), do: {x + 1, y}
  def get_next_coord(:up, x, y), do: {x, y - 1}
  def get_next_coord(:down, x, y), do: {x, y + 1}

  def get_next_turn(:left), do: :straight
  def get_next_turn(:straight), do: :right
  def get_next_turn(:right), do: :left

  def get_collision(carts) do
    {_, ans} =
      Enum.reduce(carts, {%{}, nil}, fn {x, y, id, _}, {map, ans} ->
        case Map.get(map, {x, y}) do
          nil -> {Map.put(map, {x, y}, id), ans}
          id2 -> {map, {x, y, id, id2}}
        end
      end)

    case ans do
      nil -> nil
      {x, y, id, id2} -> {:collides, x, y, id, id2}
    end
  end

  def parse(input) do
    lines = String.split(input, "\n")
    cells = Enum.map(lines, &String.graphemes/1)

    map =
      for y <- 0..(length(cells) - 1),
          x <- 0..(length(Enum.at(cells, 0)) - 1),
          into: %{},
          do: {{x, y}, Enum.at(Enum.at(cells, y), x)}

    {_, carts} =
      Enum.reduce(map, {0, []}, fn {{x, y}, char}, {id, carts} ->
        case char do
          "<" -> {id + 1, [{x, y, id, {:left, :left}}] ++ carts}
          ">" -> {id + 1, [{x, y, id, {:right, :left}}] ++ carts}
          "^" -> {id + 1, [{x, y, id, {:up, :left}}] ++ carts}
          "v" -> {id + 1, [{x, y, id, {:down, :left}}] ++ carts}
          _ -> {id, carts}
        end
      end)

    # map = Enum.map
    #   Enum.map(map, fn line ->
    #     Enum.map(line, fn char ->
    #       case char do
    #         "<" -> "-"
    #         ">" -> "-"
    #         "^" -> "|"
    #         "v" -> "|"
    #         _ -> char
    #       end
    #     end)
    #   end)

    {carts, map}
  end

  @doc """
  ## Examples
      iex> Advent13.part2(Advent13.sample2())
      {6,4}

      iex> Advent13.part2
      {8,7}
  """
  def part2, do: part2(input())

  def part2(input) do
    {carts, map} = parse(input)
    {x, y, _, _} = find_last_cart(carts, map)
    {x, y}
  end

  def find_last_cart(carts, map) do
    {_, _, _, {id, id2, blargs}} = find_collision(carts, map, 1)
    new_carts = Enum.filter(carts, fn {_, _, id3, _} -> id3 !== id and id3 !== id2 end)

    case new_carts do
      [{_, _, id, _}] -> Enum.find(blargs, fn {_, _, id2, _} -> id === id2 end)
      _ -> find_last_cart(new_carts, map)
    end
  end
end
