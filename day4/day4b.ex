defmodule Day4B do
  def solve(input) do
    {timetable, guard_timetables, _, _} = 
      File.stream!(input)
      |> Stream.map(&String.strip/1)
      |> Stream.map(fn(str) -> String.split(str, "] ") end)
      |> Enum.map(fn(strs) -> record_to_timestamp(strs) end)
      |> Enum.sort
      |> Enum.reduce({Map.new(), Map.new(), nil, nil}, fn x, acc -> compute_timetable(acc, x) end)

    {sleepiest_minute, _} = find_largest(timetable)
    {_, sleepiest_guard} = 
      Stream.map(Map.keys(guard_timetables), fn x -> {Map.get(Map.get(guard_timetables, x), sleepiest_minute, 0), x} end)
      |> Enum.sort
      |> Enum.reverse
      |> List.first

    sleepiest_minute * sleepiest_guard
  end

  def record_to_timestamp([timestamp,action|_]) do
    [_, minutes] = String.split(String.slice(timestamp, 1..-1), ":")

    {timestamp, String.to_integer(minutes), action}
  end

  def update_minute_timetable(minute_timetable, []), do: minute_timetable
  def update_minute_timetable(minute_timetable, [min|mins]) do
    update_minute_timetable(Map.update(minute_timetable, min, 1, fn x -> x + 1 end), mins)
  end

  def compute_timetable({timetable, guard_timetables, guard, fell_asleep}, {_, woke_up_at, "wakes up"}) do
    new_timetable = update_minute_timetable(timetable, Enum.to_list(fell_asleep..woke_up_at-1))
    guard_timetable = Map.get(guard_timetables, guard, Map.new()) 
                      |> update_minute_timetable(Enum.to_list(fell_asleep..woke_up_at-1))
    {new_timetable, Map.put(guard_timetables, guard, guard_timetable), guard, nil}
  end
  def compute_timetable({timetable, guard_timetables, guard, nil}, {_, falls_asleep_at, "falls asleep"}) do
    {timetable, guard_timetables, guard, falls_asleep_at}
  end
  def compute_timetable({timetable, guard_timetables, _guard, nil}, {_, _, action}) do
    [_, guard_str|_] = String.split(action, " ")
    {timetable, guard_timetables, String.to_integer(String.slice(guard_str, 1..-1)), nil}
  end

  def find_largest(timetable) do
    Map.to_list(timetable)
    |> Enum.sort(fn {_, time1}, {_, time2} -> time1 > time2 end)
    |> List.first
  end
end