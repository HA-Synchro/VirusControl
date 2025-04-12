extends Window

@export var error_messages: Array[String]
@onready var label: Label = $PanelContainer/CenterContainer/Label

func _ready() -> void:
	label.text = error_messages.pick_random()

func _on_close_requested() -> void:
	self.queue_free()
