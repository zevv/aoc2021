
defmodule Day05 do

  defp sgn(0) do 0 end
  defp sgn(a) do div(abs(a), a) end

  defp draw(x, y, xend, yend, dx, dy, map) do
    map = Map.update(map, {x, y}, 1, &(&1+1))
    case {x, y} do
      {^xend, ^yend} -> map
      _ -> draw(x+dx, y+dy, xend, yend, dx, dy, map)
    end
  end

  defp draw([x1, y1, x2, y2], map) do
    draw(x1, y1, x2, y2, sgn(x2-x1), sgn(y2-y1), map)
  end

  def work(filt) do
    File.read!("data/05.txt")
    |> String.split([",", " -> ", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(4, 4)
    |> Enum.filter(filt)
    |> Enum.reduce(%{}, &draw/2)
    |> Enum.filter(fn {_, v} -> v >= 2 end)
    |> Enum.count()
  end

  def run() do
    [6311, 19929] = [ work(fn [x1,y1,x2,y2] -> x1==x2 or y1==y2 end), work(&(&1)) ]
  end

end
