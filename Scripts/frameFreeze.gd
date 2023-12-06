extends Node

class_name frameFreeze

@export var timescale : int 
@export var duration : int

func frameFreeze(timeScale, duration):
	Engine.time_scale = timeScale
	await get_tree().create_timer(duration * timeScale).timeout
	Engine.time_scale = 1.0
