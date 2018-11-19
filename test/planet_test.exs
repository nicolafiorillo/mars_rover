defmodule PlanetTest do
  use ExUnit.Case

  test "create a valid planet" do
    {:ok, _mars} = MarsRover.Planet.start_link(10, 10)
  end

  test "create a planet with null grid" do
    {:error, :invalid_grid} = MarsRover.Planet.start_link(0, 0)
  end

  test "create a planet with invalid grid" do
    {:error, :invalid_grid} = MarsRover.Planet.start_link(-3, -5)
  end

  test "create a planet adding some obstacles" do
    {:ok, mars} = MarsRover.Planet.start_link(10, 10)

    {:ok, {8, 8}} = MarsRover.Planet.add_obstacle(mars, 8, 8)
    {:ok, {2, 2}} = MarsRover.Planet.add_obstacle(mars, 2, 2)
  end

  test "create a planet adding some obstacles over the edges" do
    {:ok, mars} = MarsRover.Planet.start_link(10, 10)

    {:ok, {2, 2}} = MarsRover.Planet.add_obstacle(mars, 12, 12)
    {:ok, {10, 10}} = MarsRover.Planet.add_obstacle(mars, 10, 10)
    {:ok, {10, 10}} = MarsRover.Planet.add_obstacle(mars, 20, 20)
  end

  test "create a planet adding some invalid obstacles" do
    {:ok, mars} = MarsRover.Planet.start_link(10, 10)

    {:error, :invalid_coordinates} = MarsRover.Planet.add_obstacle(mars, 0, 0)
    {:error, :invalid_coordinates} = MarsRover.Planet.add_obstacle(mars, -3, -4)
  end

  test "create a planet adding an obstacle twice" do
    {:ok, mars} = MarsRover.Planet.start_link(10, 10)

    {:ok, {8, 8}} = MarsRover.Planet.add_obstacle(mars, 8, 8)
    {:ok, {8, 8}} = MarsRover.Planet.add_obstacle(mars, 8, 8)

    %{obstacles: obstacles} = :sys.get_state(mars)
    assert length(obstacles) == 1
  end
end
