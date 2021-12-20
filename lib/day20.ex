
defmodule Day20 do
  
  def grow(map, 0) do
    map
  end

  def grow(map, n) do
    keys = Map.keys(map) 
    {x1, x2} = keys |> Enum.map(&elem(&1, 0)) |> Enum.min_max()
    {y1, y2} = keys |> Enum.map(&elem(&1, 1)) |> Enum.min_max()
    Enum.concat(
      for x <- [x1-1, x2+1], y <- y1-1 .. y2+1 do {x, y} end,
      for y <- [y1-1, y2+1], x <- x1-1 .. x2+1 do {x, y} end
    )
    |> Enum.map(&({&1, "."}))
    |> Map.new
    |> Map.merge(map)
    |> grow(n-1)
  end
  
  def shrink(map) do
    keys = Map.keys(map) 
    {x1, x2} = keys |> Enum.map(&elem(&1, 0)) |> Enum.min_max()
    {y1, y2} = keys |> Enum.map(&elem(&1, 1)) |> Enum.min_max()
    Enum.concat(
      for x <- [x1, x2], y <- y1 .. y2 do {x, y} end,
      for y <- [y1, y2], x <- x1 .. x2 do {x, y} end
    )
    |> Enum.reduce(map, fn p, map ->
      Map.delete(map, p)
    end)
  end

  def hop(map, algo, 0) do
    map
  end

  def hop(map, algo, n) do
    IO.puts(n)
    map = map
          |> Map.map(fn {{x,y}, v} -> 
            idx = Enum.reduce(neigh({x, y}), 0, fn p, sum ->
              v = if Map.get(map, p) == "#" do 1 else 0 end
              sum * 2 + v
            end)
            Enum.at(algo, idx+0)
          end)
          |> shrink
          |> shrink
    hop(map, algo, n-1)
  end
  
  def neigh {x, y}  do
    [ {x-1, y-1}, {x+0, y-1}, {x+1, y-1},
      {x-1, y+0}, {x+0, y+0}, {x+1, y+0},
      {x-1, y+1}, {x+0, y+1}, {x+1, y+1} ]
  end


  def work(n) do

    [algo, map] = File.read!("data/20.txt")
                  |> String.split("\n\n", trim: true)

    algo = algo |> String.split("", trim: true)

    map = map 
    |> String.split("\n", trim: true)
    |> Enum.map(fn e ->
      String.split(e, "", trim: true)
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

    map
    |> grow(n*4)
    |> hop(algo, n)
    |> Enum.filter(fn {_, v} -> v == "#" end)
    |> Enum.count

  end

  def run do
    [5786, 16757] = [work(2), work(50)]
  end

end
