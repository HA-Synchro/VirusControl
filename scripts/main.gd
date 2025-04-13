extends Control

@export var error_window_scene: PackedScene
@onready var spawn_area: ReferenceRect = $SpawnArea

func create_new_window() -> void:
	var error_window_instance = error_window_scene.instantiate()
	var random_position_x = randf_range(spawn_area.pivot_offset.x, spawn_area.size.x)
	var random_position_y = randf_range(spawn_area.pivot_offset.y, spawn_area.size.y)
	error_window_instance.position = Vector2(random_position_x, random_position_y)
	add_child(error_window_instance)

func _on_window_spawn_delay_timeout() -> void:
	create_new_window()
