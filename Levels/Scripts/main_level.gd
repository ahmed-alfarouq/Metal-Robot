extends Node2D

const SAVE_FILE_PATH = "user://bestscore.save"
@onready var isDead: bool = false
@onready var isShooting: bool = false
@onready var score: float = 0
@onready var bestScore: float = 0



func _ready():
	loadBestScore()

func _physics_process(_delta):
	if (!isDead):
		$Score/Score.text = str(score)
	
	if (isDead && !$loseMenu.visible):
		$loseMenu/Score.text = "Score: " + str(score)
		$loseMenu/BestScore.text = "Best Score: " + str(max(bestScore, score))
		$loseMenu.visible = true
		$Score.visible = false

func saveBestScore():
	var saveFile = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	var newBestScore = maxf(bestScore, score)
	saveFile.store_32(newBestScore)

func loadBestScore():
	if (FileAccess.file_exists(SAVE_FILE_PATH)):
		var saveFile = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		bestScore = saveFile.get_32()

func _on_exit_pressed():
	get_tree().quit()


func _on_replay_pressed():
	get_tree().reload_current_scene()


func _on_player_player_dies():
	$Score.visible = false
	saveBestScore()
