extends KinematicBody2D

#MOVIMENTAÇÃO BÁSICA
#var velocity = Vector2() #instanciando objeto
#
#func _get_input(): #função local, coloca-se '_'
#	velocity = Vector2()
#	if Input.is_action_pressed("ui_right"):
#		velocity.x += 1
#	if Input.is_action_pressed("ui_left"):
#		velocity.x -= 1
#	if Input.is_action_pressed("ui_up"):
#		velocity.y -= 1
#	if Input.is_action_pressed("ui_down"):
#		velocity.y += 1
#
#	velocity = velocity.normalized()*move_speed #adicionando velocidade

# É um sinal, que faz uma função conectar se com um objeto de outro local
signal hp_slider(damage)

# Variaveis do game
var gravity = 20;
var move_speed = 200; #pixels por segundo
var jump_force = -450;
var up = Vector2(0,-1); #verifica se o personagem está no chão, por isso y é negativo
var motion = Vector2();
#var grounded
var HP = 10
var idDead = false
var canShoot = true
# Jogaremos uma cena nessa variavel, atuará como objeto
var projecTile
var fireRate = 2

# Passando um objeto para a variavel, ready é quando o jogo inicia
func _ready():
	projecTile = load("res://ProjecTile.tscn")


# Função rotina, roda até o game finalizar, ele funciona como loop
func _physics_process(delta):
	motion.y += gravity;
	
	# Movimentação do personagem
	if Input.is_action_pressed("ui_right"):
		motion.x = move_speed
		$Sprite.flip_h = false
		#adicionando a animação na movimentação do personagem
		#acessando o componente de estado, acessando o estado 1 - Walk
		$AnimationTree.set("parameters/movement/current", 1)
	elif Input.is_action_pressed("ui_left"):
		motion.x = -move_speed
		$Sprite.flip_h = true
		$AnimationTree.set("parameters/movement/current", 1)
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
	
	# Animação de ataque
	
	if Input.is_action_just_pressed("ui_attack") and canShoot:
		$AnimationTree.set("parameters/attack_state/current", 1)
		var proj = projecTile.instance()
		proj.position = $".".global_position
		proj.rotation_degrees = rotation_degrees
		
#		if $Sprite.flip_h == false:
#			proj.receiveDirection(1)
#		else:
#			proj.receiveDirection(-1)
		
		get_tree().get_root().add_child(proj)
		canShoot = false
		
		# Código será travado aqui para nao atacar infinitamente
		yield(get_tree().create_timer(fireRate), "timeout")
		canShoot = true
		$AnimationTree.set("parameters/attack_state/current", 0)
func takeDemage(damage):
	HP -= damage
	emit_signal("hp_slider", HP)
	
	if HP <= 0:
		idDead = true
		# ANIMAÇÃO DA MORTE
		$AnimationTree.set("parameters/dead_alive/current", 1)
