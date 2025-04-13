extends Window

@export var error_messages: Array[String]
@onready var label: Label = $PanelContainer/CenterContainer/Label

func _ready() -> void:
	label.text = error_messages.pick_random()

func close_window() -> void:
	var tween = create_tween()
	tween.tween_property(self, "size", Vector2i.ZERO, 0.1)
	await tween.finished
	self.queue_free()

func _on_close_requested() -> void:
	close_window()
