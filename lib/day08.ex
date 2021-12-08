# 
#   0:      1:      2:      3:      4:
#  aaaa    ....    aaaa    aaaa    ....
# b    c  .    c  .    c  .    c  b    c
# b    c  .    c  .    c  .    c  b    c
#  ....    ....    dddd    dddd    dddd
# e    f  .    f  e    .  .    f  .    f
# e    f  .    f  e    .  .    f  .    f
#  gggg    ....    gggg    gggg    ....
# 
#   5:      6:      7:      8:      9:
#  aaaa    aaaa    aaaa    aaaa    aaaa
# b    .  b    .  .    c  b    c  b    c
# b    .  b    .  .    c  b    c  b    c
#  dddd    dddd    ....    dddd    dddd
# .    f  e    f  .    f  e    f  .    f
# .    f  e    f  .    f  e    f  .    f
#  gggg    gggg    ....    gggg    gggg

defmodule Day08 do

  @valid [ 'abcefg', 'cf', 'acdeg', 'acdfg', 'bcdf', 'abdfg', 'abdefg', 'acf', 'abcdefg', 'abcdfg' ]
  @base 'abcdefg'

  def perms([]) do [[]] end
  def perms(list) do for h <- list, t <- perms(list -- [h]), do: [h | t] end

  def fixup(s) do
    String.split(s)
    |> Enum.map(fn x ->
      String.to_charlist(x) |> Enum.sort()
    end)
  end

  def run1({_ins, outs}) do
    outs
    |> Enum.count(fn x ->
      Enum.count(x) in [2, 3, 4, 7]
    end)
  end

  def mix(m, s) do
    Enum.map(s, &(m[&1]))
    |> Enum.sort()
  end

  def run2(ps, {ins, outs}) do

    key = ps
          |> Enum.map(fn l -> Map.new(Enum.zip(l, @base)) end)
          |> Enum.filter(fn p ->
            Enum.map(ins, &mix(p, &1))
            |> Enum.all?(&(&1 in @valid))
          end)
          |> hd
    
    [a,b,c,d] = Enum.map(outs, &mix(key, &1))
                |> Enum.map(fn e ->
                  Enum.find_index(@valid, &(&1 == e))
                end)

    a*1000 + b*100 + c*10 + d
  end


  def run() do
    keys = perms(@base)
    
    lines = File.read!("data/08.txt")
            |> String.split("\n", trim: true)
            |> Enum.map(&String.split(&1, " | ", trim: true))
            |> Enum.map(fn [a, b] -> { fixup(a), fixup(b) } end)

    part1 = lines
            |> Enum.map(&run1/1)
            |> Enum.sum()

    part2 = lines 
            |> Task.async_stream(&run2(keys, &1))
            |> Enum.reduce(0, fn {:ok, num}, acc -> num + acc end)

    [397, 1027422] = [part1, part2]
  end

end
