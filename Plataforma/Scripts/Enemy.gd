extends KinematicBody2D

var speed = 1
var distance = 50
var right = true
var initialPosition
var finalPosition
var isDead = false
var enemyHp = 3
var canDamage = true
var col_info

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("Walk")
	initialPosition = $".".position.x
	finalPosition = initialPosition + distance
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !isDead:
		if right:
			$".".position.x += speed
			$AnimatedSprite.flip_h = false
		else:
			$".".position.x -= speed
			$AnimatedSprite.flip_h = true
			
		if $".".position.x > finalPosition:
			right = false
		elif $".".position.x < initialPosition:
			right = true
	else:
		$AnimatedSprite.play("Dead")
	
	var col_info = move_and_slide(Vector2(0,0))
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.name == 'Player' and canDamage:
			# CAUSAR DANO
			collision.collider.takeDemage(1)
			$AnimatedSprite.play('Punch')
			
			# Variavel de controle para nao rodar muitas vezes e acontecer o hit kill
			canDamage = false
			yield(get_tree().create_timer(1), "timeout")
			$AnimatedSprite.play('Walk')
			canDamage = true
	
