extends Area2D


func _on_PunchHit_body_entered(body):
	causeDamage(body)
	
	
func causeDamage(body):
	if "Enemy" in body.name:
		body.takeDamage(1)
#		queue_free()
