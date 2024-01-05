extends Control

@onready var score = %Score
@onready var best_score = %BestScore

func _ready():
	score.text = str(Globals.score)
	print(Globals.best_score)
	if Globals.score > Globals.best_score:
		best_score.text = str(Globals.score)
	else:
		best_score.text = str(Globals.best_score)

func _on_menu_pressed():
	Globals.change_scene("res://menus/main_menu.tscn", "transition")

func _on_leaderboard_pressed():
	Globals.change_scene("res://menus/leaderboard.tscn", "transition")

func _on_replay_pressed():
	Globals.change_scene("res://levels/main_level.tscn", "loading_screen")
