extends Resource

class_name enemyHealth

@export var max_health : int
@export var health_debuff : int
@export var current_health : int

signal health_changed
signal health_zero

	
func reset():
	current_health = max_health
	
func damage_taken(amount : int):
	current_health = max(0, current_health - amount)
	emit_signal("health_changed", amount)


