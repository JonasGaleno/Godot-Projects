extends EnemyBase

class_name Enemy_Shooter

var timerValue = 2
var timer = 0

func enemyActions():
	.enemyActions()
	timer+=1
	if timer >= 200:
		timer = 0
		shoot()
	
func shoot():
	var p = load('res://FireProjectile.tscn')
	var proj = p.instance()
	proj.position = $".".position
	get_tree().get_root().add_child(proj)
	
