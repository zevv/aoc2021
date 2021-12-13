defmodule Day13 do

  defp fold(map, axis, pos) do
    Enum.reduce(map, %{}, fn {{x, y}, v}, map2 ->
      {x, y} = case axis do
        "y" -> {x, if y <= pos do y else 2*pos-y end}
        "x" -> {if x <= pos do x else 2*pos-x end, y}
      end
      Map.put(map2, {x, y}, v)
    end)
  end
  
  defp draw(map) do
    w = Map.keys(map) |> Enum.map(&elem(&1, 0)) |> Enum.max()
    h = Map.keys(map) |> Enum.map(&elem(&1, 1)) |> Enum.max()
    for y <- 0..h do for x <- 0..w do Map.get(map, {x,y}, ".") end |> Enum.join() end |> Enum.join("\n")
    |> IO.puts()
  end
  
  defp do_line(l, map) do
    case String.split(l, [","," ","=","\n"], trim: true) do
      [x, y] -> Map.put(map, {String.to_integer(x), String.to_integer(y)}, '#')
      ["fold", "along", axis, pos] -> fold(map, axis, String.to_integer(pos))
      _ -> map
    end
  end

  def run() do
    map = File.stream!("data/13.txt")
          |> Enum.reduce(%{}, &do_line/2)
          |> draw
    [ 747, "ARHZPCUH" ]
  end
end

