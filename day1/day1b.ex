defmodule Day1B do
  def solve(input) do
    nums = File.stream!(input)
           |> Enum.map(&String.strip/1)
           |> Enum.map(&String.to_integer/1)
           |> Enum.to_list

    first_double(nums, nums, 0, MapSet.new())
  end

  def first_double([], nums, cur_freq, map_set), do: first_double(nums, nums, cur_freq, map_set)
  def first_double([cur|rest], nums, cur_freq, map_set) do
    new_freq = cur_freq + cur
    if MapSet.member?(map_set, new_freq) do
      new_freq
    else
      first_double(rest, nums, new_freq, MapSet.put(map_set, cur_freq))
    end
  end
end
