extends Area2D

class_name hitBox

@export var damage : int

func _init():
	collision_layer = 2
	collision_mask = 0 
