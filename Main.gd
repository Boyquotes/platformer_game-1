extends Node

@onready var main_menu := $MainMenu
@onready var environment := $Environment
var is_in_level = false

func _on_main_menu_level_request(path):
	print("level requested: " + path)
	if FileAccess.file_exists(path):
		main_menu.disable()
		environment.begin_level(path)
		is_in_level = true
	else:
		printerr("tried to load nonexistent level")

func _unhandled_input(event):
	if event.is_action_pressed("pause") and is_in_level:
		main_menu.enable()
		environment.unload()
		is_in_level = false
