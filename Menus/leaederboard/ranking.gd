extends Control

var move_left: bool = false
var player_name: String
var player_score: int
var player_pos: int

@onready var player_name_label = %PlayerName
@onready var player_score_label = %PlayerScore

func _ready():
	if move_left:
		position.x -= 150
	player_name_label.text = str(player_pos) + ") " + player_name
	player_score_label.text = str(player_score)
