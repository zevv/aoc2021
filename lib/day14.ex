
defmodule Day14 do
  

  def expand(l, tab) do
    case l do
      [] -> [0]
      [a] -> [a]
      [a | [b | rest]] ->
        [n1, n2 | tail] = if Map.has_key?(tab, [a, b]) do
          [a, b, c] = Map.get(tab, [a, b])
          [a, b, c | rest]
        else
          [a, b | rest]
        end
        [n1, n2 | expand(tail, tab)]
    end
  end

  def hop(s, tab, 0) do
    s
  end

  def hop(s, tab, n) do
    IO.puts(Enum.count(s))
    s
    |> expand(tab)
    |> hop(tab, n-1)
  end
  
  def run() do

    [start, tab] = File.read!("data/14.txt")
                   |> String.split("\n\n")

    start = String.split(start, "", trim: true)
    tab = String.split(tab, "\n", trim: true)
          |> Enum.reduce(%{}, fn l, map ->
            [a, b] = String.split(l, " -> ", trim: true)
              [a1, a2] = String.split(a, "", trim: true)
              Map.put(map, [a1, a2], [a1, b, a2])
          end)

    f = hop(start, tab, 10)
        |> Enum.frequencies
        |> Map.values

    Enum.max(f) - Enum.min(f)

  end

end

