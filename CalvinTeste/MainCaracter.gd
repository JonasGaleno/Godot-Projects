extends KinematicBody2D

# Variaveis do game
var gravity = 20;
var move_speed = 200; #pixels por segundo
var jump_force = -450;
var up = Vector2(0,-1); #verifica se o personagem está no chão, por isso y é negativo
var motion = Vector2();
#var grounded
var HP = 10
var idDead = false
var canPunch = true
# Jogaremos uma cena nessa variavel, atuará como objeto
var projecTile
var punchSpeed = 0.5

# Função rotina, roda até o game finalizar, ele funciona como loop
func _physics_process(delta):
	motion.y += gravity;
	
	# Movimentação do personagem
	if Input.is_action_pressed("ui_right"):
		motion.x = move_speed
		$Sprite.flip_h = false
		#acessando o componente de estado, acessando o estado 1 - Walk
		$AnimationTree.set("parameters/movement/current", 1)
		
		# Ajustando a posição do projétil quando sai do player
#		$Position2D.position.x = position2DStart
	elif Input.is_action_pressed("ui_left"):
		motion.x = -move_speed
		$Sprite.flip_h = true
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
			motion.y = jump_force
	else:
		$AnimationTree.set("parameters/in_air/current", 1)
	# Função que aplica movimento ao objeto motion
	motion = move_and_slide(motion, up);
	
	# Animação de soco
	if Input.is_action_just_pressed("ui_punch") and canPunch:
		$AnimationTree.set("parameters/punch_state/current", 1)
		canPunch = false
		yield(get_tree().create_timer(punchSpeed), "timeout")
		canPunch = true
		$AnimationTree.set("parameters/punch_state/current", 0)
