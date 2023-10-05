extends Node2D

const SAVE_FILE_PATH = "user://bestscore.save"

@onready var main_score = $GameUI/Score
@onready var lose_menu = $loseMenu
@onready var lose_menu_score = $loseMenu/Score
@onready var lose_menu_best_score = $loseMenu/BestScore
@onready var is_dead: bool = false
@onready var is_shooting: bool = false
@onready var score: int = 0
@onready var best_score: int = 0



func _ready():
	load_best_score()

func _physics_process(_delta):
	if (!is_dead):
		main_score.text = str(score)

	if (is_dead && !lose_menu.visible):
		lose_menu.visible = true
		lose_menu_score.text = "Score: " + str(score)
		lose_menu_best_score.text = "Best Score: " + str(maxi(best_score, score))
		main_score.visible = false

func save_best_score(new_best_score: int):
	var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	save_file.store_64(new_best_score)

func load_best_score():
	if (FileAccess.file_exists(SAVE_FILE_PATH)):
		var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		best_score = save_file.get_64()

func _on_exit_pressed():
	get_tree().quit()


func _on_replay_pressed():
	get_tree().reload_current_scene() 


func _on_player_dies():
	save_best_score(maxi(best_score, score))
