
defmodule Day02 do

  defp move1([dir, a], [x, y, 0]) do
    case dir do
      "forward" -> [x+a, y, 0]
      "down"  -> [x, y+a, 0]
      "up" -> [x, y-a, 0]
    end
  end
  
  defp move2([dir, a], [x, y, aim]) do
    case dir do
      "forward" -> [x+a, y+aim*a, aim]
      "down"  -> [x, y, aim+a]
      "up" -> [x, y, aim-a]
    end
  end

  defp run(move) do
    File.stream!("data/02.txt")
    |> Enum.map(&String.split(&1))
    |> Enum.map(fn [d, a] -> [d, String.to_integer(a)] end)
    |> Enum.reduce([0, 0, 0], move)
    |> Enum.take(2)
    |> Enum.product()
  end

  def run() do
    [1762050, 1855892637] = [run(&move1/2), run(&move2/2)] 
  end

end

