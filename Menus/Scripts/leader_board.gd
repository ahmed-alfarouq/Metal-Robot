extends Control

var scores = []
var ranking_scene = preload("res://menus/leaederboard/ranking.tscn")

@onready var list_container = %ListContainer
@onready var empty_message = %EmptyMessage
@onready var loading_icon = %LoadingIcon
@onready var my_ranking_btn = %MyRanking
@onready var top_10_btn = %Top10

func _ready():
	SilentWolf.Scores.sw_get_scores_complete.connect(_on_get_scores_complete)
	get_scores()
	
	# Enable my_ranking button if player's best_score > 0
	if Globals.best_score > 0:
		my_ranking_btn.disabled = false

func get_scores():
	SilentWolf.Scores.get_scores()

func add_list(scores_list):
	var pos = 1
	for score_data in scores_list:
		var ranking_instance = ranking_scene.instantiate()
		ranking_instance.player_name = score_data.player_name
		ranking_instance.player_score = score_data.score

		if score_data.has("position"):
			ranking_instance.player_pos = score_data.position
		else:
			ranking_instance.player_pos = pos
			pos += 1

		list_container.add_child(ranking_instance)

func clear_list():
	var list_children = list_container.get_children()

	for child in list_children:
		list_container.remove_child(child)

func _on_get_scores_complete(sw_result):
	scores = sw_result.scores

	if scores.size() > 0:
		add_list(scores)
		top_10_btn.disabled = false
	else:
		empty_message.visible = true

	loading_icon.visible = false

func _on_back_pressed():
	Globals.change_scene("res://menus/main_menu.tscn", "transition")

func _on_my_ranking_pressed():
	clear_list()
	my_ranking_btn.disabled = true
	loading_icon.visible = true
	# Get player score's position and 4 scores before and after player's best score
	var best_score_data = Globals.best_score_data
	var sw_scores_result = await SilentWolf.Scores.get_scores_around(best_score_data.score_id, 4).sw_get_scores_around_complete
	best_score_data["position"] = sw_scores_result.position
	var all_scores = sw_scores_result.scores_above + [best_score_data] + sw_scores_result.scores_below

	add_list(all_scores)

	# Enable btn and hide loading_icon
	my_ranking_btn.disabled = false
	loading_icon.visible = false

func _on_play_pressed():
	Globals.change_scene("res://levels/main_level.tscn", "loading_screen")
