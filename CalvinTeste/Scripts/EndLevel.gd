extends Area2D

export(String) var level
var area_active = false

func _physics_process(_delta):
	if area_active and Input.is_action_just_pressed("ui_down"):
		print("Next level"+str(level))
		if level == "final":
			get_tree().change_scene("res://Scenes/WinScreen.tscn")
		else:
			get_tree().change_scene("res://Scenes/Level_"+level+".tscn")

func _on_EndLevel_body_entered(body):
	if body.name == "MainCaracter":
		area_active = true
	#		yield(get_tree().create_timer(1), "timeout")
	#		get_tree().change_scene("res://Scenes/Level_"+level+".tscn")

func _on_EndLevel_body_exited(body):
	if body.name == "MainCaracter":
		area_active = false
