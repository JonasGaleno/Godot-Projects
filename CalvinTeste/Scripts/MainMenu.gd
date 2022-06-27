extends Node

func _ready():
	$VBoxContainer/VBoxContainer/Start.grab_focus()

func _process(delta):
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()

func _on_Start_pressed():
	print("Start pressionado")
	get_tree().change_scene("res://Scenes/Level_1.tscn")


func _on_Option_pressed():
	print("Options pressionado")


func _on_Exit_pressed():
	print("Exit pressionado")
	get_tree().quit()
