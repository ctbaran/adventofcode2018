defmodule Day2 do
  def solve(input) do
    {two, three} = File.stream!(input)
                   |> Stream.map(&String.strip/1)
                   |> Stream.map(fn(x) -> get_counts(x, Map.new()) end)
                   |> Enum.reduce({0,0}, fn({x1,x2}, {y1,y2}) -> {y1+bool_to_int(x1), y2+bool_to_int(x2)} end)

    two * three
  end

  def get_counts("", map), do: {Enum.member?(Map.values(map), 2), Enum.member?(Map.values(map), 3)}
  def get_counts(string, map) do 
    get_counts(String.slice(string, 1..-1), Map.update(map, String.first(string), 1, fn(n) -> n + 1 end))
  end

  def bool_to_int(false), do: 0
  def bool_to_int(true), do: 1
end