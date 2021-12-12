
defmodule Day12 do

  import Enum

  def walk("end", _, visits, _) do
    join(reverse(visits), ",")
  end

  def walk(pos, graph, visits, max_visits) do
    visits = [pos | visits]
    map(graph[pos], fn nextpos ->
      n = count(visits, &(&1 == nextpos))
      if n < max_visits[nextpos] do
        walk(nextpos, graph, visits, max_visits)
      else
        []
      end
    end)
  end

  def run1(graph, visits, max_visits) do
    walk("start", graph, visits, max_visits)
    |> List.flatten()
  end
  
  def run2(graph, max_visits) do
    Map.keys(graph)
    |> filter(&(&1 not in ["start","end"] and String.upcase(&1) != &1))
    |> map(&run1(graph, [], Map.put(max_visits, &1, 2)))
    |> concat
    |> uniq
    |> count
  end

  def run do
    graph = File.read!("data/12.txt")
    |> String.split("\n", trim: true)
    |> map(&String.split(&1, "-", trim: true))
    |> map(fn [a,b] -> [[a,b], [b,a]] end)
    |> concat
    |> group_by(fn l -> hd(l) end, fn [_, v] -> v end)
    
    max_visits = Map.keys(graph)
                 |> into(%{}, &{&1, if String.upcase(&1) != &1 do 1 else 10000 end})

    part1 = run1(graph, [], max_visits) |> uniq |> count
    part2 = run2(graph, max_visits)

    [4167, 98441] = [part1, part2]

  end

end
