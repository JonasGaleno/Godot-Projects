extends Node

func _ready():
	$VBoxContainer/Restart.grab_focus()

func _process(delta):
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()

func _on_Restart_pressed():
	print("Start pressionado")
	get_tree().change_scene("res://Scenes/Level_1.tscn")


func _on_MainMenu_pressed():
	print("Menu pressionado")
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
