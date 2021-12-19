
defmodule Day19 do

  def determinant([[a,b,c],[d,e,f],[g,h,i]]) do
    a*(e*i-f*h)-b*(d*i-f*g)+c*(d*h-e*g)
  end

  def build_rotations() do
    for x <- [-1, 1], y <- [-1, 1], z <- [-1, 1] do
      [[x, 0, 0], [0, y, 0], [0, 0, z]]
    end 
    |> Enum.map(&Day08.perms/1)
    |> Enum.concat
    |> Enum.filter(&(determinant(&1) == 1))
  end

  def rotate([a,b,c], [[j,k,l],[m,n,o],[p,q,r]]) do
    [a*j+ b*k + c*l, a*m+ b*n + c*o, a*p+ b*q + c*r]
  end

  def diff([a,b,c], [d,e,f]) do [d-a, e-b, f-c] end
  def dist([a,b,c], [d,e,f]) do abs(d-a) + abs(e-b) + abs(f-c) end
  def add([a,b,c], [d,e,f]) do [d+a, e+b, f+c] end

  def work(ctx) do
    ctx = Enum.reduce(ctx.scans, ctx, fn scan, ctx ->
      Enum.map(ctx.rotations, fn m ->
        Task.async(fn ->
          scan
          |> Enum.map(&rotate(&1, m))
          |> Enum.map(&Enum.map(ctx.beacons, fn p2 -> diff(&1, p2) end))
          |> Enum.concat
          |> Enum.frequencies
          |> Enum.filter(fn {_, v} -> v >= 12 end)
          |> Enum.map(fn x -> {x, m} end)
        end)
      end)
      |> Enum.map(&Task.await/1)
      |> Enum.concat
      |> case do
        [{{location, _}, m}] ->
          beacons = Enum.map(scan, &add(rotate(&1, m), location))
                    |> MapSet.new
                    |> MapSet.union(ctx.beacons)
          %{ctx | 
            beacons: beacons,
            locations: [location | ctx.locations],
            scans: List.delete(ctx.scans, scan)
          }
        _ ->
          ctx
      end
    end)
    case ctx.scans do
      [] -> ctx
      _ -> work(ctx)
    end
  end

  def run do
    scans = File.read!("data/19.txt")
            |> String.split("\n\n", trim: true)
            |> Enum.map(fn s ->
              [_ | ls] = String.split(s, "\n", trim: true)
              Enum.map(ls, fn l ->
                String.split(l, ",", trim: true)
                |> Enum.map(&String.to_integer/1)
              end)
            end)

    ctx = %{
      scans: scans,
      beacons: MapSet.new(hd(scans)),
      locations: [],
      rotations: build_rotations(),
    }
    |> work

    part1 = ctx.beacons |> MapSet.size
    part2 = for d1 <- ctx.locations, d2 <- ctx.locations do dist(d1, d2) end |> Enum.max

    [342, 9668] = [part1, part2]
 end

end

