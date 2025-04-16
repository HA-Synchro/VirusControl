extends Window

@export var filesystem: FileSystem
@export var grid_container: GridContainer
@export var path_label: Label
var selected_file : String


func _ready() -> void:
	update_ui()

func update_ui():
	var folder = filesystem.get_current_folder()
	clear_children(grid_container)
	
	path_label.text = "/" + "/".join(filesystem.current_path)
	
	for _name in folder.keys():
		var is_folder = typeof(folder[_name]) == TYPE_DICTIONARY
		var button = Button.new()
		button.custom_minimum_size = Vector2(64, 64)
		button.text = _name + ("/" if is_folder else "")
		button.pressed.connect(_on_item_selected.bind(_name))
		grid_container.add_child(button)

func clear_children(object):
	for child in object.get_children():
		child.queue_free()

func _on_close_requested() -> void:
	var tween = create_tween()
	tween.tween_property(self, "size", Vector2i.ZERO, 0.1)
	await tween.finished
	self.queue_free()

func _on_home_pressed() -> void:
	pass

func _on_item_selected(_name) -> void:
	var folder = filesystem.get_current_folder()
	if typeof(folder[_name]) == TYPE_DICTIONARY:
		filesystem.current_path.append(_name)
		update_ui()
	else:
		selected_file = _name
		print("Selected file:", _name)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("delete_file"):
		filesystem.delete_file(selected_file, self)


func _on_back_button_pressed() -> void:
	filesystem.go_back(self)


func _on_delete_button_pressed() -> void:
	filesystem.delete_file(selected_file, self)
