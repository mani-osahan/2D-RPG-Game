extends Resource

class_name playerDamage

@export var damage : int 

signal damage_taken 

func playerDamage(damage):
	emit_signal("attack_enemy", damage)
	damage = min(0,damage)

func playerKnockback():
	pass

	
