defmodule Aoc2021 do

  def run do

    [
      &Day01.run/0,
      &Day02.run/0,
      &Day03.run/0,
      &Day04.run/0,
      &Day05.run/0,
      &Day06.run/0,
      &Day07.run/0,
      &Day08.run/0,
      &Day09.run/0,
      &Day10.run/0,
    ]

    |> Enum.map(&Task.async/1)
    |> Enum.map(&Task.await/1)
  end
end
