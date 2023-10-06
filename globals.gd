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
	var next_scene
	var scene_load_status
	var progress: Array = []
	var loading_screen_instance = loading_screen.instantiate()
	var loading_bar = loading_screen_instance.get_node("CanvasLayer/Loader")

	# Add the loading screen then delete the current scene
	get_tree().root.call_deferred("add_child", loading_screen_instance)
	await loading_screen_instance.safe_to_load
	current_scene.queue_free()

	# If scene exists make a request
	if (ResourceLoader.exists(next_scene_path)):
		next_scene = ResourceLoader.load_threaded_request(next_scene_path)
	
	# A loop until the request finishes
	while true:
		scene_load_status = ResourceLoader.load_threaded_get_status(next_scene_path, progress)
		match scene_load_status:
			0:
				print("Error: can't load the resource")
				return
			1:
				loading_bar.value = floor(progress[0] * 100)
			2:
				print("Error: Loading failed")
				return
			3:
				next_scene = ResourceLoader.load_threaded_get(next_scene_path).instantiate()
				get_tree().root.call_deferred("add_child", next_scene)
				loading_screen_instance.fade_out()
				return
