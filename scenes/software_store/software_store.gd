extends Window


func _on_close_requested() -> void:
	var tween = create_tween()
	tween.tween_property(self, "size", Vector2i.ZERO, 0.1)
	await tween.finished
	self.queue_free()

func on_item_clicked(index: int, property: String, cost: int) -> void:
	print("index: ", index, " | property: ", property, " | cost: ", cost, " | is-activated: ", Global[property])
	
	if Global[property] == true:
		print("ALREADY BOUGHT!")
		return
		
	if Global.score >= cost:
		Global.score -= cost
		Global[property] = not Global[property]
	else:
		print("NOT ENOUGH SCORE!")
