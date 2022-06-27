extends KinematicBody2D

var gravity = 10
var velocity = Vector2(0, 0)
var speed = 35
var canDamage = true
var isDead = false
var enemyHP = 3
var is_moving_right = true


func _ready():
	$AnimationPlayer.play("Run")

func _process(delta):
	if $AnimationPlayer.current_animation == "Attack_1":
		return
	
	move_character()
	detect_turn_around()
	hit_player()
	
func move_character():
	velocity.x = speed if is_moving_right else -speed
	velocity.y += gravity
	
	velocity = move_and_slide(velocity, Vector2.UP)

func detect_turn_around():
	if not $RayCast2D.is_colliding() and is_on_floor():
		is_moving_right = !is_moving_right
		scale.x = -scale.x
		print("time to turn around")

func hit_player():
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.name == 'MainCaracter' and canDamage:
			collision.collider.takeDamage(1)
			$AnimationPlayer.play('Attack_1')
			canDamage = false
			yield(get_tree().create_timer(1), "timeout")
			$AnimationPlayer.play('Run')
			canDamage = true

func takeDamage(damage):
	enemyHP -= damage
	if enemyHP <=0:
		isDead = true
		$AnimatedSprite.play('Dead')
		$AnimatedSprite.position.y = 23
		yield(get_tree().create_timer(1),"timeout")
		queue_free()
