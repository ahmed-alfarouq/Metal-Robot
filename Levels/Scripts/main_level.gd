extends Node2D

const SAVE_FILE_PATH = "user://bestscore.save"

@onready var current_score = $Score/Score
@onready var lose_menu = $loseMenu
@onready var lose_menu_score = $loseMenu/Score
@onready var lose_menu_best_score = $loseMenu/BestScore
@onready var is_dead: bool = false
@onready var is_shooting: bool = false
@onready var score: int = 0
@onready var best_score: int = 0



func _ready():
	loadBestScore()

func _physics_process(_delta):
	if (!is_dead):
		current_score.text = str(score)
		
	
	if (is_dead && !lose_menu.visible):
		lose_menu.visible = true
		lose_menu_score.text = "Score: " + str(score)
		lose_menu_best_score.text = "Best Score: " + str(max(best_score, score))
		current_score.visible = false

func saveBestScore(newBestScore: int):
	var saveFile = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	saveFile.store_64(newBestScore)

func loadBestScore():
	if (FileAccess.file_exists(SAVE_FILE_PATH)):
		var saveFile = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		best_score = saveFile.get_64()

func _on_exit_pressed():
	get_tree().quit()


func _on_replay_pressed():
	get_tree().reload_current_scene()


func _on_player_dies():
	saveBestScore(max(best_score, score))
