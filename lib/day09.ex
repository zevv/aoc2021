
defmodule Day09 do

  defp run1(map) do
    Enum.map(map, fn {{x, y}, v} ->
      neigh = [{x-1,y}, {x+1,y}, {x,y-1}, {x,y+1}]
      min = Enum.map(neigh, &Map.get(map, &1, 10)) |> Enum.min()
      if v < min do v+1 else 0 end
    end)
    |> Enum.sum
  end

  defp fill({n, map}, x, y) do
    if Map.get(map, {x, y}, 9) == 9 do
      {n, map}
    else
      {n+1, Map.put(map, {x, y}, 9)}
      |> fill(x-1, y)
      |> fill(x+1, y)
      |> fill(x, y-1)
      |> fill(x, y+1)
    end
  end

  defp run2(map) do
    Map.keys(map)
    |> Enum.reduce( {[], map}, fn {x, y}, {sizes, map} ->
      {n, map} = fill({0, map}, x, y)
      {[n | sizes], map}
    end)
    |> elem(0)
    |> Enum.sort(&(&1>=&2))
    |> Enum.take(3)
    |> Enum.product()
  end

  def run() do
    map = File.read!("data/09.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn e ->
      String.split(e, "", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.with_index
    |> Enum.map(fn {row, y} ->
      Enum.with_index(row)
      |> Enum.map(fn {col, x} ->
        {{x, y}, col}
      end)
    end)
    |> List.flatten
    |> Map.new

    [452, 1263735] = [run1(map), run2(map)]

  end

end

