# EasyLeaderboard + Godot
![EasyLeaderboard + Godot](/icon.png)

#### **Add a leaderboard to your game in under 10 minutes!**

🏃 Ready to go game clients make adding a leaderboard quick and easy

🕵️ Extendable score validation system to protect against cheaters

👨‍💻 Open source and easily setup for custom implementations

💸 Optional free-hosting provided at [https://lb.userdefined.io](https://lb.userdefined.io) by [User Defined](https://userdefined.io)

## How to install
1. Copy the `/addons` folder into your Godot project.
2. 

## What's included

### EasyLeaderboard API node
Found under `/api/EasyLeaderboard.tscn`.

This scene can be used to directly interact with the Easy Leaderboard API.

### Score Submission Modal
[Found under /addons/easyleaderboard/leaderboard/LeaderboardScoreSubmitPanel.tscn](addons/easyleaderboard/leaderboard/LeaderboardScoreSubmitPanel.tscn)



### Full Leadboard Scene
[Found under addons/easyleaderboard/leaderboard/Leaderboard.tscn](addons/easyleaderboard/leaderboard/Leaderboard.tscn)


## API Node Configuration
### Using the User Defined hosted solution
#### Default validation system
You can opt-in to the default validation logic by appending "basic-validation" to your game's key name.

For example, if your game's key name is `garretts-game`, the score will not be validated at all.

If you change the key to `garretts-game-basic-validation` then the score will undergo so generic validation to check for tampering!

If you want more robust validation, see below!

### [See how to self-host here (supports custom validation/anti-cheat!)](https://github.com/adrenallen/EasyLeaderboard)

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
