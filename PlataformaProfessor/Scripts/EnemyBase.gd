extends KinematicBody2D

class_name EnemyBase

var speed = 2
var distance = 200
var right = true
var initialPosition
var finalPosition
var isDead = false
var enemyHP = 3
var canDamage = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play('walk')
	initialPosition = $'.'.position.x
	finalPosition = initialPosition + distance

func _physics_process(delta):
	enemyActions()
	
func enemyActions():
	if !isDead:
		if right:
			$'.'.position.x += speed
			$AnimatedSprite.flip_h = false
		else:
			$'.'.position.x -= speed
			$AnimatedSprite.flip_h = true
			
		if $'.'.position.x > finalPosition:
			right = false
		elif $'.'.position.x < initialPosition:
			right = true
	else:
		$AnimatedSprite.play('dead')
	
	var col_info = move_and_slide(Vector2(0,0))
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.name == 'Player' and canDamage:
			collision.collider.takeDamage(1)
			$AnimatedSprite.play('attack')
			canDamage = false
			yield(get_tree().create_timer(1), "timeout")
			$AnimatedSprite.play('walk')
			canDamage = true
			
func takeDamage(damage):
	enemyHP -= damage
	if enemyHP <=0:
		isDead = true
		$AnimatedSprite.play('dead')
		$AnimatedSprite.position.y = 23
		yield(get_tree().create_timer(1),"timeout")
		queue_free()
