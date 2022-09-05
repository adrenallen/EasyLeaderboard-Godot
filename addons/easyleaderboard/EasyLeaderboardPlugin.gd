tool
extends EditorPlugin

func _enter_tree():
	# Initialization of the plugin goes here.
	add_custom_type("EasyLeaderboardAPI", "Node", preload("api/EasyLeaderboard.tscn"), preload("icon.png"))
    add_custom_type("EasyLeaderboard", "Control", preload("leaderboard/Leaderboard.tscn"), preload("icon.png"))

func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_custom_type("EasyLeaderboardAPI")
    remove_custom_type("EasyLeaderboard")