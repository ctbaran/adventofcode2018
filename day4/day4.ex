defmodule Day4 do
  def solve(input) do
    {timetable, guards, _, _} = 
      File.stream!(input)
      |> Stream.map(&String.strip/1)
      |> Stream.map(fn(str) -> String.split(str, "] ") end)
      |> Enum.map(fn(strs) -> record_to_timestamp(strs) end)
      |> Enum.sort
      |> Enum.reduce({Map.new(), Map.new(), nil, nil}, fn x, acc -> compute_timetable(acc, x) end)

    {sleepiest_guard, _} = find_largest(timetable)
    {sleepiest_minute, _} = find_largest(Map.get(guards, sleepiest_guard))

    sleepiest_guard * sleepiest_minute
  end

  def record_to_timestamp([timestamp,action|_]) do
    [_, minutes] = String.split(String.slice(timestamp, 1..-1), ":")

    {timestamp, String.to_integer(minutes), action}
  end

  def update_guard_timetable(guard_timetable, []), do: guard_timetable
  def update_guard_timetable(guard_timetable, [min|mins]) do
    update_guard_timetable(Map.update(guard_timetable, min, 1, fn x -> x + 1 end), mins)
  end

  def compute_timetable({timetable, guard_timetables, guard, fell_asleep}, {_, woke_up_at, "wakes up"}) do
    new_timetable = Map.update(timetable, guard, woke_up_at - fell_asleep, fn x -> x + woke_up_at - fell_asleep end)
    guard_timetable = Map.get(guard_timetables, guard, Map.new()) 
                      |> update_guard_timetable(Enum.to_list(fell_asleep..woke_up_at-1))
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