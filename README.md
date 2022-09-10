# EasyLeaderboard + Godot 3.5
![EasyLeaderboard + Godot](/icon.png)

#### **Add a leaderboard to your game in under 10 minutes!**

🏃 Ready to go game clients make adding a leaderboard quick and easy

🕵️ Extendable score validation system to protect against cheaters

👨‍💻 Open source and easily setup for custom implementations

💸 Optional free-hosting provided at [https://lb.userdefined.io](https://lb.userdefined.io) by [User Defined](https://userdefined.io)

## Table of Contents
- [:wrench: How to install](#wrench-how-to-install)
- [:package: What's included](#package-whats-included)
- [:computer: API Configuration](#computer-api-configuration)
- [:clipboard: Leaderboards Made With This](#clipboard-leaderboards-made-with-this)

## :wrench: How to install
1. Download the latest version from the [Releases page](https://github.com/adrenallen/EasyLeaderboard-Godot/releases)
2. Extract the contents of the zip
3. Copy the `/addons` folder into your Godot Project root
4. Open Godot
5. Go to Project Settings, then the Plugins tab
6. Check the enable box next to the EasyLeaderboard plugin

You should now see EasyLeaderboard as an optional node!

For the drop-in leaderboard, instantiate a child scene and select the scene found at `/addons/easyleaderboard/leaderboard/Leaderboard.tscn`

## :package: What's included

### Drop-in Ready Leadboard
![image](https://user-images.githubusercontent.com/9594539/189463097-842fa273-a9db-4c06-a724-e605da075ab6.png)

[Found under addons/easyleaderboard/leaderboard/Leaderboard.tscn](addons/easyleaderboard/leaderboard/Leaderboard.tscn)

Instantiate this scene in your game and set the game name for the quickest leaderboard setup!! (game jammers thats for you!)

This scene will automatically use an EasyLeaderboard API node underneath.

You can pass in a custom row scene for it to use if you want to further customize the rows with things such as metadata parsing for game stats.

There are a number of other configuration options you can play with such as showing different buttons and number of results per page.

Connect to the main menu and new game button signals to handle when those are pressed!

---
### Score Submission Modal
[Found under /addons/easyleaderboard/leaderboard/LeaderboardScoreSubmitPanel.tscn](addons/easyleaderboard/leaderboard/LeaderboardScoreSubmitPanel.tscn)

You can add this scene by using the instantiate child scene option, and selecting the scene.

An EasyLeaderboard API nodepath must be provided for the modal to use for submitting scores.

Other information can be passed to the scene to pre-populate fields such as score and enable things like a cancel button.

---
### EasyLeaderboard API node
[Found under addons/easyleaderboard/api/EasyLeaderboard.gd](addons/easyleaderboard/api/EasyLeaderboard.gd)

This scene can be used to directly interact with the Easy Leaderboard API.

Connect into the provided signals to handle when scores are submitted or results are retrieved.

## :computer: API Configuration
### Using the User Defined hosted solution
#### Default validation system
You can opt-in to the default validation logic by appending "basic-validation" to your game's key name.

For example, if your game's key name is `garretts-game`, the score will not be validated at all.

If you change the key to `garretts-game-basic-validation` then the score will undergo so generic validation to check for tampering!

If you want more robust validation, see below!

### [See how to self-host here (supports custom validation/anti-cheat!)](https://github.com/adrenallen/EasyLeaderboard)

## :clipboard: Leaderboards Made With This
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
