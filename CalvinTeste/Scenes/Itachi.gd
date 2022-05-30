extends KinematicBody2D

var gravity = 10
var velocity = Vector2(0, 0)
var speed = 35

var is_moving_right = true

#export(int) var hitpoints = 100
#var max_hitpoints = hitpoints

var mainCharacter

func _ready():
	mainCharacter = load("res://MainCaracter.tscn")
	$AnimationPlayer.play("Run")

func _process(delta):
	if $AnimationPlayer.current_animation == "Attack_1":
		return
	
	move_character()
	detect_turn_around()
	
func move_character():
	velocity.x = speed if is_moving_right else -speed
	velocity.y += gravity
	
	velocity = move_and_slide(velocity, Vector2.UP)

func detect_turn_around():
	if not $RayCast2D.is_colliding() and is_on_floor():
		is_moving_right = !is_moving_right
		scale.x = -scale.x
		print("time to turn around")

# Essas funções serão chamadas no AnimationPlayer
#ativar o detector de ataque
func hit():
	$AttackDetector.monitoring = true

#desativar o detector de ataque
func end_of_hit():
	$AttackDetector.monitoring = false

#voltar a andar/correr
func start_walk():
	$AnimationPlayer.play("Run")


func _on_PlayerDetector_body_entered(body):
	$AnimationPlayer.play("Attack_1")

#dano ao personagem principal
func _on_AttackDetector_body_entered(body):
	var character = mainCharacter.instance()
	character.takeDamage(10)
#	get_tree().reload_current_scene()

func takeDamage(damage):
	queue_free()
