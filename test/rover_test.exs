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

  test "create a rover, send to planet whithout move it" do
    {:ok, mars} = MarsRover.Planet.start_link(10, 10)
    {:ok, rover} = MarsRover.Rover.start_link(mars, 1, 1)
    {:ok, {1, 1}} = MarsRover.Rover.commands(rover, "")
  end

  test "create a rover, send to planet whithout obstacles and move it" do
    {:ok, mars} = MarsRover.Planet.start_link(10, 10)
    {:ok, rover} = MarsRover.Rover.start_link(mars, 1, 1, :s)
    {:ok, {1, 10}} = MarsRover.Rover.commands(rover, "fffffffff")
  end

  test "create a rover, send to planet whithout obstacles, move it and turn" do
    {:ok, mars} = MarsRover.Planet.start_link(10, 10)
    {:ok, rover} = MarsRover.Rover.start_link(mars, 1, 1, :s)
    {:ok, {2, 4}} = MarsRover.Rover.commands(rover, "ffflf")
  end

  test "create a rover, send to planet whithout obstacles, move it to opposite corner from {1, 1}" do
    {:ok, mars} = MarsRover.Planet.start_link(10, 10)
    {:ok, rover} = MarsRover.Rover.start_link(mars, 1, 1, :s)
    {:ok, {10, 10}} = MarsRover.Rover.commands(rover, "ffffffffflfffffffff")
  end

  test "create a rover, send to planet whithout obstacles, move it to opposite corner from {10, 10}" do
    {:ok, mars} = MarsRover.Planet.start_link(10, 10)
    {:ok, rover} = MarsRover.Rover.start_link(mars, 10, 10, :n)
    {:ok, {1, 1}} = MarsRover.Rover.commands(rover, "ffffffffflfffffffff")
  end

  test "rover goes along the edges forward" do
    {:ok, mars} = MarsRover.Planet.start_link(10, 10)
    {:ok, rover} = MarsRover.Rover.start_link(mars, 1, 1, :e)
    {:ok, {1, 1}} = MarsRover.Rover.commands(rover, "fffffffffrfffffffffrfffffffffrfffffffff")
  end

  test "rover goes along the edges backward" do
    {:ok, mars} = MarsRover.Planet.start_link(10, 10)
    {:ok, rover} = MarsRover.Rover.start_link(mars, 1, 1, :w)
    {:ok, {1, 1}} = MarsRover.Rover.commands(rover, "bbbbbbbbblbbbbbbbbblbbbbbbbbblbbbbbbbbb")
  end

  test "rover goes over north edge forward" do
    {:ok, mars} = MarsRover.Planet.start_link(10, 10)
    {:ok, rover} = MarsRover.Rover.start_link(mars, 1, 1, :n)
    {:ok, {1, 10}} = MarsRover.Rover.commands(rover, "f")
  end

  test "rover goes over south edge forward" do
    {:ok, mars} = MarsRover.Planet.start_link(10, 10)
    {:ok, rover} = MarsRover.Rover.start_link(mars, 1, 1, :s)
    {:ok, {1, 1}} = MarsRover.Rover.commands(rover, "ffffffffff")
  end

  test "rover goes over est edge forward" do
    {:ok, mars} = MarsRover.Planet.start_link(10, 10)
    {:ok, rover} = MarsRover.Rover.start_link(mars, 1, 1, :e)
    {:ok, {1, 1}} = MarsRover.Rover.commands(rover, "ffffffffff")
  end

  test "rover goes over west edge forward" do
    {:ok, mars} = MarsRover.Planet.start_link(10, 10)
    {:ok, rover} = MarsRover.Rover.start_link(mars, 1, 1, :w)
    {:ok, {10, 1}} = MarsRover.Rover.commands(rover, "f")
  end

  test "rover goes over north edge backward" do
    {:ok, mars} = MarsRover.Planet.start_link(10, 10)
    {:ok, rover} = MarsRover.Rover.start_link(mars, 1, 1, :s)
    {:ok, {1, 10}} = MarsRover.Rover.commands(rover, "b")
  end

  test "rover goes over south edge backward" do
    {:ok, mars} = MarsRover.Planet.start_link(10, 10)
    {:ok, rover} = MarsRover.Rover.start_link(mars, 1, 1, :n)
    {:ok, {1, 1}} = MarsRover.Rover.commands(rover, "bbbbbbbbbb")
  end

  test "rover goes over est edge backward" do
    {:ok, mars} = MarsRover.Planet.start_link(10, 10)
    {:ok, rover} = MarsRover.Rover.start_link(mars, 1, 1, :w)
    {:ok, {1, 1}} = MarsRover.Rover.commands(rover, "bbbbbbbbbb")
  end

  test "rover goes over west edge backward" do
    {:ok, mars} = MarsRover.Planet.start_link(10, 10)
    {:ok, rover} = MarsRover.Rover.start_link(mars, 1, 1, :e)
    {:ok, {10, 1}} = MarsRover.Rover.commands(rover, "b")
  end
end
