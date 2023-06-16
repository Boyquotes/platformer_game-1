extends Node2D

const OBJECT_DIR = "res://level_objects/"

@onready var objects := Dictionary()
var start_pos = Vector2.ZERO

func _ready():
	for dir_name in DirAccess.get_directories_at(OBJECT_DIR):
		print(dir_name)
		var object_name = dir_name
		objects[object_name] = load(OBJECT_DIR + dir_name + "/" + dir_name + ".tscn")
	print(objects)

func load_level(path):
	print("loading level: " + path)
	if FileAccess.file_exists(path):
		var file_handle = FileAccess.open(path, FileAccess.READ)
		var level = JSON.parse_string(file_handle.get_as_text())
		start_pos = Vector2(level["start_x"], level["start_y"])
		var root_level = Node2D.new()
		root_level.name = "level"
		for item in level["objects"]:
			var obj_type = item["type"]
			if obj_type not in objects:
				printerr("Object type does not exist! (" + obj_type + ")")
				continue
			var obj = objects[obj_type].instantiate()
			obj.position.x = item["pos_x"]
			obj.position.y = item["pos_y"]
			root_level.add_child(obj)
		add_child(root_level)
	else:
		printerr("Level does not exist!")

func unload_level():
	var level = get_node_or_null("level")
	if level != null:
		level.queue_free()
	else:
		printerr("Tried to unload level when no level was loaded")

func extract_file_name(path):
	var parts : Array = path.split("/")
	var file_name = parts.back()
	var extension = file_name.get_extension()
	return file_name.left(len(file_name) - len(extension) - 1)

func serialize(root_level):
	var level = Dictionary()
	level["objects"] = []
	for object in root_level.get_children():
		var obj = Dictionary()
		obj["type"] = extract_file_name(object.scene_file_path)
		obj["pos_x"] = object.position.x
		obj["pos_y"] = object.position.y
		level["objects"].append(obj)
	return JSON.stringify(level)

func save_level(path):
	var root_level = get_node_or_null("level")
	if root_level == null:
		printerr("No level exists")
		return
	var s = serialize(root_level)
	print(s)
	var f = FileAccess.open(path, FileAccess.WRITE)
	f.store_line(s)

#func place_object(pos: Vector2):
#	var root_level = get_node_or_null("level")
#	if root_level == null:
#		printerr("No level exists")
#		return
#	var obj = object.instantiate()
#	obj.position = pos
#	root_level.add_child(obj)
#	print("object placed!")
