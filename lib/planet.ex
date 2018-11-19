defmodule MarsRover.Planet do
  @moduledoc """
  The planet object represented as a square grid with wrapping edges.
  """

  use GenServer

  defstruct [:grid, :obstacles]

  # API

  @spec start_link(Int.t(), Int.t()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(width, height) when width <= 0 or height <= 0, do: {:error, :invalid_grid}

  def start_link(width, height) do
    state = %__MODULE__{grid: {width, height}, obstacles: []}
    GenServer.start_link(__MODULE__, state)
  end

  @spec add_obstacle(pid(), Int.t(), Int.t()) :: any()
  def add_obstacle(_pid, x, y) when x <= 0 or y <= 0, do: {:error, :invalid_coordinates}

  def add_obstacle(pid, x, y) do
    GenServer.call(pid, {:add_obstacle, x, y})
  end

  # Callbacks

  @spec init(any()) :: {:ok, any()}
  def init(state), do: {:ok, state}

  def handle_call({:add_obstacle, x, y}, _from, %{grid: {width, height}} = state) do
    x = to_planet_edges(x, width)
    y = to_planet_edges(y, height)

    {res, state} = handle_add_obstacle(x, y, state)
    {:reply, res, state}
  end

  # Privates

  # Add a new obstacle in grid, considering circular edges
  defp handle_add_obstacle(x, y, state) when x <= 0 or y <= 0,
    do: {{:error, :invalid_coordinates}, state}

  defp handle_add_obstacle(x, y, state) do
    obstacles =
      [{x, y}]
      |> Kernel.++(state.obstacles)
      |> Enum.uniq()

    {{:ok, {x, y}}, %{state | obstacles: obstacles}}
  end

  # Normalize position considering the circular edge.
  defp to_planet_edges(val, edge) do
    case rem(val, edge) do
      0 -> edge
      n -> n
    end
  end
end
