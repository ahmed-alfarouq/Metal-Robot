extends Control

var scores = []
var ranking_scene = preload("res://menus/leaederboard/ranking.tscn")

@onready var list_container = %ListContainer
@onready var empty_message = %EmptyMessage

func _ready():
	SilentWolf.Scores.sw_get_scores_complete.connect(_on_get_scores_complete)
	get_scores()

func get_scores():
	SilentWolf.Scores.get_scores()

func add_list(scores_list):
	for score in scores_list:
		var ranking_instance = ranking_scene.instantiate()
		list_container.add_child(ranking_instance)

func _on_get_scores_complete(sw_result):
	scores = sw_result.scores
	if scores.size() > 0:
		add_list(scores)
	else:
		empty_message.visible = true

func _on_back_pressed():
	Globals.change_scene("res://menus/main_menu.tscn", "transition")
