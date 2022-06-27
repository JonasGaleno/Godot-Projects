extends KinematicBody2D

onready var fireBall = preload("res://Scenes/FireProjectTile.tscn")
var f
var gravity = 10
var velocity = Vector2(0, 0)
var speed = 25
var canDamage = true
var isShooting = false
var isDead = false
var enemyHP = 3
var is_moving_right = true

func _ready():
	$AnimatedSprite.play("Run")

func move_character():
	velocity.x = speed if is_moving_right else -speed
	velocity.y += gravity
	
	velocity = move_and_slide(velocity, Vector2.UP)

func detect_turn_around():
	if not $GroundDetector.is_colliding() and is_on_floor():
		is_moving_right = !is_moving_right
		scale.x = -scale.x
		$Position2D.scale.x *= -1
		print("time to turn around")

func _physics_process(delta):
	if not isShooting:
		if $PlayerDetector.is_colliding():
			if $Timer.is_stopped():
				$Timer.start()
		else:
			if not $Timer.is_stopped():
				$Timer.stop()
		
		move_character()
		detect_turn_around()


func shoot(dir):
	if not isShooting:
		f = fireBall.instance()
		f.init(dir, 400)
		$AnimatedSprite.play('Justu')
		isShooting = true
		yield(get_tree().create_timer(1.5), "timeout")
		get_parent().add_child(f)
		isShooting = false
		$AnimatedSprite.play("Run")
		f.global_position = $Position2D.global_position

func takeDamage(damage):
	enemyHP -= damage
	if enemyHP <=0:
		isDead = true
		$AnimatedSprite.play('Dead')
		$AnimatedSprite.position.y = 23
		yield(get_tree().create_timer(1),"timeout")
		queue_free()

func _on_Timer_timeout():
	var dir = true
	if $'.'.scale.y == 1:
		dir = false
	shoot(dir)
