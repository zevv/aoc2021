
defmodule Day07 do

  def calc(d, cost) do
    for a <- Enum.min(d)..Enum.max(d) do
      Enum.map(d, fn x -> cost.(abs(x - a)) end)
      |> Enum.sum()
    end
    |> Enum.min()
  end

  def run1(d) do
    calc(d, &(&1))
  end
  
  def run2(d) do
    calc(d, &(div(&1*(&1-1), 2)))
  end

  def run() do
    d = File.read!("data/07.txt")
        |> String.split([",","\n"], trim: true)
        |> Enum.map(&String.to_integer/1)

    [340052, 92596053] = [run1(d), run2(d)]
  end

end
