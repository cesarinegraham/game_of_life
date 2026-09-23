## John Conway's Game of Life (MATLAB)

This MATLAB code enables the user to run the Game of Life, a cellular automaton devised by the mathematician John Horton Conway in 1970. 

There are four simple rules to this game:
  1. Any live cell with fewer than two live neighbours dies, as if by underpopulation.
  2. Any live cell with two or three live neighbours lives on to the next generation.
  3. Any live cell with more than three live neighbours dies, as if by overpopulation.
  4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

The created cell "patterns" can be categorized according to the complexity of their behavior, from simple unchanging ‘still lives’ to emulations of universal Turing machines. See the [Game of Life Lab](https://www.gameoflifelab.com/patterns) for more!

![ ](GOL_Civilizations.jpg)

This code enables the user not only to run the simulation, but to also customize the simulation's appearance, grid size, and run speeds. Each cell birth and death is also tallied and time-kept in the "GOL_Log.txt"
