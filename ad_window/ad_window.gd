extends Window
class_name AdWindows

@export var ad_array : Array[AdResource]
var ad_res : AdResource
var desktop_env : DesktopEnvironment 
@onready var label: Label = $PanelContainer/CenterContainer/Label
@onready var texture_rect : TextureRect = $PanelContainer/TextureRect

func _ready() -> void:
	ad_res = ad_array.pick_random()
	texture_rect.texture = ad_res.img
	label.text = ad_res.label_text

func _on_get_button_pressed() -> void:
	OS.shell_open(ad_res.url)

func close_window() -> void:
	Global.increase_score(5)
	var tween = create_tween()
	tween.tween_property(self, "size", Vector2i.ZERO, 0.1)
	await tween.finished
	self.queue_free()

func _on_close_requested() -> void:
	close_window()
