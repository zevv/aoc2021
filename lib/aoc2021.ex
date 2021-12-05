defmodule Aoc2021 do

  def run do

    [
      &Day01.run/0,
      &Day02.run/0,
      &Day03.run/0,
      &Day04.run/0,
      &Day05.run/0,
    ]

    |> Enum.map( &Task.async/1)
    |> Enum.map(&Task.await/1)
  end
end
