extends KinematicBody2D

signal hp_slider(damage)

# Variaveis do game
var gravity = 20;
var move_speed = 200; #pixels por segundo
var jump_force = -450;
var up = Vector2(0,-1); #verifica se o personagem está no chão, por isso y é negativo
var motion = Vector2();
#var grounded
var HP = 10
var isDead = false
var canPunch = true
var checkPoint = Vector2()
# Jogaremos uma cena nessa variavel, atuará como objeto
var projecTile
var punchSpeed = 1

func _ready():
	checkPoint = $".".position

# Função rotina, roda até o game finalizar, ele funciona como loop
func _physics_process(delta):
	if !isDead:
		playerMoves()
	else:
		yield(get_tree().create_timer(1), "timeout")
		$".".position = checkPoint
		HP = 10
		emit_signal("hp_slider", HP)
		$AnimationTree.set("parameters/dead_alive/current", 0)
		isDead = false

func playerMoves():
	motion.y += gravity;
	
	# Movimentação do personagem
	if Input.is_action_pressed("ui_right"):
		motion.x = move_speed
		$Sprite.scale.x = 1
		#acessando o componente de estado, acessando o estado 1 - Walk
		$AnimationTree.set("parameters/movement/current", 1)
		
		# Ajustando a posição do projétil quando sai do player
#		$Position2D.position.x = position2DStart
	elif Input.is_action_pressed("ui_left"):
		motion.x = -move_speed
		$Sprite.scale.x = -1
		$AnimationTree.set("parameters/movement/current", 1)	
		# Ajustando a posição do projétil quando sai do player
#		$Position2D.position.x = position2DStart * -1
		
	else:
		motion.x = 0
		#acessando o componente de estado, acessando o estado 0 - Idle
		$AnimationTree.set("parameters/movement/current", 0)
		
	if is_on_floor():
		$AnimationTree.set("parameters/in_air/current", 0)
		if Input.is_action_pressed("ui_up"):
			$JumpSound.play()
			motion.y = jump_force
	else:
		$AnimationTree.set("parameters/in_air/current", 1)
	# Função que aplica movimento ao objeto motion
	motion = move_and_slide(motion, up);
	
	# Animação de soco is_action_just_pressed
	if Input.is_action_pressed("ui_punch") and canPunch:
		$AnimationTree.set("parameters/punch_state/current", 1)
		$PunchSound.play()
		canPunch = false
		yield(get_tree().create_timer(punchSpeed), "timeout")
		canPunch = true
		$AnimationTree.set("parameters/punch_state/current", 0)
		
func takeDamage(damage):
	HP -= damage
	emit_signal("hp_slider", HP)
	if HP <= 0: 
		isDead = true
		$AnimationTree.set("parameters/dead_alive/current", 1)


func _on_PunchHit_area_entered(area):
	if area.is_in_group("hurtbox"):
		area.takeDamage()
