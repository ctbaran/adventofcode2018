defmodule Day3B do
  def solve(input) do
    {_, claim_map} = File.stream!(input)
                     |> Stream.map(&String.strip/1)
                     |> Stream.map(fn(str) -> String.split(str, " ") end)
                     |> Stream.map(&coords/1)
                     |> Enum.reduce({Map.new(), Map.new()}, fn coords, acc -> apply_rect(acc, coords) end)

    Enum.filter(Map.to_list(claim_map), fn {k, v} -> v end)
  end

  def coords([claim, _, start, dimensions]) do
    [x, y] = String.slice(start, 0..-2)
            |> String.split(",")
    [w, h] = String.split(dimensions, "x")
    {claim, {String.to_integer(x), String.to_integer(y)}, {String.to_integer(w), String.to_integer(h)}}
  end

  def apply_coords(coord_map, claim_map, _claim, []), do: {coord_map, claim_map}
  def apply_coords(coord_map, clai_mMap, claim, [coord|coords]) do
    new_coord_map = Map.update(coord_map, coord, [claim], fn x -> [claim|x] end)
    existing_claims = Map.get(new_coord_map, coord, [])
    if Enum.count(existing_claims) > 1 do
      apply_coords(new_coord_map, apply_claims(claim_map, existing_claims), claim, coords)
    else
      apply_coords(new_coord_map, claim_map, claim, coords)
    end
  end

  def apply_rect({coord_map, claim_map}, {claim, {sX, sY}, {w, h}}) do
    apply_coords(coord_map, Map.put(claim_map, claim, true), claim, get_rect(sX, sY, w, h))
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