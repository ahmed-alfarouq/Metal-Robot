extends Node2D

const SAVE_FILE_PATH = "user://bestscore.save"
@onready var is_dead: bool = false
@onready var is_shooting: bool = false
@onready var score: float = 0
@onready var best_score: float = 0



func _ready():
	loadBestScore()

func _physics_process(_delta):
	if (!is_dead):
		$Score/Score.text = str(score)
	
	if (is_dead && !$loseMenu.visible):
		$loseMenu/Score.text = "Score: " + str(score)
		$loseMenu/BestScore.text = "Best Score: " + str(max(best_score, score))
		$loseMenu.visible = true
		$Score.visible = false

func saveBestScore():
	var saveFile = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	var newBestScore = maxf(best_score, score)
	saveFile.store_32(newBestScore)

func loadBestScore():
	if (FileAccess.file_exists(SAVE_FILE_PATH)):
		var saveFile = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		best_score = saveFile.get_32()

func _on_exit_pressed():
	get_tree().quit()


func _on_replay_pressed():
	get_tree().reload_current_scene()


func _on_player_player_dies():
	$Score.visible = false
	saveBestScore()
