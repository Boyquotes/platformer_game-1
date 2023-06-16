extends CanvasLayer

signal level_request(path)

@onready var text_field = find_child("LevelNameField")

func _ready():
	enable()

func disable():
	hide()

func enable():
	show()
	text_field.grab_focus()

func _on_load_level_button_pressed():
	submit(text_field.text)

func submit(path):
	emit_signal("level_request", text_field.text)
