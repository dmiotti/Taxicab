defmodule Taxicab do

  defmodule State do
    defstruct direction: :north, moves: [ %{x: 0, y: 0} ]
  end

  def init, do: %State{}

  def move(move, steps, state) do
    {new_direction, coef} = next_direction(state.direction, move)
    coord = advance(steps * coef, state)
    %{state | direction: new_direction, moves: state.moves ++ [coord]}
  end

  def load(moves, state) do
    String.replace(moves, " ", "")
    |> String.split(",")
    |> Enum.map(fn x -> String.split_at(x, 1) end)
    |> Enum.map(fn x -> case x do
      {"L", steps} -> {:left, String.to_integer(steps)}
      {"R", steps} -> {:right, String.to_integer(steps)}
    end end)
    |> Enum.reduce(state, fn (x, acc) -> move(elem(x, 0), elem(x, 1), acc) end)
  end

  def distance(state) do
    move = Enum.at(state.moves, -1)
    move.x + move.y
  end

  defp advance(value, state) do
    move = Enum.at state.moves, -1
    case state.direction do
      :north -> %{x: move.x + value, y: move.y}
      :south -> %{x: move.x + value, y: move.y}
      :est   -> %{x: move.x, y: move.y + value}
      :west  -> %{x: move.x, y: move.y + value}
    end
  end

  defp next_direction(from, handside) do
    case {from, handside} do
      {:north, :left } -> {:west,  -1}
      {:north, :right} -> {:est,   +1}
      {:south, :left } -> {:est,   +1}
      {:south, :right} -> {:west,  -1}
      {:est,   :left } -> {:north, +1}
      {:est,   :right} -> {:south, -1}
      {:west,  :left } -> {:south, -1}
      {:west,  :right} -> {:north, +1}
    end
  end
end
