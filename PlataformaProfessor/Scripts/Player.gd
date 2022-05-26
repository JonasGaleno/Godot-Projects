extends KinematicBody2D

signal hp_slider(damage)

var gravity = 20
var move_speed = 200
var jump_force = -550
var up = Vector2(0,-1)
var motion = Vector2()
var grounded
var HP = 10
var isDead = false
var canShoot = true
var projectile
var fireRate = 1
var position2DStart
var checkPoint = Vector2()

var leftPressed
var rightPressed
var upPressed
var AttPressed


func _ready():
	projectile = load("res://Projectile.tscn")
	position2DStart = $Position2D.position
	checkPoint = $".".position
	
func _physics_process(delta):
	motion.y += gravity
	if Input.is_action_pressed("ui_right") or rightPressed:
		motion.x = move_speed
		$Sprite.flip_h = false
		#$CollisionShape2D/AnimatedSprite.play('walk')
		$AnimationTree.set("parameters/movement/current", 1)
		$Position2D.position.x = position2DStart.x
	elif Input.is_action_pressed("ui_left") or leftPressed:
		motion.x = -move_speed
		$Sprite.flip_h = true
		#$CollisionShape2D/AnimatedSprite.play('walk')
		$AnimationTree.set("parameters/movement/current", 1)
		$Position2D.position.x = position2DStart.x*-1
	else:
		motion.x = 0
		#$CollisionShape2D/AnimatedSprite.play('idle')
		$AnimationTree.set("parameters/movement/current", 0)
		
	if is_on_floor():
		print('Esta no chao')
		$AnimationTree.set("parameters/in_air/current", 0)
		grounded = true
		if Input.is_action_pressed("ui_up") or upPressed:
			motion.y = jump_force
			grounded = false
	else:
		print('Sem chao')
#		$CollisionShape2D/AnimatedSprite.play('jump')
		$AnimationTree.set("parameters/in_air/current", 1)
		
	motion = move_and_slide(motion,up) 
	
	if (Input.is_action_just_pressed("ui_attack") or AttPressed) and canShoot:
		$AnimationTree.set("parameters/attack_state/current", 1)
		var proj = projectile.instance()
		proj.position = $Position2D.global_position
		proj.rotation_degrees = rotation_degrees
		
		if $Sprite.flip_h == false:
			proj.receiveDirection(1)
		else:
			proj.receiveDirection(-1)
		
		get_tree().get_root().add_child(proj)
		canShoot = false
		yield(get_tree().create_timer(fireRate), "timeout")
		canShoot = true
		$AnimationTree.set("parameters/attack_state/current", 0)
		
func takeDamage(damage):
	HP -= damage
	emit_signal("hp_slider", HP)
	if HP <= 0: 
		isDead = true
		$AnimationTree.set("parameters/dead_alive/current", 1)


func _on_DeathZone_body_entered(body):
	$".".position = checkPoint
	takeDamage(1)

func _on_LeftButton_pressed():
	leftPressed = true

func _on_LeftButton_released():
	leftPressed = false

func _on_RightButton_pressed():
	rightPressed = true

func _on_RightButton_released():
	rightPressed = false

func _on_UpButton_pressed():
	upPressed = true

func _on_UpButton_released():
	upPressed = false

func _on_AttackButton_pressed():
	AttPressed = true

func _on_AttackButton_released():
	AttPressed = false
