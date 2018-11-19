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
      _ -> {:error, :obstacle}
    end
  end

  # API

  @spec command(atom() | pid(), String.t()) :: any()
  def command(rover, command) do
    GenServer.call(rover, {:command, command})
  end

  # Callbacks
  @spec init(any()) :: {:ok, any()}
  def init(state), do: {:ok, state}

  def handle_call({:command, _command}, _from, state) do
    resp = ""
    {:reply, resp, state}
  end

  # Helpers
end
