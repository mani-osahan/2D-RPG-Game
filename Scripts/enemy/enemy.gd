extends CharacterBody2D

@export var enemyHealth : enemyHealth
@export var playerDamage : playerDamage

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var animationState = animation_tree.get("parameters/playback")

@onready var progressBar : ProgressBar = $ProgressBar
@onready var despawn_timer : Timer = $despawn_timer
@onready var hitbox_collision : CollisionShape2D = $Sprite2D/hurtBox/CollisionHurtBox


@onready var player_hitBox : hitBox
@onready var enemy_detect : Area2D = $enemyDetection

@export var kb_power : int = 500

func _ready():
	animation_tree.active = true
	animationState.travel("idle")


func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, 200*delta)
	move_and_slide()

func _process(delta):
	progressBar.value = enemyHealth.current_health
	progressBar.max_value = enemyHealth.max_health


func movement():
	pass

func followPlayer():
	pass

func take_damage(amount: int): 
	amount = playerDamage.damage
	
	enemyHealth.health_changed.emit()
	enemyHealth.damage_taken(amount)
	
	enemy_knockback()
	
	#play animation when enemy is damaged
	animationState.travel("damaged")
	
	#if the enemy health is ZERO
	if enemyHealth.current_health == 0:
		#set_deferred disables the collisionhurtbox after death
		hitbox_collision.set_deferred("disabled", true)
		
		#emit signal that health is zero
		enemyHealth.health_zero.emit()
		animation_player.play("death")
		despawn_timer.start()

func enemy_knockback():
	var kb_direction = Vector2.RIGHT * kb_power
	velocity = kb_direction
	move_and_slide()


func _on_despawn_timer_timeout():
	queue_free()
