extends CharacterBody2D

class_name player

@export var health : PlayerHealth
@export var damage : playerDamage


#frame freeze variables and script call
@export_category("Frame Freeze")
@export var frame_freeze : frameFreeze
@export var ff_timescale : float = 0.0
@export var ff_duration : float = 0.0

#knockback power variable for on hit  
@export_category("Knockback")
@export var kb_power : int = 500

#character speed and input vector - DEFAULT TO VECTOR ZERO
var speed = 75
var input_vector: Vector2 = Vector2.ZERO

#get the global mouse position of windows mouse
@onready var mouse_position = get_global_mouse_position()

#animation onready
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var animationState = animation_tree.get("parameters/playback")
var animation_player = null

#player health onready var
@onready var playerHealth = health.current_health
@onready var progressBar : ProgressBar = $ProgressBar

signal player_attack
var attack_arr = 0

enum {
	IDLE,
	MOVE,
	ATTACK
}

var player_state = MOVE

func _ready():
	#animation ready
	animation_tree.active = true
	animation_player = $AnimationPlayer
	animationState.travel("idle")
	
	#health ready
	health.reset()
	progressBar.max_value = health.max_health
	
	
func _process(delta):
	progressBar.value = health.current_health
	match player_state:
		IDLE: 
			mouse_rotate(delta)
		MOVE:
			move_state(delta)
		ATTACK:
			attack_animation(delta, attack_arr)
	mouse_rotate(delta)

func _physics_process(delta):
	mouse_position = get_global_mouse_position() - position

func mouse_rotate(delta):
	animation_tree.set("parameters/idle/blend_position", mouse_position)
	animation_tree.set("parameters/Walk/walk/blend_position", mouse_position)
	
func move_state(delta):
	player_state = MOVE
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
	

	move_and_collide(velocity)
	
	#ATTACK ANIMATION
	if Input.is_action_pressed("attack"):
		attack_arr = mouse_position
		print(attack_arr[0])
		player_state = ATTACK
		attack_animation(delta, attack_arr)	

# call damage_taken function in playerHealth 
# when player takes damage from enemies 
func damage_taken():
	health.health_changed.emit()
	health.damage_taken(damage.damage)
	
# attack state
func attack_animation(delta, attack_arr):
	player_state = ATTACK
	animationState.travel("attack")
	player_attack.emit("player_attack")
	if player_state == ATTACK: 
		animation_tree.set("parameters/attack/attack/blend_position", 	attack_arr)

func attack_animation_finished():
	player_state = MOVE
	attack_arr = 0

func knockback():
	var kb_direction = - velocity * kb_power
	velocity = kb_direction
	
	move_and_slide()
	
	
func _on_area_2d_body_entered(area):
	print(area.name)
	if area.name == "enemy":
		health.damage_taken(25)
		frame_freeze.frameFreeze(ff_timescale, ff_duration)
		if health.current_health == 0:
			queue_free()
		
		knockback()
