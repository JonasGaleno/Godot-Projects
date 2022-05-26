extends Area2D

export(String) var level


func _on_EndLevel_body_entered(body):
	if body.name == "Player":
		$Sprite.frame = 4
		yield(get_tree().create_timer(2), "timeout")
		get_tree().change_scene("res://Level_"+level+".tscn")
