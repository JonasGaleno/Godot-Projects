extends Area2D

var velocity = Vector2()
var speed = 500
var direction = 1

func _process(delta):
	velocity.x = speed*delta*direction
	translate(velocity)
	
func receiveDirection(dir):
	direction = dir

func _on_Projectile_body_exited(body):
	if body.name != "Player":
		if body.name == "Enemy":
			body.takeDamage(1)
		queue_free()
