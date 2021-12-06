
defmodule Day06 do

  def day(fs, 0) do
    fs
  end

  def day([f0,f1,f2,f3,f4,f5,f6,f7,f8], n) do
    [f1,f2,f3,f4,f5,f6,f7+f0,f8,f0] |> day(n-1)
  end

  defp freq_list(a) do
    Enum.map(0..8, fn x -> Enum.count(a, &(&1==x)) end)
  end

  def run(n) do
    File.read!("data/06.txt")
    |> String.split([",", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> freq_list()
    |> day(n)
    |> Enum.sum()
  end

  def run() do
    [362740, 1644874076764] = [run(80), run(256)]
  end

end
