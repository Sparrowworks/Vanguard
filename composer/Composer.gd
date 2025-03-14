extends Node

## A Scene Manager
##
## Composer aims to replace the current scene with a new scene, while granting
## the option to have a loading screen and the transfer of data between scenes.

## Emitted when Composer has been fully initialised, alongside with its timer.
signal finished_initialising()

## Emitted when provided scene has been invalid (may not exist or path is invalid).
signal invalid_scene(path: String)

## Emitted when ResourceLoader failed to load the scene.
signal failed_loading(path: String)

## Emitted every 0.1s during loading to provide progress for loading bars.
signal updated_loading(path: String, progress: int)

## Emitted when the scene has finished loading.
signal finished_loading(scene: Node)

## Use with loading screens, for scene activation (i.e making scene visible or activating certain game logic).
@warning_ignore("unused_signal")
signal loading_activated()

## Tracks if composer finished initializing; i.e when its ready to use.
var has_initialized: bool = false:
	set(val):
		has_initialized = val
		if has_initialized:
			finished_initialising.emit()

## Enables or disables the use of subthreads when loading scenes,
## refer to [method ResourceLoader.load_threaded_request] for detail.
var is_using_subthreads: bool = false
## Sets the cache mode of loaded scenes,
## refer to [method ResourceLoader.load_threaded_request] for detail.
var cache_mode: ResourceLoader.CacheMode = ResourceLoader.CACHE_MODE_REUSE

## Time value for the timer responsible for checking the status of loading. Default value is 0.1s.
## This should not be changed unless absolutely necessary.
var loading_timer_delay: float = 0.1:
	set(val):
		if !has_initialized: await finished_initialising

		loading_timer_delay = val
		_loading_timer.wait_time = loading_timer_delay

## Changes the default place where Composer adds scenes (default is get_tree().root).
var root: Node

var _is_loading: bool = false
var _has_loading_screen: bool = false

var _loading_timer: Timer = null
var _current_loading_path: String = ""
var _current_load_screen: Node = null
var _current_scene: Node = null

var _current_data: Dictionary = {}

func _enter_tree() -> void:
	invalid_scene.connect(_on_invalid_scene)
	failed_loading.connect(_on_failed_loading)
	finished_loading.connect(_on_finished_loading)

	root = get_tree().root
	_setup_timer()

## Replaces the current scene with a new scene using a path,
## can also be used for transferring data between scenes with the optional data_to_transfer
## parameter. Data will be stored as new scene metadata, named "transferred_data".
func load_scene(path_to_scene: String, data_to_transfer: Dictionary = {}) -> void:
	if _is_loading: return

	if !has_initialized: await finished_initialising

	var loader: Error = ResourceLoader.load_threaded_request(path_to_scene, "", is_using_subthreads, cache_mode)
	if not ResourceLoader.exists(path_to_scene) or loader == null:
		invalid_scene.emit(path_to_scene)
		return

	_is_loading = true

	if _loading_timer == null: _setup_timer()

	if _current_scene:
		_current_scene.queue_free()
		_current_scene = null

	_current_loading_path = path_to_scene
	_current_data = data_to_transfer
	_loading_timer.start()

## Creates a loading screen using a path and adds it to the SceneTree.
## Returns an instance of it for usage with signals.
func setup_load_screen(path_to_load_screen: String) -> Node:
	if _has_loading_screen: return

	_has_loading_screen = true
	_current_load_screen = load(path_to_load_screen).instantiate()

	root.call_deferred("add_child",_current_load_screen)
	root.call_deferred("move_child",_current_load_screen, get_child_count()-1)

	return _current_load_screen

## Gets rid of the loading screen.
func clear_load_screen() -> void:
	_current_load_screen.queue_free()
	_current_load_screen = null
	_has_loading_screen = false

func _check_loading_status() -> void:
	var load_progress: Array = []
	var load_status: ResourceLoader.ThreadLoadStatus = ResourceLoader.load_threaded_get_status(_current_loading_path, load_progress)

	match load_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			invalid_scene.emit(_current_loading_path)
			_loading_timer.stop()
			return
		ResourceLoader.THREAD_LOAD_FAILED:
			failed_loading.emit(_current_loading_path)
			_loading_timer.stop()
			return
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			updated_loading.emit(_current_loading_path, int(load_progress[0] * 100))
		ResourceLoader.THREAD_LOAD_LOADED:
			_loading_timer.stop()
			finished_loading.emit(ResourceLoader.load_threaded_get(_current_loading_path).instantiate())

func _setup_timer() -> void:
	_loading_timer = Timer.new()
	_loading_timer.name = "LoadingTimer"
	_loading_timer.wait_time = 0.1
	_loading_timer.timeout.connect(_check_loading_status)
	root.call_deferred("add_child",_loading_timer)

	await _loading_timer.ready

	has_initialized = true

func _on_finished_loading(scene: Node) -> void:
	scene.set_meta("transferred_data", _current_data)

	root.call_deferred("add_child", scene)
	_current_scene = scene

	_current_loading_path = ""
	_is_loading = false
	_current_data = {}

func _on_invalid_scene(path: String) -> void:
	printerr("Error: Invalid resource: " + path)

func _on_failed_loading(path: String) -> void:
	printerr("Error: Failed to load resource: " + path)
