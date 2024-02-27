# Declarative Programming (BME)

This repository contains my coursework for Declartive Programming (BMEVISZAD00) at Budapest University of Technology and Economics,
written in Elixir and Prolog languages (functional and logical programming).

# Project
In both languages I implemented a solver for the following [Tents problem](https://www.chiark.greenend.org.uk/~sgtatham/puzzles/js/tents.html), which you can find in the respective 'project' folder under elixir and prolog directory.

## Problem description
A rectangular campsite is divided into equal square plots. Initially, most of the plots are empty, with a single tree on each plot. On the empty plots, tents can be pitched, each attached to an adjacent tree, under the following conditions:
- there is maximum of one tree or one tent per plot,
- each tree must have exactly one tent attached to it and each tent must be attached to exactly one tree, 
- a tent may be attached to a tree if the plots on which it stands are adjacent, 
- parcels on which tents stand cannot be side or corner neighbours, i.e. a tent cannot touch any other tent.

There are a total of n*m plots in the campsite (length n, width m). We know the exact location of the trees and the number of tents per row and per pole. The tree to which the tent is attached is called the tent's own tree. Determine the position of the tents in relation to their own tree. In the examples below, trees are denoted by F and tents by S.

## Task
Write a Prolog procedure called satrak that produces all solutions to a problem.
The Prolog procedure has two parameters. The first (input) parameter describes the problem, the second (output) parameter describes the solution. The procedure must output each solution exactly once during the backtracking. If the problem has no solution, the procedure fails.
The input parameter of a Prolog procedure is a structure, where 
- Ss is a list of the number of tents per row,
- Os is the list of the number of tents per column, and
- Fs is the lexicographically ordered list of i-j pairs identifying the row(i) and column(j) of trees.
F

The output parameter of the Prolog procedure is a list describing the position of the tents relative to their own tree, following the order of the trees in Fs. The position of a tent is given by the letter denoting the corresponding sky:
w (west) - the tent is west of its own tree, n (north) - the tent is north of its own tree,
e (east) - the tent is east of its own tree, s (south) - the tent is south of its own tree.
An example of the solution shown in Figure 2 is described in the list below:
You can assume that the number of rows and columns in the puzzle is 999 or less.

# Authorship
The entire work was developed by Balázs Hain.