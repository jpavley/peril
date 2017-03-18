# Peril

A text adventure game written in Swift 3

By John Pavley. MIT License.

## Version 0.1 05/15/2017

Very early version of the game engine. Not even a proof of concept yet.

### Release Notes

This verions of Peril is written to run inside Xcode 8.2. Hit the **Build then run** button and you can interact
with the game in the **Console** of Xcode's **Debug area**. You need to click just after **Enter a command:** to 
set the focus for typing to the **Console**. (I didn't know Xcode could do this until I tried it!)

Right now you can **walk** around from the living room to the attic and garden. You can pick up a bottle, bucket,
frog, key, or ring. You can check your **inventory**. You can **quit**.

### Code Design

The code design for Peril is base on many of the examples from **Land of LISP** by Conrad Barski, M.D. You should
buy it, read it, and love it. Highly recommened. My Swift 3 code is so much more ugly than Barski's LISP. Probably
true for all cases of Swift 3 and LISP.

The basic structure for the world of Peril is a graph of nodes and edges. An edge connects two nodes. Even the same
node to itself (why not?). Edges go in only one direction. Which means you need two edges to make an ordinary 
path between nodes.

All logic is encapulated in the Game class. There is a player with a location and a pocket full of loot. There 
are some rooms with a node, edges, and a cache of loot. Loot is anything the player can pickup. Over time these
elements will get smarter and more functional.

These commands are built into the game: look, walk, pickup, inventory, and quit. Every command can take a
parameter to modify it's behavior as in **walk west** and **pickup bottle**.

### Game Config

Not implemented yet is the ability to fully specify the game in a single JSON file. The game schema is pretty
simple but one convention to keep in mind is that all game elements have IDs. Each kind of element uses a range of
ID numbers...

- Commands 100 - 199
- Nodes 200 - 200
- Edges 300 - 399
- Objects 400 - 499
- Rooms 500 - 599

This convention of ranges for ID numbers give us error checking and limits the number of elements in a game to
499 (which is probably to conservitive but you know, RAM, CPU etc...)

### Future Plans

Peril is going the change rapidly. None of this code is baked. But here are the major changes on deck:

- Generate the game from a JSON File.
- NPCs and monsters that the player can talk to and interact with.
- Objects that perform actions (keys that open doors, doors that lock).
- Scoring.
- Player health.
- Combat system.
- Quests.
- Interal game clock.
- Save and load games inside the game
- Load a game on startup from the command line
- ASCII art.
- Ability to run in a terminal. 
- Player personalization and profiles.
- Color ANSI codes
- Ability to run in a mobile app.
- Ability to run on a web server and be played in a web browser.
- Authoring app that constructs game config files.

### Code Design Goals

I hope to build this game without depenencies on libraries outside of what Apple provides. I tried writing 
a text adventure game before (Himins) with NodeJS and dozens of NPM modules. But the modules kept changing
and the dependencies were driving me crazy. 

I hope to write this game so that non-technical folks can create games on top of it.

I hope to write as little code as possible but still be super readable for a beginner coder.
