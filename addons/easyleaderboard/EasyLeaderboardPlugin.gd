@tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("EasyLeaderboardAPI", "Node", preload("res://addons/easyleaderboard/api/EasyLeaderboard.gd"), preload("icon.png"))

func _exit_tree():
	remove_custom_type("EasyLeaderboardAPI")
