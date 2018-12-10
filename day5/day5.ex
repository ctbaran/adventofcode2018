defmodule Day5 do
  def solve(input) do
    {reversed, _} = String.strip(File.read!(input))
                    |> to_char_list
                    |> Enum.reduce({[], []}, fn x, {prev, []} -> react({prev, [x]}) end)

    Enum.count(reversed)
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
  def react({[first|rest], [char]}) do
    if matches(first, char) do
      react({rest, []})
    else
      {[char, first|rest], []}
    end
  end 
end