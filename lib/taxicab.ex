defmodule Taxicab do

  defmodule State do
    defstruct x: 0, y: 0, direction: :north
  end

  def init, do: %State{}

  def move(move, steps, state) do
    {new_direction, coef} = next_direction(state.direction, move)
    coord = advance(steps * coef, state)
    %{state | direction: new_direction, x: coord.x, y: coord.y}
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

  def distance(state), do: state.x + state.y

  defp advance(value, state) do
    case state.direction do
      :north -> %{x: state.x + value, y: state.y}
      :south -> %{x: state.x + value, y: state.y}
      :est   -> %{x: state.x, y: state.y + value}
      :west  -> %{x: state.x, y: state.y + value}
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
