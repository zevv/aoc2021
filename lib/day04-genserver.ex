
#
# Alternative day 04 implementation using actors for the game host and players
#

defmodule Day04_genserver do

  defmodule Player do
    use GenServer

    # Init player, recieves a board from the host
    def init(board) do
      {:ok, %{board: board, score: 0, round: 0}}
    end

    # Received a number and round from the host
    def handle_cast({n, round}, player) do
      player = case player.score do
        0 ->
          board = Enum.map(player.board, &(if &1 == n do "X" else &1 end))
          score = Day04.calc_score(board) * String.to_integer(n)
          %{player | board: board, score: score, round: round}
        _ ->
          player
      end
      {:noreply, player}
    end

    # Host indicates the game is over, report the score
    def handle_cast(:done, player) do
      GenServer.cast(:host, {player.round, player.score})
      {:stop, :normal, player}
    end

  end


  defmodule Host do
    use GenServer

    # Start the host. Parse numbers and boards and spawn player genservers
    def init(_) do
      [numbers | boards] = File.read!("data/04.txt") |> String.split("\n\n")
      numbers = String.split(numbers, ",")
      players = boards
               |> Enum.map(&String.split(&1))
               |> Enum.map(&GenServer.start_link(Player, &1))
      host = %{numbers: numbers, players: players, scores: []}
      play(host, 0)
      {:ok, host}
    end

    # Play a round: draw a number and send it to all the players
    defp play(host, round) do
      case host.numbers do
        [n | numbers] ->
          Enum.map(host.players, fn {:ok, p} ->
            GenServer.cast(p, {n, round})
          end)
          play(%{host | numbers: numbers}, round+1)
        [] ->
          Enum.map(host.players, fn {:ok, p} ->
            GenServer.cast(p, :done)
          end)
      end
    end

    # Receive score from a player
    def handle_cast({round, score}, host) do
      scores = [{round, score} | host.scores]
      if Enum.count(scores) == Enum.count(host.players) do
        s = Enum.sort(host.scores, fn {a,_},{b,_} -> a<b end)
        IO.inspect [ elem(List.first(s), 1), elem(List.last(s), 1) ]
        {:stop, :normal, host}
      else
        {:noreply, %{host | scores: scores} }
      end
    end
  end

  def run() do
    {:ok, _} = GenServer.start_link(Host, 0, name: :host)
  end

end

