extends Node

var loading_screen = preload("res://loading_screen/loading_screen.tscn")
var screaming_times = 3

# Regex
@onready var email_regex = RegEx.new()

# Pepsi Man
func _ready():
	email_regex.compile("(^[a-zA-Z0-9_.+-]+[a-zA-Z0-9]+@[a-zA-Z0-9]+\\.[a-zA-Z]+$)")

	# If user is signed in load the data
	Firebase.Auth.check_auth_file()

func change_scene(current_scene, next_scene_path):
	var scene_load_status
	var progress: Array = []
	var scene_instance
	var loading_screen_instance = loading_screen.instantiate()

	# Add the loading screen then delete the current scene
	get_tree().root.call_deferred("add_child", loading_screen_instance)
	await loading_screen_instance.safe_to_load
	current_scene.queue_free()

	# If scene exists make a request
	if (ResourceLoader.exists(next_scene_path)):
		ResourceLoader.load_threaded_request(next_scene_path)
	# A loop until the request finishes
	while ResourceLoader.exists(next_scene_path):
		scene_load_status = ResourceLoader.load_threaded_get_status(next_scene_path, progress)
		match scene_load_status:
			0:
				ErrorHandler.error("The resource is invalid.")
				return
			2:
				ErrorHandler.error("Some error occurred during loading and it failed.")
				return
			3:
				scene_instance = ResourceLoader.load_threaded_get(next_scene_path).instantiate()
				var add_next_scene = func(): get_tree().root.call_deferred("add_child", scene_instance)
				loading_screen_instance.go_to_next_scene(add_next_scene)
				return
