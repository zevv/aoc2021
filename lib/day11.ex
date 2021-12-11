
defmodule Day11 do

  defp propagate(map, flashed, {x, y}) do
    Map.map(map, fn {{x2, y2}, v} ->
      if flashed[{x2, y2}] == nil and abs(x-x2) <= 1 and abs(y-y2) <= 1 do
        v+1
      else
        v
      end
    end)
  end

  defp flash(map, flashed) do
    {map_new, flashed_new} =
      Map.keys(map)
      |> Enum.reduce({map, flashed}, fn pos, {map2, flashed2} ->
        if map[pos] > 9 do
          flashed2 = Map.put(flashed2, pos, true)
          { Map.put(map2, pos, 0) |> propagate(flashed2, pos), flashed2 }
        else
          { map2, flashed2 }
        end
      end)
    if flashed_new == flashed do
      {map_new, flashed_new}
    else
      flash(map_new, flashed_new)
    end
  end

  defp iteration(map) do
    Map.map(map, fn {k, v} -> v + 1 end) |> flash(%{})
  end

  defp run1(map, count, n) do
    case n do
      0 -> count
      _ ->
        {map, flashed} = iteration(map)
        run1(map, count + Enum.count(flashed), n-1)
    end
  end

  defp run2(map, n) do
    {map, flashed} = iteration(map)
    if Enum.count(flashed) == Enum.count(map) do
      n+1
    else
      run2(map, n+1)
    end
  end

  def run() do
    map = Day09.parse_map("data/11.txt")
    [1627, 329] = [run1(map, 0, 100), run2(map, 0)]
  end

end
