defmodule Day3 do
  def solve(input) do
    File.stream!(input)
    |> Stream.map(&String.strip/1)
    |> Stream.map(fn(str) -> String.split(str, " ") end)
    |> Stream.map(&coords/1)
    |> Enum.reduce(Map.new(), fn coords, acc -> apply_rect(acc, coords) end)
    |> Map.values
    |> Enum.filter(fn x -> x >= 2 end)
    |> Enum.count
  end

  def coords([_, _, start, dimensions]) do
    [x, y] = String.slice(start, 0..-2)
            |> String.split(",")
    [w, h] = String.split(dimensions, "x")
    {{String.to_integer(x), String.to_integer(y)}, {String.to_integer(w), String.to_integer(h)}}
  end

  def apply_coords(map, []), do: map
  def apply_coords(map, [coord|coords]), do: apply_coords(Map.update(map, coord, 1, fn x -> x + 1 end), coords)

  def apply_rect(map, {{sX, sY}, {w, h}}) do
    apply_coords(map, get_rect(sX, sY, w, h))
  end

  def get_rect(sX, sY, w, h) do
    for i <- sX..sX+w-1 do
      for j <- sY..sY+h-1, do: {i, j}
    end
    |> List.flatten
  end
end