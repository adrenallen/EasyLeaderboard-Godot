# EasyLeaderboard + Godot

## Features

### EasyLeaderboard System
Found under `/api/EasyLeaderboard.tscn`.

This scene can be used to directly interact with the Easy Leaderboard API.

### Score Submission Modal
TODO

### Full Leadboard Scene
TODO

## Setup
### Using the User Defined hosted solution
#### Default validation system
You can opt-in to the default validation logic by appending "basic-validation" to your game's key name.

For example, if your game's key name is `garretts-game`, the score will not be validated at all.

If you change the key to `garretts-game-basic-validation` then the score will undergo so generic validation to check for tampering!

If you want more robust validation, see below!

### Hosting yourself (supports custom validation/anti-cheat!)
TODO

## Leaderboards Made With This
### [Planet Jumpers](https://ld45.garrettallen.dev/)
Uses the metadata attribute to store player run information including their place of death, then shows it on the leaderboard!

### [Last Breath](https://garrettmakesgames.itch.io/ld50)
Shows a traditional arcade style score and includes the RNG seed and name of cave.

### [Tribulation](https://garrettmakesgames.itch.io/ld49)
Shows a traditional arcade style score.

### [Speed Blocks](https://garrettmakesgames.itch.io/speed-blocks)
Shows highest scores along with metadata about each score like max multiplier, total blocks placed, and average time to place a block.

This game also uses  metadata from the gameplay with a custom validator to prevent cheating!

### [Glitch Sweeper](https://garrettmakesgames.itch.io/glitch-sweeper)
Shows top 10 fastest times to clear the board
