
defmodule Day01 do

  defp run1(vs) do
    vs
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [v1, v2] -> v1 < v2 end)
  end

  defp run2(vs) do
    vs
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.sum/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [v1, v2] -> v1 < v2 end)
  end

  def run() do
    vs = File.stream!("data/01.txt")
         |> Enum.map(&String.trim/1)
         |> Enum.map(&String.to_integer/1)
    [1400, 1429] = [run1(vs), run2(vs)]
  end

end

