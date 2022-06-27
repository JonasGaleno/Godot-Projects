extends KinematicBody2D

class_name EnemyBase

var speed = 1
var distance = 200
var right = true
var initialPosition
var finalPosition
var isDead = false
var enemyHP = 4
var isKicking = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play('Run')
	initialPosition = $'.'.position.x
	finalPosition = initialPosition + distance

func _physics_process(delta):
	enemyActions()
	
func enemyActions():
	if not isKicking:
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
			$AnimatedSprite.play('Dead')
	
	var col_info = move_and_slide(Vector2(0,0))
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.name == 'MainCaracter' and not isKicking:
			collision.collider.takeDamage(1)
			$AnimatedSprite.play('Attack_01')
			isKicking = true
			yield(get_tree().create_timer(1.5), "timeout")
			$AnimatedSprite.play('Run')
			isKicking = false
			
func takeDamage(damage):
	enemyHP -= damage
	print("Vida do inimigo: " + str(enemyHP))
	if enemyHP <=0:
		isDead = true
		$AnimatedSprite.play('Dead')
		$AnimatedSprite.position.y = 23
		yield(get_tree().create_timer(3),"timeout")
		queue_free()
