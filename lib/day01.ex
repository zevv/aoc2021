
defmodule Day01 do

  defp parse() do
    File.stream!("data/01.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end

  defp run1() do
    parse()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [v1, v2] -> v1 < v2 end)
  end

  defp run2() do
    parse()
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.sum/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [v1, v2] -> v1 < v2 end)
  end

  def run() do
    [ run1(), run2() ]
  end

end

