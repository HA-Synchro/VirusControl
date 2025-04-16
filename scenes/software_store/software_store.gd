extends Window

@export var upgrades: Array[UpgradeItem]

func buy_upgrade():
	for upgrade in upgrades:
		if Global.score >= upgrade.item_cost:
			Global.score -= upgrade.item_cost
			Global[upgrade.item_property] = true
			upgrade.item_cost += upgrade.item_cost_increase_rate
		else:
			print_rich("[color=tomato]Not Enough Points![/color]")

# SIGNAL CALLBACKS

func _on_close_requested() -> void:
	var tween = create_tween()
	tween.tween_property(self, "size", Vector2i.ZERO, 0.1)
	await tween.finished
	self.queue_free()

func on_item_clicked(index: int) -> void:
	buy_upgrade()
