
defmodule Day15 do

  def walk(map) do
    q = Heap.new(&(elem(&1, 1) < elem(&2, 1)))
        |> Heap.push({{0, 0}, 0})
    walk(map, finish(map), q, %{})
  end

  def finish(map) do
    {
      (Map.keys(map) |> Enum.map(&elem(&1, 0)) |> Enum.max()),
      (Map.keys(map) |> Enum.map(&elem(&1, 1)) |> Enum.max())
    }
  end
  
  def walk(map, finish, q, costs) do
    {{{x, y}, cost}, q} = Heap.split(q)
    if {x, y} == finish do
      IO.puts(Enum.count(costs))
      cost
    else
      ns = 
        [ {x+0, y-1}, {x-1, y+0}, {x+1, y+0}, {x+0, y+1} ]
        |> Enum.map(fn nb -> {nb, cost + Map.get(map, nb, 100000)} end)
        |> Enum.filter(fn {p, c} -> c < Map.get(costs, p) and c < 100000 end)
      walk(map, finish,
        Enum.reduce(ns, q, fn {nb, c}, q -> Heap.push(q, {nb, c}) end),
        Enum.reduce(ns, costs, fn {nb, c}, cs -> Map.put(cs, nb, c) end)
      )
    end
  end

  def dup5(map) do
    {w, h} = finish(map)
    for i <- 0..4 do
      for j <- 0..4 do
        for x <- 0..w do
          for y <- 0..h do
            v = Map.get(map, {x, y}) + i + j
            {{x + i*(w+1), y + j*(h+1)}, rem((v - 1), 9) + 1}
          end
        end
      end
    end
    |> List.flatten
    |> Map.new
  end

  def run() do
    map = Day09.parse_map("data/15.txt")
    [472, 2851] = [walk(map), walk(map |> dup5)]
  end

end
