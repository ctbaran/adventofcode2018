defmodule Day1 do
  def solve(input) do
    File.stream!(input)
    |> Enum.map(&String.strip/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum
  end
end
