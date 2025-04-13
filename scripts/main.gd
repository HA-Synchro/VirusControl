extends Control

@export var error_window_scene: PackedScene
@export var file_explorer_scene: PackedScene
@export var software_store_scene: PackedScene

@export var autoclose_activated: bool = false

@onready var spawn_area: ReferenceRect = $SpawnArea
@onready var virus_popups: Control = $VirusPopups
@onready var autoclose_delay: Timer = $AutocloseDelay

func create_new_window() -> void:
	var error_window_instance: Window = error_window_scene.instantiate()
	error_window_instance.size = Vector2.ZERO
	var random_position_x = randf_range(spawn_area.pivot_offset.x, spawn_area.size.x)
	var random_position_y = randf_range(spawn_area.pivot_offset.y, spawn_area.size.y)
	var tween = create_tween()
	tween.tween_property(error_window_instance, "size", Vector2i(400, 150), 0.1)
	error_window_instance.position = Vector2(random_position_x, random_position_y)
	virus_popups.add_child(error_window_instance)

func remove_popups_automatically() -> void:
	if virus_popups.get_child_count() > 0:
		for popup in virus_popups.get_children():
			popup.queue_free()
	await get_tree().create_timer(0.5).timeout

func _on_window_spawn_delay_timeout() -> void:
	create_new_window()

func _on_file_explorer_pressed() -> void:
	var file_explorer_instance: Window = file_explorer_scene.instantiate()
	file_explorer_instance.size = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(file_explorer_instance, "size", Vector2i(885, 425), 0.1)
	add_child(file_explorer_instance)

func _on_software_store_pressed() -> void:
	var software_store_instance: Window = software_store_scene.instantiate()
	software_store_instance.size = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(software_store_instance, "size", Vector2i(885, 425), 0.1)
	add_child(software_store_instance)

func _on_autoclose_delay_timeout() -> void:
	if autoclose_activated:
		if virus_popups.get_child_count() > 0:
			virus_popups.get_child(0).close_window()
