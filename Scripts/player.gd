extends CharacterBody2D

class_name player

@export var health : PlayerHealth
@export var damage : playerDamage

var speed = 75
var input_vector: Vector2 = Vector2.ZERO
@onready var mouse_position = get_global_mouse_position()

#animation onready
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var animationState = animation_tree.get("parameters/playback")
var animation_player = null

#player health onready var
@onready var playerHealth = health.current_health
@onready var progressBar : ProgressBar = $ProgressBar

signal player_attack

func _ready():
	animation_tree.active = true
	animation_player = $AnimationPlayer
	animationState.travel("idle")
	health.reset()
	progressBar.max_value = health.max_health
	
func _process(delta):
	progressBar.value = health.current_health
	move_state(delta)
	mouse_rotate(delta)
	attack_animation(delta)
	
func mouse_rotate(delta):
	mouse_position = get_global_mouse_position() - position
	
	animation_tree.set("parameters/idle/blend_position", mouse_position)
	animation_tree.set("parameters/Walk/walk/blend_position", mouse_position)
	
func move_state(delta):
	var mouse_position = get_global_mouse_position() - position
	mouse_position.normalized()
	#These lines are for movement with key press (WASD)
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationState.travel("Walk")
		velocity = input_vector * speed * delta
	
	else:
		#IDLE ANIMATION
		velocity = Vector2.ZERO
		animationState.travel("idle")
	#ATTACK ANIMATION
	
	move_and_collide(velocity)

# call damage_taken function in playerHealth 
# when player takes damage from enemies 
func damage_taken():
	health.health_changed.emit()
	health.damage_taken(damage.damage)

func attack_animation(delta):
	if Input.is_action_just_pressed("attack"):
		animationState.travel("attack")
		player_attack.emit("player_attack")
		animation_tree.set("parameters/attack/attack/blend_position", mouse_position)
			
