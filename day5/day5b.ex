defmodule Day5B do
  def solve(input) do
    polymer = String.strip(File.read!(input))

    Stream.map(Enum.to_list(65..90), fn x -> {to_string([x]), to_string([x + 32])} end)
    |> Stream.map(fn {up, low} -> to_char_list(String.replace(String.replace(polymer, up, ""), low, "")) end)
    |> Stream.map(fn x -> Enum.reduce(x, {[], []}, fn y, {prev, []} -> react({prev, [y]}) end) end)
    |> Stream.map(fn {x, _} -> Enum.count(x) end)
    |> Enum.min
  end

  def matches(x, y) when x >= 97, do: x-32 == y
  def matches(x, y), do: y-32 == x

  def react({[], [char]}), do: {[char], []}
  def react({[prev, prev2|rest], []}) do
    if matches(prev,prev2) do
      react({rest, []})
    else
      {[prev, prev2|rest], []}
    end
  end
  def react({prev, []}), do: {prev, []}
  def react({[first|rest], [char|next]}) do
    if matches(first, char) do
      react({rest, next})
    else
      react({[char, first|rest], next})
    end
  end 
end