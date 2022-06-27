extends Area2D

class_name ProjecTile

var velocity = Vector2()
var speed = 500
var direction = 1

func _process(delta):
	velocity.x = speed*delta*direction
	translate(velocity)
	
func receiveDirection(dir):
	direction = dir

func _on_ProjectTile_body_exited(body):
	causeDamage(body)
	
func causeDamage(body):
	if body.name != "MainCaracter":
		if "Enemy" in body.name:
			body.takeDamage(1)
		queue_free()
