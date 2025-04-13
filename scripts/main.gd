extends Control

@export var error_window_scene: PackedScene
@export var file_explorer_scene: PackedScene

@onready var spawn_area: ReferenceRect = $SpawnArea

func create_new_window() -> void:
	var error_window_instance: Window = error_window_scene.instantiate()
	error_window_instance.size = Vector2.ZERO
	var random_position_x = randf_range(spawn_area.pivot_offset.x, spawn_area.size.x)
	var random_position_y = randf_range(spawn_area.pivot_offset.y, spawn_area.size.y)
	var tween = create_tween()
	tween.tween_property(error_window_instance, "size", Vector2i(400, 150), 0.1)
	error_window_instance.position = Vector2(random_position_x, random_position_y)
	add_child(error_window_instance)

func _on_window_spawn_delay_timeout() -> void:
	create_new_window()

func _on_file_explorer_pressed() -> void:
	var file_explorer_instance: Window = file_explorer_scene.instantiate()
	file_explorer_instance.size = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(file_explorer_instance, "size", Vector2i(885, 425), 0.1)
	add_child(file_explorer_instance)
