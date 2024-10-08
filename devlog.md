# Fall 2024 - Intro to Game Design @ SUNY New Paltz
* Name: Redacted
* [Trello Board](https://github.com/users/lettucegoblin/projects/2/views/1)
* Proposal: [pdf](proposal.pdf) [markdown](idea.md)

### 2024-09-24 2hr:
* Init repo
* Add devlog.md
* Add proposal.md
* Add trello tasks
* Setup itch.io page

### 2024-09-25 3hr:
* Set Up GameManager Script
  * Scene Management
  * Timer API
  * Scene Transitioning
* The singleton pattern is being used with signalling to manage the game state.

### 2024-09-28 5hr:
* Main Menu Scene: Start button, Background, Pretty
  * I struggled to know how to give padding & font sizes to buttons, I had to create a new theme for the buttons to get the padding to work.
* Game Manager: unfinished implementation of route management. 

### 2024-09-29 2hr:
* Procedural Planet Shader

### 2024-09-30 2hr:
* Timer API with gamemanager: transition between focus scene and break scene
* Timer API with gamemanager: transition between break scene and work scene

### 2024-10-1 4hr:
* Fix: Transition timing from work_cycle_outro to Break scene loading.
* Animations: work_cycle_outro, Ship flies off screen
* Animations: Ship engine stabilizers, When ship is idle during break it has little engine stabilizers that move up and down. https://docs.godot.community/tutorials/2d/particle_systems_2d.html

### 2024-10-2 2hr:
* Struggled to blend animations with just AnimationPlayer, I will try to use AnimationTree to blend animations.
* Read:  https://docs.godotengine.org/en/stable/tutorials/animation/animation_tree.html
  * I want to use the animation tree to manage the animations of the ship and the planets. Currently animationplayer is being used and doesn't transition well between animations.
