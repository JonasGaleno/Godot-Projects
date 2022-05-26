extends KinematicBody2D

var gravity = 20;
var move_speed = 200; #pixels por segundo
var jump_force = -450;
var up = Vector2(0,-1); #verifica se o personagem está no chão, por isso y é negativo
var motion = Vector2();

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

#função rotina, roda até o game finalizar, ele funciona como loop
func _physics_process(delta):
	motion.y += gravity;
	#movimentação do personagem
	if Input.is_action_pressed("ui_right"):
		motion.x = move_speed
		#acessando a hierarquia do personagem
#		$CollisionShape2D/AnimatedSprite.flip_h = false
		$Sprite.flip_h = false
		#adicionando a animação na movimentação do personagem
#		$CollisionShape2D/AnimatedSprite.play('Walk')

		#acessando o componente de estado, acessando o estado 1 - Walk
		$AnimationTree.set("parameters/movement/current", 1)
	elif Input.is_action_pressed("ui_left"):
		motion.x = -move_speed
#		$CollisionShape2D/AnimatedSprite.flip_h = true
#		$CollisionShape2D/AnimatedSprite.play('Walk')
		$Sprite.flip_h = true
		$AnimationTree.set("parameters/movement/current", 1)
	else:
		motion.x = 0
#		$CollisionShape2D/AnimatedSprite.play('Idle')
		#acessando o componente de estado, acessando o estado 0 - Idle
		$AnimationTree.set("parameters/movement/current", 0)
		
	if is_on_floor():
		$AnimationTree.set("parameters/in_air/current", 0)
		if Input.is_action_pressed("ui_up"):
			motion.y = jump_force
	else:
#		$CollisionShape2D/AnimatedSprite.play('Jump')
		$AnimationTree.set("parameters/in_air/current", 1)
		print("no floor bro")
		#elif Input.is_action_pressed("ui_down"):
			#motion.y += 1
	#função que aplica movimento ao objeto motion
	motion = move_and_slide(motion, up);

