extends Control

@onready var canvas = $CanvasLayer
@onready var error_label = $CanvasLayer/PanelContainer/Error

func error(message: String):
	canvas.visible = true
	error_label.text = "Something went wrong please send us the next line: \n" + message
