class_name Level extends Node2D

class LevelData:
	var entry_door_name: String

@export var player: Player
@export var doors: Array[Door]

var data: LevelData

func _ready() -> void:
	SceneManager.load_complete.connect(_on_load_level_complete)

	player.disable()
	player.visible = false

	init_player_location()

	if not SceneManager._loading_in_progress:
		player.enable()

func get_data() -> LevelData:
	return data

func receive_data(_data: LevelData):
	data = _data

func init_player_location() -> void:
	player.visible = true

	if not data: return

	for door in doors:
		if door.name != data.entry_door_name: continue

		player.position = door.get_player_entry_vector()
		player.direction = door.get_player_entry_direction()

func _on_load_level_complete(new_level: Node):
	if new_level.name == name:
		player.enable()
