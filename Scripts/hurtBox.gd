extends Area2D

class_name hurtBox


func _init():
	collision_layer = 0 
	collision_mask = 2

func _ready():
	connect("area_entered", self._on_area_entered)

func _on_area_entered(hitBox : hitBox) -> void:
	if hitBox == null: 
		return
	
	if owner.has_method("take_damage"):
		owner.take_damage(hitBox.damage)
		
