
defmodule Day10 do

  @score1 %{ ")"=>3, "]"=>57, "}"=>1197, ">"=>25137 }
  @score2 %{ "("=>1, "["=>2, "{"=> 3, "<"=> 4 }
  @opens  %{ ")"=>"(", "}"=>"{", ">"=> "<", "]"=>"[" }

  def parse(ctx, []) do
    ctx
  end

  def parse(ctx, [c|cs]) do
    is_open = c in ["(","{","<","["]
    case {is_open, c, @opens[c], @score1[c], ctx} do
      {true,  c, _, _, {0, st}    } -> parse({0, [c|st]}, cs)
      {false, _, o, _, {0, [o|st]}} -> parse({0, st}, cs)
      {false, _, _, s, ctx        } -> {s, ctx}
    end
  end

  defp complete(st, n) do
    case st do
      [] -> n
      [c | st] -> complete(st, n*5 + @score2[c])
    end
  end

  def middle(l) do
    Enum.sort(l) |> Enum.at(div(Enum.count(l)-1, 2))
  end

  def run do
    d = File.read!("data/10.txt")
        |> String.split("\n", trim: true)
        |> Enum.map(&String.split(&1, "", trim: true))
        |> Enum.map(&parse({0, []}, &1))

    part1 = Enum.reduce(d, 0, fn v, acc -> acc + elem(v, 0) end)

    part2 = d
            |> Enum.filter(fn {score, _} -> score == 0 end)
            |> Enum.map(&complete(elem(&1, 1), 0))
            |> middle

    [370407, 3249889609] = [part1, part2]
  end

end

