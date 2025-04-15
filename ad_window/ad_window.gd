extends Window
class_name AdWindows

@export var ad_array : Array[AdResource]
var ad_res : AdResource

@onready var label: Label = $PanelContainer/CenterContainer/Label
@onready var texture_rect : TextureRect = $PanelContainer/TextureRect

func _ready() -> void:
	_on_create()

func _on_create() -> void:
	ad_res = ad_array.pick_random()
	texture_rect.texture = ad_res.img
	label.text = ad_res.label_text
	

func _on_get_button_pressed() -> void:
	OS.shell_open(ad_res.url)
