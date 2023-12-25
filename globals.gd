extends Node

var loading_screen_scene: PackedScene = preload("res://loading_screen/loading_screen.tscn")
var transition_screen_scene: PackedScene = preload("res://scene_transition/scene_transition.tscn")
var screaming_times: int = 3
var current_weapon: String = "pistol"

# Regex
@onready var email_regex: RegEx = RegEx.new()


func _ready():
	email_regex.compile("(^[a-zA-Z0-9_.+-]+[a-zA-Z0-9]+@[a-zA-Z0-9]+\\.[a-zA-Z]+$)")

	# If user is signed in load the data
	Firebase.Auth.check_auth_file()

func change_scene(next_scene_path: String, type: String):
	var scene_load_status
	var loading_screen_instance

	if ( type == "loading_screen" ):
		loading_screen_instance = loading_screen_scene.instantiate()
	else:
		loading_screen_instance = transition_screen_scene.instantiate()

	# Add the loading screen
	get_tree().root.call_deferred("add_child", loading_screen_instance)
	await loading_screen_instance.safe_to_load

	# If scene exists make a request
	if (ResourceLoader.exists(next_scene_path)):
		ResourceLoader.load_threaded_request(next_scene_path)
	else:
		ErrorHandler.error("The resource is invalid.")
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
