defmodule MarsRover.Rover do
  @moduledoc """
  A rover implementation. It can be sent to planets.
  """
  use GenServer

  defstruct [:planet, :coordinates, :direction]

  # Initialization
  @spec start_link(atom() | pid(), Int.t(), Int.t(), atom()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(planet, initial_x, initial_y, direction \\ :n) do
    case MarsRover.Planet.has_obstacle?(planet, initial_x, initial_y) do
      false ->
        state = %__MODULE__{planet: planet, coordinates: {initial_x, initial_y}, direction: direction}
        GenServer.start_link(__MODULE__, state)
      _     -> {:error, :obstacle}
    end
  end

  # API

  @spec commands(atom() | pid(), String.t()) :: any()
  def commands(rover, commands) do
    GenServer.call(rover, {:commands, commands |> String.graphemes()})
  end

  # Callbacks
  @spec init(any()) :: {:ok, any()}
  def init(state), do: {:ok, state}

  def handle_call({:commands, commands}, _from, state) do
    state = apply_commands(state, commands)
    {:reply, {:ok, state.coordinates}, state}
  end

  # Helpers
  @spec apply_commands(any(), List.t()) :: any()
  def apply_commands(state, []), do: state
  def apply_commands(state, [command | tail]) do
    {x, y, d} = next_coordinates(state, command)
    {x, y} = MarsRover.Planet.normalize_coordinates(state.planet, x, y)

    case MarsRover.Planet.has_obstacle?(state.planet, x, y) do
      false -> %{state | coordinates: {x, y}, direction: d} |> apply_commands(tail)
      _     -> {:error, :obstacle}
    end
  end

  @spec next_coordinates(any(), String.t()) :: any()
  def next_coordinates(state, "f"), do: forward(state.coordinates, state.direction)
  def next_coordinates(state, "b"), do: backward(state.coordinates, state.direction)
  def next_coordinates(state, "l"), do: turn_left(state.coordinates, state.direction)
  def next_coordinates(state, "r"), do: turn_right(state.coordinates, state.direction)

  @spec turn_left({Int.t(), Int.t()}, :n | :s | :e | :w) :: {Int.t(), Int.t(), :e | :n | :s | :w}
  def turn_left({x, y}, :n), do: {x, y, :w}
  def turn_left({x, y}, :s), do: {x, y, :e}
  def turn_left({x, y}, :e), do: {x, y, :n}
  def turn_left({x, y}, :w), do: {x, y, :s}

  @spec turn_right({Int.t(), Int.t()}, :n | :s | :e | :w) :: {Int.t(), Int.t(), :e | :n | :s | :w}
  def turn_right({x, y}, :n), do: {x, y, :e}
  def turn_right({x, y}, :s), do: {x, y, :w}
  def turn_right({x, y}, :e), do: {x, y, :s}
  def turn_right({x, y}, :w), do: {x, y, :n}

  @spec forward({Int.t(), Int.t()}, atom()) :: {Int.t(), Int.t(), :n | :s | :e | :w}
  def forward({x, y}, :n), do: {x, y - 1, :n}
  def forward({x, y}, :s), do: {x, y + 1, :s}
  def forward({x, y}, :e), do: {x + 1, y, :e}
  def forward({x, y}, :w), do: {x - 1, y, :w}

  @spec backward({Int.t(), Int.t()}, atom()) :: {Int.t(), Int.t(), :n | :s | :e | :w}
  def backward({x, y}, :n), do: {x, y + 1, :n}
  def backward({x, y}, :s), do: {x, y - 1, :s}
  def backward({x, y}, :e), do: {x - 1, y, :e}
  def backward({x, y}, :w), do: {x + 1, y, :w}
end
