
defmodule Day16 do

  def parse_lit(bits, lit \\ 0) do
    case bits do
      <<1::1, val::4, rest::bits>> -> parse_lit(rest, lit * 16 + val)
      <<0::1, val::4, rest::bits>> -> {rest, 0, lit*16 + val}
    end
  end
  
  def parse_op_bits(bits, vsum, data, n) do
    case n do
      0 -> {bits, vsum, data}
      n ->
        {rest, vsum2, val} = parse_pkt(bits)
        n = n - (bit_size(bits)- bit_size(rest))
        parse_op_bits(rest, vsum + vsum2, [val | data], n)
    end
  end

  def parse_op_pkts(bits, vsum, data, n) do
    case n do
      0 -> {bits, vsum, data}
      n ->
        {rest, vsum2, val} = parse_pkt(bits)
        parse_op_pkts(rest, vsum + vsum2, [val | data], n-1)
    end
  end

  def parse_op(bits, oper) do
    {rest, vsum, data} = case bits do
      <<0::1, len::15, rest::bits>> -> parse_op_bits(rest, 0, [], len)
      <<1::1, len::11, rest::bits>> -> parse_op_pkts(rest, 0, [], len)
    end
    {rest, vsum, oper.(data)}
  end

  def parse_pkt(bits) do
    <<ver::3, type::3, rest::bits>> = bits
    case type do
      0 -> parse_op(rest, &Enum.sum/1)
      1 -> parse_op(rest, &Enum.product/1)
      2 -> parse_op(rest, &Enum.min/1)
      3 -> parse_op(rest, &Enum.max/1)
      4 -> parse_lit(rest)
      5 -> parse_op(rest, fn [b, a] -> if a > b do 1 else 0 end end)
      6 -> parse_op(rest, fn [b, a] -> if a < b do 1 else 0 end end)
      7 -> parse_op(rest, fn [b, a] -> if a == b do 1 else 0 end end)
    end
    |> then(fn {rest, vsum, data} -> {rest, vsum+ver, data} end)
  end

  def run do
    {_, part1, part2} = File.read!("data/16.txt")
                        |> String.trim
                        |> Hexate.decode
                        |> parse_pkt

    [871, 68703010504] = [part1, part2]
  end
end

