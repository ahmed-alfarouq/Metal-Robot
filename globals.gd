extends Node

const PAUSE_MENU: PackedScene = preload("res://menus/pause_menu.tscn")

var loading_screen_scene: PackedScene = preload("res://loading_screen/loading_screen.tscn")
var transition_screen_scene: PackedScene = preload("res://scene_transition/scene_transition.tscn")
var screaming_times: int = 3
var current_weapon_name: String = "pistol"
var current_weapon_data: Dictionary
var weapon_sprites: SpriteFrames
var player_weapon_sprites: SpriteFrames
var score: int = 0
var best_score: int = 0
var best_score_data: Dictionary
var player_name = null

func _ready():
	silentwolf_config()
	# Weapon data
	get_current_weapon_data()

func silentwolf_config():
	SilentWolf.configure({
		"api_key": "X367RUXQW031HNj8bQP82anPrCAj7CNN6ixrauQk",
		"game_id": "metalrobot",
		"log_level": 0
	})
	SilentWolf.configure_scores({
		"open_scene_on_close": "res://menus/main_menu.tscn"
	 })
	SilentWolf.configure_auth({
		"redirect_to_scene": "res://menus/main_menu.tscn",
		"login_scene": "res://auth/log_in/log_in.tscn",
		"email_confirmation_scene": "res://auth/email_verification/email_verification.tscn",
		"reset_password_scene": "res://auth/reset_password/reset_password.tscn",
		"session_duration_seconds": 0,
		"saved_session_expiration_days": 60
	})

func get_current_weapon_data():
	var weapons_data: Dictionary = load_json("res://weapons.json")

	if weapons_data.has(current_weapon_name):
		current_weapon_data = weapons_data[current_weapon_name]
		weapon_sprites = load(current_weapon_data["weapon_sprites_resource"])
		player_weapon_sprites = load(current_weapon_data["player_weapon_sprites_resource"])

func load_json(file_path: String):
	if FileAccess.file_exists(file_path):
		var data_file = FileAccess.open(file_path, FileAccess.READ)
		var parsed_data = JSON.parse_string(data_file.get_as_text())
		
		if parsed_data is Dictionary:
			return parsed_data
		else:
			ErrorHandler.error("Some thing went wrong, when trying to get JSON file")
			return {}
	else:
		ErrorHandler.error("JSON file doesn't exist")
		return {}

func change_scene(next_scene_path: String, type: String):
	var scene_load_status
	var loading_screen_instance

	if type == "loading_screen":
		loading_screen_instance = loading_screen_scene.instantiate()
	else:
		loading_screen_instance = transition_screen_scene.instantiate()

	# Add the loading screen
	get_tree().root.call_deferred("add_child", loading_screen_instance)
	await loading_screen_instance.safe_to_load

	# If scene exists make a request
	if ResourceLoader.exists(next_scene_path):
		ResourceLoader.load_threaded_request(next_scene_path)
	else:
		ErrorHandler.error("The resource is invalid.")
		loading_screen_instance.queue_free()
		return

	# A loop until the request finishes
	while ResourceLoader.exists(next_scene_path):
		scene_load_status = ResourceLoader.load_threaded_get_status(next_scene_path, [])
		match scene_load_status:
			0:
				ErrorHandler.error("The resource is invalid.")
				return
			2:
				ErrorHandler.error("Some error occurred during loading and it failed.")
				return
			3:
				var packed_scene = ResourceLoader.load_threaded_get(next_scene_path)
				var add_next_scene = func(): get_tree().change_scene_to_packed(packed_scene)
				# Change scene and wait till it's safe to delete the loading scene
				loading_screen_instance.go_to_next_scene(add_next_scene)
				await loading_screen_instance.safe_to_load
				# Delete loading scene
				loading_screen_instance.queue_free()
				return

func save_score(new_score):
	if player_name:
		SilentWolf.Scores.save_score(player_name, new_score)
		best_score = new_score

func load_best_score():
	if player_name:
		var sw_result = await SilentWolf.Scores.get_top_score_by_player(player_name).sw_top_player_score_complete
		if !sw_result.top_score.is_empty():
			best_score_data = sw_result.top_score
			best_score = best_score_data.score

func valid_player_name(n):
	if n.find(" ") == 1 || n.begins_with(" ") || n.ends_with(" "):
		return false
	return true

func pause_game():
	var tree = get_tree()
	var pause_menu = PAUSE_MENU.instantiate()
	tree.paused = true
	tree.get_root().add_child(pause_menu)
