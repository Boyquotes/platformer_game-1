extends Node2D

@onready var player := $Player
@onready var level_loader := $LevelLoader

func unload():
	level_loader.unload_level()
	player.disable()
	hide()

func _ready():
	#begin_level("res://asdasd.json")
	pass

func begin_level(path):
	level_loader.load_level(path)
	show()
	player.position = level_loader.start_pos
	player.enable()
