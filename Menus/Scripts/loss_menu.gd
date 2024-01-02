extends Control

@onready var score = %Score
@onready var best_score = %BestScore

func _ready():
	score.text = str(Globals.score)
	best_score.text = str(Globals.best_score)

func _on_menu_pressed():
	Globals.change_scene("res://menus/main_menu.tscn", "transition")

func _on_leaderboard_pressed():
	Globals.change_scene("res://menus/leader_board.tscn", "transition")

func _on_replay_pressed():
	Globals.change_scene("res://levels/main_level.tscn", "loading_screen")
