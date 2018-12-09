defmodule Day3B do
  def solve(input) do
    {_, claimMap} = File.stream!(input)
                    |> Stream.map(&String.strip/1)
                    |> Stream.map(fn(str) -> String.split(str, " ") end)
                    |> Stream.map(&coords/1)
                    |> Enum.reduce({Map.new(), Map.new()}, fn coords, acc -> apply_rect(acc, coords) end)

    Enum.filter(Map.to_list(claimMap), fn {k, v} -> v end)
  end

  def coords([claim, _, start, dimensions]) do
    [x, y] = String.slice(start, 0..-2)
            |> String.split(",")
    [w, h] = String.split(dimensions, "x")
    {claim, {String.to_integer(x), String.to_integer(y)}, {String.to_integer(w), String.to_integer(h)}}
  end

  def apply_coords(coordMap, claimMap, _claim, []), do: {coordMap, claimMap}
  def apply_coords(coordMap, claimMap, claim, [coord|coords]) do
    newCoordMap = Map.update(coordMap, coord, [claim], fn x -> [claim|x] end)
    existingClaims = Map.get(newCoordMap, coord, [])
    if Enum.count(existingClaims) > 1 do
      apply_coords(newCoordMap, apply_claims(claimMap, existingClaims), claim, coords)
    else
      apply_coords(newCoordMap, claimMap, claim, coords)
    end
  end

  def apply_rect({coordMap, claimMap}, {claim, {sX, sY}, {w, h}}) do
    apply_coords(coordMap, Map.put(claimMap, claim, true), claim, get_rect(sX, sY, w, h))
  end

  def get_rect(sX, sY, w, h) do
    for i <- sX..sX+w-1 do
      for j <- sY..sY+h-1, do: {i, j}
    end
    |> List.flatten
  end

  def apply_claims(map, []), do: map
  def apply_claims(map, [claim|claims]), do: apply_claims(Map.put(map, claim, false), claims)
end