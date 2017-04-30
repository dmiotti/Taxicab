defmodule Taxicab do

  defmodule State do
    defstruct direction: :north, positions: [{0, 0}]
  end

  # API

  def init, do: %State{}

  def move(handside, steps, state) do
    {new_direction, coef} = next_direction(state.direction, handside)
    new_state = 1..steps |> Enum.reduce(state, fn (_, acc) ->
      next_pos = advance(coef, acc)
      %{acc | positions: acc.positions ++ [next_pos]}
    end)
    %{new_state | direction: new_direction}
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

  def visited_positions(state) do
    visited = state.positions |> Enum.reduce(%{}, fn (pos, acc) ->
      case Map.has_key?(acc, pos) do
        true ->
          Map.update!(acc, pos, &(&1 + 1))
        false ->
          Map.put_new(acc, pos, 1)
      end
    end)
    state.positions |> Enum.map(fn pos ->
      {:ok, nb} = Map.fetch(visited, pos)
      Tuple.append(pos, nb)
    end)
  end

  def distance(state) do
    pos = Enum.at(state.positions, -1)
    abs(get_x(pos)) + abs(get_y(pos))
  end

  # Private Functions

  defp get_x(pos), do: elem(pos, 0)
  defp get_y(pos), do: elem(pos, 1)

  defp advance(value, state) do
    pos = Enum.at state.positions, -1
    case state.direction do
      :north -> {get_x(pos) + value, get_y(pos)}
      :south -> {get_x(pos) + value, get_y(pos)}
      :est   -> {get_x(pos), get_y(pos) + value}
      :west  -> {get_x(pos), get_y(pos) + value}
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
