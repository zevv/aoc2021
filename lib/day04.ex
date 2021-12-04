
defmodule Day04 do

  defmodule Player do
    use GenServer

    @impl true
    def init(board) do
      {:ok, %{board: board, score: 0, round: 0}}
    end
    
    @impl true
    def handle_cast({n, round}, player) do

      player = case player.score do
        0 ->
          board = Enum.map(player.board, &(if &1 == n do "X" else &1 end))
          score = calc_score(player.board) * String.to_integer(n)
          %{player | board: board, score: score, round: round}
          IO.puts("win #{score}")
        _ ->
          player
      end

      {:noreply, player}
    end

    defp calc_score(b) do
      rows = Enum.chunk_every(b, 5)
      if full?(rows) or full?(transpose(rows)) do
        b
        |> Enum.filter(&(&1 != "X"))
        |> Enum.map(&String.to_integer/1)
        |> Enum.sum
      else
        0
      end
    end
    
    defp transpose(b) do
      b |> Enum.zip |> Enum.map(&Tuple.to_list/1)
    end

    defp full?(rows) do
      Enum.any?(rows, fn row -> Enum.all?(row, &(&1 == "X")) end)
    end

  end

  defmodule Host do
    use GenServer

    @impl true
    def init(_) do
      [numbers | boards] = File.read!("data/04.txt") |> String.split("\n\n")
      numbers = String.split(numbers, ",")
      players = boards
               |> Enum.map(&String.split(&1))
               |> Enum.map(&GenServer.start_link(Day04.Player, &1))
      {:ok, %{numbers: numbers, players: players} }
    end

    defp play(host, round) do
      case host.numbers do
        [n | numbers] ->
          Enum.map(host.players, fn {:ok, p} ->
            GenServer.cast(p, {n, round})
          end)
          play(%{host | numbers: numbers}, round+1)
        [] ->
          "done"
      end
    end

    @impl true
    def handle_cast(what, host) do
      case what do
        :play -> play(host, 0)
      end
      {:noreply, host}
    end

  end


  def run2() do
    {:ok, host} = GenServer.start_link(Day04.Host, 0)
    GenServer.cast(host, :play)
  end


  defp transpose(b) do
    b |> Enum.zip |> Enum.map(&Tuple.to_list/1)
  end

  defp full?(rows) do
    Enum.any?(rows, fn row -> Enum.all?(row, &(&1 == "X")) end)
  end

  defp calc_score(b) do
    rows = Enum.chunk_every(b, 5)
    if full?(rows) or full?(transpose(rows)) do
      b
      |> Enum.filter(&(&1 != "X"))
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum
    else
      0
    end
  end

  defp update_board(board, n, round) do
    case board.score do
      0 ->
        rows = Enum.map(board.rows, &(if &1 == n do "X" else &1 end))
        score = calc_score(rows) * String.to_integer(n)
        %{board | rows: rows, score: score, round: round}
      _ ->
        board
    end
  end

  defp play(boards, numbers, round) do
    case numbers do
      [n | numbers] ->
        boards 
        |> Enum.map(&update_board(&1, n, round))
        |> play(numbers, round+1)
      [] ->
        boards
    end
  end

  def run() do
    [numbers | boards] = File.read!("data/04.txt") |> String.split("\n\n")
    numbers = String.split(numbers, ",")
    boards = boards
             |> Enum.map(&String.split(&1))
             |> Enum.map(&(%{score: 0, rows: &1, round: 0}))
             |> play(numbers, 0)
             |> Enum.sort(&(&1.round < &2.round))
    [58374, 11377] = [List.first(boards).score, List.last(boards).score]
  end

end

Day04.run()
