extends Resource

class_name PlayerHealth

@export var max_health : int
@export var health_debuff : int
@export var current_health : int

signal health_changed
signal health_zero
	
func reset():
	current_health = max_health

func heal(amount):
	current_health = min(max_health, current_health + amount)
	emit_signal("health_changed", amount)

#when player takes damage from enemy
func damage_taken(amount : int):
	emit_signal("health_changed", amount)
	current_health = max(0, current_health - amount)



