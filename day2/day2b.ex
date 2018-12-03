defmodule Day2B do
  def solve(input) do
   strings = File.stream!(input)
             |> Enum.map(&String.strip/1)
             |> Enum.map(&to_char_list/1)

   {str1, str2} = compare_all_strings(strings)

   remove_differing(str1, str2, [])
   |> Enum.reverse
  end

  def compare_strings([], [], n) when n <= 1, do: true
  def compare_strings(_str1, _str2, n) when n > 1, do: false
  def compare_strings([x|rest1], [x|rest2], n), do: compare_strings(rest1, rest2, n) 
  def compare_strings([_|rest1], [_|rest2], n), do: compare_strings(rest1, rest2, n+1) 

  def compare_string_to_rest(string, []), do: false
  def compare_string_to_rest(string, [cur|rest]) do
    IO.inspect(cur)
    if compare_strings(string, cur, 0) do
      {string, cur}
    else
      compare_string_to_rest(string, rest)
    end
  end

  def compare_all_strings([string|rest]) do
    case compare_string_to_rest(string, rest) do
      {string1, string2} -> {string1, string2}
      _ -> compare_all_strings(rest)
    end
  end

  def remove_differing([], [], str), do: str
  def remove_differing([a|r1], [a|r2], str), do: remove_differing(r1, r2, [a|str])
  def remove_differing([_|r1], [_|r2], str), do: remove_differing(r1, r2, str)
end