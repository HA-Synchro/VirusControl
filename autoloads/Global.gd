extends Node

var score: int = 100

var antivirus_activated: bool = false
var autoclose_ability_activated: bool = false

func increase_score(amount: int) -> void:
	score += amount
