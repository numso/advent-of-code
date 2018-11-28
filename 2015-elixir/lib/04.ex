defmodule Advent04 do
  @moduledoc """
  --- Day 4: The Ideal Stocking Stuffer ---
  Santa needs help mining some AdventCoins (very similar to bitcoins) to use as gifts for all the economically forward-thinking little girls and boys.

  To do this, he needs to find MD5 hashes which, in hexadecimal, start with at least five zeroes. The input to the MD5 hash is some secret key (your puzzle input, given below) followed by a number in decimal. To mine AdventCoins, you must find Santa the lowest positive number (no leading zeroes: 1, 2, 3, ...) that produces such a hash.

  For example:

  If your secret key is abcdef, the answer is 609043, because the MD5 hash of abcdef609043 starts with five zeroes (000001dbbfa...), and it is the lowest such number to do so.
  If your secret key is pqrstuv, the lowest number it combines with to make an MD5 hash starting with five zeroes is 1048970; that is, the MD5 hash of pqrstuv1048970 looks like 000006136ef....

  --- Part Two ---
  Now find one that starts with six zeroes.
  """

  def input, do: "yzbqklnj"

  @doc """
  ## Examples
      iex> Advent04.part1("abcdef")
      609043

      iex> Advent04.part1("pqrstuv")
      1048970

      iex> Advent04.part1
      282749

      iex> Advent04.part2
      9962624
  """
  def part1, do: part1(input())
  def part1(input), do: find_hash(input, "00000")
  def part2, do: find_hash(input(), "000000")

  def find_hash(key, prefix, num \\ 1) do
    hash = :crypto.hash(:md5, key <> to_string(num)) |> Base.encode16()

    if String.starts_with?(hash, prefix) do
      num
    else
      find_hash(key, prefix, num + 1)
    end
  end
end
