# mars_rover

Mars Rover Kata

## Getting started

Create a new planet indicating the grid dimensions:
        
    {:ok, mars} = MarsRover.Planet.start_link(10, 10)

Adding some obstacles in planet grid:

    {:ok, {3, 1}} = MarsRover.Planet.add_obstacle(mars, 3, 1)

Create a new Rover indicating the landing coordinates and the initial facing direction (default is :n):
        
    {:ok, rover} = MarsRover.Rover.start_link(mars, 1, 1, :s)

Send command to rover (f, b, l, r):
        
    {:ok, {1, 10}} = MarsRover.Rover.commands(rover, "fffffffff")

`MarsRover.Rover.commands/2` returns the final position coordinates after moving.

If rover hits an obstacle, `MarsRover.Rover.commands/2` returns the obstacle position in planet grid 

    {:error, {:obstacle, {3, 1}}} = MarsRover.Rover.commands(rover, "bbbbbbbbblff")

You can get the current rover position coordinates using `MarsRover.Planet.Rover.position/1`:

    {2, 1} = MarsRover.Rover.position(rover)
