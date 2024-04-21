class_name Gameplay extends Node2D

@onready var level_holder: Node2D = $LevelHolder

var current_level: Level

func _ready() -> void:
	SceneManager.load_complete.connect(_on_level_loaded)

	current_level = level_holder.get_child(0) as Level

func _on_level_loaded(level) -> void:
	if level is Level:
		current_level = level

