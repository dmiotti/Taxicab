defmodule Taxicab do

  defmodule State do
    defstruct x: 0, y: 0, direction: :north
  end

  def init do
    %State{}
  end

  def move(move, steps, state) do
    {new_direction, coef} = next_direction(state.direction, move)
    coord = advance(steps * coef, state)
    %{state | direction: new_direction, x: coord.x, y: coord.y}
  end

  defp advance(value, state) do
    case state.direction do
      :north -> %{x: state.x + value, y: state.y}
      :south -> %{x: state.x + value, y: state.y}
      :est   -> %{x: state.x, y: state.y + value}
      :west  -> %{x: state.x, y: state.y + value}
    end
  end

  defp next_direction(from, :left) do
    case from do
      :north -> {:west,  -1}
      :south -> {:est,   +1}
      :est   -> {:north, +1}
      :west  -> {:south, -1}
    end
  end

  defp next_direction(from, :right) do
    case from do
      :north -> {:est,   +1}
      :south -> {:west,  -1}
      :est   -> {:south, -1}
      :west  -> {:north, +1}
    end
  end
end
