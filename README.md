# Easy Leaderboard Godot Client

## Features

### EasyLeaderboard System
Found under `/api/EasyLeaderboard.tscn`.
This scene can be used to directly interact with the Easy Leaderboard API.

### Score Submission Modal
TODO

### Full Leadboard Scene
TODO

## Usage
### Using the User Defined hosted solution
#### Default validation system
You can opt-in to the default validation logic by appending "basic-validation" to your game's key name.

For example, if your game's key name is `garretts-game`, the score will not be validated at all.

If you change the key to `garretts-game-basic-validation` then the score will undergo so generic validation to check for tampering!

If you want more robust validation, see below!

### Hosting yourself (supports custom validation/anti-cheat!)
