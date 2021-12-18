defmodule Day17 do

  def pewpew({x, y}, iv, {dx, dy}, {x1, y1, x2, y2}) do
    cond do
      x >= x1 and x <= x2 and y >= y1 and y <= y2 ->
        iv
      y < y1 and y < y2 ->
        false
      true ->
        pewpew({x+dx, y+dy}, iv, {max(0, dx-1), dy-1}, {x1, y1, x2, y2})
    end
  end

  def run do
    [_, x1, x2, _, y1, y2] = File.read!("data/17.txt")
                             |> String.trim()
                             |> String.split(["=", ".", ","], trim: true)
    target = [x1, y1, x2, y2]
           |> Enum.map(&String.to_integer/1)
           |> List.to_tuple

    l = for dx <- 1..80 do for dy <- -200..200 do {dx, dy} end end
        |> List.flatten
        |> Enum.map(&pewpew({0, 0}, &1, &1, target))
        |> Enum.filter(&(&1))

    l |>
    Enum.map(fn {x, y} -> IO.puts("#{x} #{y}") end)

    part1 = l
            |> Enum.max_by(fn {dx, dy} -> dy end)
            |> then(fn {_, dy} -> ((dy + 1) * 0.5) * dy end)

    part2 = l
            |> Enum.uniq
            |> Enum.count

    [13041.0, 1031] = [part1, part2]

  end
end
