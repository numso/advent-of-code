defmodule Advent04 do
  @moduledoc """
  --- Day 4: Repose Record ---
  You've sneaked into another supply closet - this time, it's across from the prototype suit manufacturing lab. You need to sneak inside and fix the issues with the suit, but there's a guard stationed outside the lab, so this is as close as you can safely get.

  As you search the closet for anything that might help, you discover that you're not the first person to want to sneak in. Covering the walls, someone has spent an hour starting every midnight for the past few months secretly observing this guard post! They've been writing down the ID of the one guard on duty that night - the Elves seem to have decided that one guard was enough for the overnight shift - as well as when they fall asleep or wake up while at their post (your puzzle input).

  For example, consider the following records, which have already been organized into chronological order:

  [1518-11-01 00:00] Guard #10 begins shift
  [1518-11-01 00:05] falls asleep
  [1518-11-01 00:25] wakes up
  [1518-11-01 00:30] falls asleep
  [1518-11-01 00:55] wakes up
  [1518-11-01 23:58] Guard #99 begins shift
  [1518-11-02 00:40] falls asleep
  [1518-11-02 00:50] wakes up
  [1518-11-03 00:05] Guard #10 begins shift
  [1518-11-03 00:24] falls asleep
  [1518-11-03 00:29] wakes up
  [1518-11-04 00:02] Guard #99 begins shift
  [1518-11-04 00:36] falls asleep
  [1518-11-04 00:46] wakes up
  [1518-11-05 00:03] Guard #99 begins shift
  [1518-11-05 00:45] falls asleep
  [1518-11-05 00:55] wakes up
  Timestamps are written using year-month-day hour:minute format. The guard falling asleep or waking up is always the one whose shift most recently started. Because all asleep/awake times are during the midnight hour (00:00 - 00:59), only the minute portion (00 - 59) is relevant for those events.

  Visually, these records show that the guards are asleep at these times:

  Date   ID   Minute
              000000000011111111112222222222333333333344444444445555555555
              012345678901234567890123456789012345678901234567890123456789
  11-01  #10  .....####################.....#########################.....
  11-02  #99  ........................................##########..........
  11-03  #10  ........................#####...............................
  11-04  #99  ....................................##########..............
  11-05  #99  .............................................##########.....
  The columns are Date, which shows the month-day portion of the relevant day; ID, which shows the guard on duty that day; and Minute, which shows the minutes during which the guard was asleep within the midnight hour. (The Minute column's header shows the minute's ten's digit in the first row and the one's digit in the second row.) Awake is shown as ., and asleep is shown as #.

  Note that guards count as asleep on the minute they fall asleep, and they count as awake on the minute they wake up. For example, because Guard #10 wakes up at 00:25 on 1518-11-01, minute 25 is marked as awake.

  If you can figure out the guard most likely to be asleep at a specific time, you might be able to trick that guard into working tonight so you can have the best chance of sneaking in. You have two strategies for choosing the best guard/minute combination.

  Strategy 1: Find the guard that has the most minutes asleep. What minute does that guard spend asleep the most?

  In the example above, Guard #10 spent the most minutes asleep, a total of 50 minutes (20+25+5), while Guard #99 only slept for a total of 30 minutes (10+10+10). Guard #10 was asleep most during minute 24 (on two days, whereas any other minute the guard was asleep was only seen on one day).

  While this example listed the entries in chronological order, your entries are in the order you found them. You'll need to organize them before they can be analyzed.

  What is the ID of the guard you chose multiplied by the minute you chose? (In the above example, the answer would be 10 * 24 = 240.)

  --- Part Two ---
  Strategy 2: Of all guards, which guard is most frequently asleep on the same minute?

  In the example above, Guard #99 spent minute 45 asleep more than any other guard or minute - three times in total. (In all other cases, any guard spent any minute asleep at most twice.)

  What is the ID of the guard you chose multiplied by the minute you chose? (In the above example, the answer would be 99 * 45 = 4455.)
  """

  def input, do: File.read!("inputs/04.in")
  def sample, do: File.read!("inputs/04-sample.in")

  @doc """
  ## Examples
      iex> Advent04.part1(Advent04.sample())
      {10, 24, 240}

      iex> Advent04.part1
      {733, 48, 35184}
  """
  def part1, do: part1(input())

  def part1(input) do
    lines = String.split(input, "\r\n")
    shifts = parse(Enum.sort(lines))
    sleepiest = find_most_sleepy(shifts)
    sleepiest_minute = find_sleepy_minute(sleepiest, shifts)
    {sleepiest, sleepiest_minute, sleepiest * sleepiest_minute}
  end

  def parse(lines) do
    {_, list} =
      Enum.reduce(lines, {{0, 0}, []}, fn line, {{prev_guard, prev_time}, shifts} ->
        [_, timeStr, msg] = Regex.run(~r/:(\d+)\] (.*)/, line)
        time = String.to_integer(timeStr)
        {status, guard} = parse_more(msg, prev_guard)

        case status do
          :wake -> {{guard, time}, [{guard, prev_time, time} | shifts]}
          _ -> {{guard, time}, shifts}
        end
      end)

    list
  end

  def parse_more(msg, prev_guard) do
    case msg do
      "wakes up" ->
        {:wake, prev_guard}

      "falls asleep" ->
        {:sleep, prev_guard}

      other ->
        [_, new_guard] = Regex.run(~r/Guard #(\d+) begins shift/, other)
        {:begin, String.to_integer(new_guard)}
    end
  end

  def find_most_sleepy(shifts) do
    schedule =
      Enum.reduce(shifts, %{}, fn {guard_num, start_time, end_time}, map ->
        minutes_asleep = end_time - start_time
        Map.update(map, guard_num, minutes_asleep, &(&1 + minutes_asleep))
      end)

    [{guard, _} | _] = Enum.sort(schedule, fn {_, val}, {_, val2} -> val > val2 end)
    guard
  end

  def find_sleepy_minute(sleepiest, shifts) do
    shifts2 = Enum.filter(shifts, fn {guard, _, _} -> guard == sleepiest end)

    minutes =
      Enum.reduce(shifts2, %{}, fn {_, start_time, end_time}, map ->
        Enum.reduce(start_time..(end_time - 1), map, fn num, map ->
          Map.update(map, num, 1, fn num -> num + 1 end)
        end)
      end)

    [{minute, _} | _] = Enum.sort(minutes, fn {_, val}, {_, val2} -> val > val2 end)

    minute
  end

  @doc """
  ## Examples
      iex> Advent04.part2(Advent04.sample())
      {99, 45, 4455}

      iex> Advent04.part2
      {997, 38, 37886}
  """
  def part2, do: part2(input())

  def part2(input) do
    lines = String.split(input, "\r\n")
    shifts = parse(Enum.sort(lines))
    sleepiest = find_most_sleepy_minute(shifts)
    sleepiest_minute = find_sleepy_minute(sleepiest, shifts)
    {sleepiest, sleepiest_minute, sleepiest * sleepiest_minute}
  end

  def find_most_sleepy_minute(shifts) do
    schedule =
      Enum.reduce(shifts, %{}, fn {guard_num, start_time, end_time}, map ->
        Enum.reduce(start_time..(end_time - 1), map, fn num, map ->
          Map.update(map, {guard_num, num}, 1, fn num -> num + 1 end)
        end)
      end)

    [{{guard, _}, _} | _] = Enum.sort(schedule, fn {_, val}, {_, val2} -> val > val2 end)
    guard
  end
end
