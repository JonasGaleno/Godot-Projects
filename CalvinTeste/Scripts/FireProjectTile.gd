extends Area2D

var direction = false
var start_position = 0
var lifespan = 400

func init(dir, ls = 400):
	direction = dir
	lifespan = ls

func _ready():
	scale = Vector2(.3, .3)
	
func _physics_process(delta):
	if start_position == 0:
		start_position = position.x
	if direction:
		if position.x < start_position - lifespan:
			queue_free()
		else:
			position.x -= 5
	else:
		if position.x > start_position + lifespan:
			queue_free()
		else:
			position.x += 5


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_FireProjectTile_body_entered(body):
	if body.name == "MainCaracter":
		body.takeDamage(1)
		queue_free()
