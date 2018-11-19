defmodule RoverTest do
  use ExUnit.Case

  test "create a rover and send to planet" do
    {:ok, mars} = MarsRover.Planet.start_link(10, 10)
    {:ok, _rover} = MarsRover.Rover.start_link(mars, 1, 1)
  end

  test "send a rover to an obstacle" do
    {:ok, mars} = MarsRover.Planet.start_link(10, 10)
    {:ok, {1, 1}} = MarsRover.Planet.add_obstacle(mars, 1, 1)

    {:error, :obstacle} = MarsRover.Rover.start_link(mars, 1, 1)
  end

  test "send a rover to an obstacle crossing x edge" do
    {:ok, mars} = MarsRover.Planet.start_link(10, 10)
    {:ok, {1, 1}} = MarsRover.Planet.add_obstacle(mars, 1, 1)

    {:error, :obstacle} = MarsRover.Rover.start_link(mars, 11, 1)
  end

  test "send a rover to an obstacle crossing y edge" do
    {:ok, mars} = MarsRover.Planet.start_link(10, 10)
    {:ok, {1, 1}} = MarsRover.Planet.add_obstacle(mars, 1, 1)

    {:error, :obstacle} = MarsRover.Rover.start_link(mars, 1, 11)
  end
end
