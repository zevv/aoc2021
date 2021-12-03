
defmodule Day03 do

  defp count(l, op) do
    fs = Enum.frequencies(l)
    if op.(fs["1"], fs["0"]) do "1" else "0" end
  end

  defp aux1(vs, op) do
    vs
    |> Enum.zip
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&count(&1, op))
    |> Enum.join()
    |> String.to_integer(2)
  end

  defp aux2([a], _, _) do
    a
    |> Enum.join()
    |> String.to_integer(2)
  end

  defp aux2(vs, op, idx) do
    n = vs
        |> Enum.map(&Enum.at(&1, idx))
        |> List.flatten()
        |> count(op)
    Enum.filter(vs, &(Enum.at(&1, idx) == n))
    |> aux2(op, idx+1)
  end
  
  defp run1(vs) do
    epsilon = aux1(vs, &(&1>=&2))
    gamma = aux1(vs, &(&1<&2))
    epsilon * gamma
  end

  defp run2(vs) do
    oxygen = aux2(vs, &(&1>=&2), 0)
    co2 = aux2(vs, &(&1<&2), 0)
    oxygen * co2
  end

  def run() do
    vs = File.stream!("data/03.txt")
         |> Enum.map(&String.trim/1)
         |> Enum.map(&String.graphemes/1)
    [2648450, 2845944] = [run1(vs), run2(vs)]
  end

end

