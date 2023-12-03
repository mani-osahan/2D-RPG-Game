extends CharacterBody2D

@export var enemyHealth : enemyHealth
@export var playerDamage : playerDamage

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var progressBar : ProgressBar = $ProgressBar
@onready var despawn_timer : Timer = $despawn_timer
@onready var hitbox_collision : CollisionShape2D = $Sprite2D/hurtBox/CollisionHurtBox

@onready var player_hitBox : hitBox


var knockback = Vector2.ZERO

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, 200*delta)
	move_and_slide()

func _process(delta):
	progressBar.value = enemyHealth.current_health
	progressBar.max_value = enemyHealth.max_health
	
func take_damage(amount: int): 
	amount = playerDamage.damage
	
	enemyHealth.health_changed.emit()
	enemyHealth.damage_taken(amount)
	
	#knockback 
	velocity += Vector2.RIGHT * 100
	
	#play animation when enemy is damaged
	animation_player.play("damaged")
	
	
	if enemyHealth.current_health == 0:
		#set_deferred disables the collisionhurtbox after death
		hitbox_collision.set_deferred("disabled", true)
		
		#emit signal that health is zero
		enemyHealth.health_zero.emit()
		animation_player.play("death")
		despawn_timer.start()

#func knockback():
#	velocity +=Vector2.RIGHT * 200

func _on_despawn_timer_timeout():
	queue_free()
