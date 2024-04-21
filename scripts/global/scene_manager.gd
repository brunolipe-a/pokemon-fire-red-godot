extends Node

signal load_complete(loaded_scene: Node)

var _loading_screen_scene: PackedScene = preload("res://scenes/loading_screen.tscn")
var _loading_screen: LoadingScreen
var _transition: String
var _content_path: String
var _load_progress_timer: Timer
var _load_scene_into: Node
var _scene_to_unload: Node
var _loading_in_progress: bool = false

var _new_level_data: Level.LevelData

func swap_scenes(scene_to_load: String, load_into: Node = null, scene_to_unload: Node = null, transition_type: String = "fade_to_black") -> void:
	if _loading_in_progress:
		return push_warning("SceneManager is already loading something")

	_loading_in_progress = true

	if load_into == null: load_into = get_tree().root

	_load_scene_into = load_into
	_scene_to_unload = scene_to_unload

	await _add_loading_screen(transition_type)
	_load_content(scene_to_load)

func swap_levels(level_to_load: String, level_data: Level.LevelData) -> void:
	if _loading_in_progress:
		return push_warning("SceneManager is already loading something")

	_loading_in_progress = true

	var gameplay_node := get_tree().get_nodes_in_group("gameplay")[0] as Gameplay
	var unload := gameplay_node.current_level

	_new_level_data = level_data
	_load_scene_into = gameplay_node.level_holder
	_scene_to_unload = unload

	await _add_loading_screen()
	_load_content(level_to_load)

func _add_loading_screen(transition_type: String = "fade_to_black"):
	_transition = "no_to_transition" if transition_type == "no_transition" else transition_type

	_loading_screen = _loading_screen_scene.instantiate() as LoadingScreen

	get_tree().root.add_child(_loading_screen)

	await _loading_screen.start_transition(_transition)

func _load_content(content_path: String) -> void:
	_content_path = content_path

	var loader = ResourceLoader.load_threaded_request(content_path)

	if not ResourceLoader.exists(content_path) or loader == null: return

	_load_progress_timer = Timer.new()
	_load_progress_timer.wait_time = 0.1
	_load_progress_timer.timeout.connect(_monitor_load_status)

	get_tree().root.add_child(_load_progress_timer)		# NEW > insert loading bar into?
	_load_progress_timer.start()

func _monitor_load_status() -> void:
	var load_status = ResourceLoader.load_threaded_get_status(_content_path)

	if load_status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		return

	if load_status == ResourceLoader.THREAD_LOAD_LOADED:
		_load_progress_timer.queue_free()
		await _add_new_scene(ResourceLoader.load_threaded_get(_content_path).instantiate())
		return

	_load_progress_timer.stop()

	match load_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			push_warning("SceneManager: ResourceLoader.THREAD_LOAD_INVALID_RESOURCE")
		ResourceLoader.THREAD_LOAD_FAILED:
			push_warning("SceneManager: ResourceLoader.THREAD_LOAD_FAILED")

func _add_new_scene(new_scene: Node) -> void:
	if new_scene is Level and _new_level_data:
		new_scene.receive_data(_new_level_data)

	_load_scene_into.add_child(new_scene)

	if _scene_to_unload and _scene_to_unload != get_tree().root:
		_scene_to_unload.queue_free()

	await _loading_screen.finish_transition()

	_loading_in_progress = false

	load_complete.emit(new_scene)
