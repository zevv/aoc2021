
defmodule Day18 do

  def explode(l, d, cr, done) do
    case {done, d, l} do
      {false, 4, ["[", n1, ",", n2, "]" | r]} ->
        {r, _} = explode(r, d, n2, true)
        {["0" | r], n1}
      {_, _, ["," | r]} ->
        {r, cl} = explode(r, d, cr, done)
        {["," | r], cl}
      {_, _, ["[" | r]} ->
        {r, cl} = explode(r, d+1, cr, done)
        {["[" | r], cl}
      {_, _, ["]" | r]} ->
        {r, cl} = explode(r, d-1, cr, done)
        {["]" | r], cl}
      {_, _, [n | r]} ->
        {r, cl} = explode(r, d, "0", done)
        v = Enum.map([n, cr, cl], &String.to_integer/1) |> Enum.sum
        {["#{v}" | r], "0"}
      {_, _, n} ->
        {n, "0"}
    end
  end

  def explode(l) do
    elem(explode(l, 0, "0", false), 0)
  end

  def split(l, done \\ false) do
    case l do
      [n | r] ->
        if not done and String.length(n) > 1 do
          val = String.to_integer(n)
          v1 = div(val, 2)
          [ "[", "#{v1}", ",", "#{val - v1}", "]" | split(r, true)]
        else
          [n | split(r, done)]
        end
      [] ->
        []
    end
  end

  def reduce(s) do
    snext = explode(s)
    if snext != s do
      reduce(snext)
    else
      snext = split(s)
      if snext != s do reduce(snext) else s end
    end
  end

  def sum(ns) do
    case ns do
      [n1, n2 | rest ] -> 
        ns = List.flatten([ "[", n1, ",", n2, "]" ]) |> reduce
        sum([ns | rest])
      [n] -> n
      [] -> []
    end
  end

  def aux(l) do
    case l do
      [a, b] -> 3 * aux(a) + 2 * aux(b)
      v -> v
    end
  end

  def mag(s) do
    {:ok, l} = Enum.join(s) |> Code.string_to_quoted(s)
    aux(l)
  end

  def run do
    ls = File.read!("data/18.txt")
         |> String.split("\n", trim: true)
         |> Enum.map(fn s -> String.split(s, "", trim: true) end)

    part1 = ls |> sum |> mag

    part2 = for x <- ls do for y <- ls do sum([x, y]) |> mag end end
            |> List.flatten
            |> Enum.max

    [3411, 4680] = [part1, part2]
  end
end

