class_name Door extends Area2D

signal player_entered_door(door: Door)

@export_enum("up", "right", "down", "left") var entry_direction
@export_enum("fade_to_black") var transition_type: String = "fade_to_black"

@export_file("*.tscn") var path_new_scene: String

@export var entry_door_name: String

@export var player_speed := 4
@export var moving_direction: Vector2

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return

	player_entered_door.emit(self)

	var level_data = Level.LevelData.new()
	level_data.entry_door_name = entry_door_name

	SceneManager.swap_levels(path_new_scene, level_data)

func get_player_entry_vector() -> Vector2:
	var vector: Vector2

	match entry_direction:
		0: vector = Vector2.UP
		1: vector = Vector2.RIGHT
		2: vector = Vector2.DOWN
		3: vector = Vector2.LEFT

	var new_position  = (vector * 16) + self.position
	new_position.y -= 8 # Diferenças entre o centro do Player e Door

	return new_position

func get_player_entry_direction() -> Vector2:
	var direction: Vector2

	match entry_direction:
		0: direction = Vector2.UP
		1: direction = Vector2.RIGHT
		2: direction = Vector2.DOWN
		3: direction = Vector2.LEFT

	return direction
