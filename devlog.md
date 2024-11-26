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

### 2024-10-8 2hr:
* Preliminary route management implementation. It's working but it's not very clean. I will refactor it later.

### 2024-10-9 3hr:
* Watched a bunch of videos on gdscript and godot best practices

### 2024-10-13 2hr:
* Watched a bunch of videos on gdscript and godot best practices again
* Made a MyGPT that focuses on best practices and knows to generate code in Godot 4 syntax.

### 2024-10-18 8hr:
* Made a side project that is like a transparent overlay that shows a pixel city. https://github.com/lettucegoblin/desktop-city-sim
  * I tested out a bunch of different ui and nodes in godot to get more comfortable with the engine for the main project. I also learned how to use the viewport node to create a transparent overlay. And how to use the camera2d with separate canvas layers. 

### 2024-10-19 8hr: 
* fussing on generating planets. I used a local llm to generate a ton of planet, cluster, resources, special_features, hazards, and trade_goods for a json file
  * I then used this in godot to generate the planets and their attributes. I also used it to make routes between planets in different clusters

### 2024-10-20 9hr:
* Updated the route management system to use the new planet generation system with proper signalling and displaying for clusters.
* Made a universe scene that has cluster's orbiting a central star. The clusters have planets that orbit them. The planets have resources, special features, hazards, and trade goods. The planets are connected by routes(just in code for now). 
  * Each nested scene is passed data from signalling to keep the view updated with the model. I'm really trying not to mix the view and model.

### 2024-10-21 8hr:
* Tested the making the mini planets around the miniclusters in the universe scene a particle system that orbits the minicluster. It works but doesn't spawn the particles with enough consistency and is difficult to debug with particles that have a practicle infinite lifespan. The editor has to be reset each time i want to test another setting.
* I rewrote it with a regular physicsbody2d and it was easier to test but i didnt like fussing with n-body problems as they collided with each other.
* I rewrite it again with a regular sprite that uses a path2d to orbit the minicluster. They're just glorified progressbars and made things simple and predictable.

### 2024-10-22 10hr:
* Started writing the route management scene that actually shows the routes that had been generated. There's a ListItem node that is used to display the routes. I'm using a signal to update the list item with the route data. I had to separate the galaxy map with a canvaslayer so the zooming of the camera from the galaxy map wouldn't affect the route management scene.
* Wrote my dev log

### 2024-11-05 6hr:
* Implemented a recolor shader to allow dynamic adjustment of planet colors based on their attributes (hazards, resources, and trade goods). This enhances the visual distinctiveness of each planet.
* Updated planet handling to include size and attribute scaling. Larger planets with high hazards or abundant resources now appear proportionally in the scene.
* Enhanced the UI for route management, introducing a new theme with adjusted font sizes to improve readability. 
* Added a Welcome Modal theme to onboard players to the game.
* Imported new assets for the licensed hauler feature, including a badge icon and a certificate screen. 

### 2024-11-08 7hr:
* Added detailed haul information to routes, displaying trade goods being transported between planets. This gives players a clearer sense of the impact of their trade decisions.
* Implemented random trade good selection based on planetary resources and demand using weighted probabilities. Testing revealed some rare items appearing more often than expected, but it added charm to gameplay.
* Began experimenting with new animations for the ship when it enters a planet's orbit. Added subtle engine flare animations for larger hauls.

### 2024-11-09 5hr:
* Enhanced route management UI with clearer indicators for active and inactive routes. Inactive routes now appear grayed out with a tooltip explaining why they cannot be used.
* Polished the recolor shader, ensuring smooth transitions when planets change attributes dynamically.
* Updated the GameManager to include pilot and ship details, allowing customization options that persist between sessions.
* Updated .gitignore to exclude all build artifacts, reducing repository clutter and preventing accidental commits of local files.

### 2024-11-25 8hr:
* Added functions for planet size retrieval to standardize planet scaling across the universe scene.
* Enhanced route management by introducing a system for prioritizing high-value routes, giving players more strategic control over their hauls.
* Updated UI elements with dynamic resizing to ensure consistency across different screen resolutions.
* Tested the system with several combinations of trade goods, hazards, and special features. Fixed a bug where high-value routes were occasionally displayed incorrectly.
* Refined the progress bars used in route display to visually represent route completion, giving players a quick understanding of their progress.

### 2024-11-25 2hr:
* Updated README to reflect new gameplay features, added attributions for newly imported assets, and documented recent changes in route management and planet handling.
* Wrote my dev log with the help of ChatGPT.
