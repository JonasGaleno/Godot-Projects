extends Node


func _ready():
	$VBoxContainer/Continue.grab_focus()
	set_visible(false)
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		set_visible(!get_tree().paused)
		get_tree().paused = !get_tree().paused
		
#func _on_Button_pressed():
#	get_tree().paused = false
#	set_visible(false)

func set_visible(is_visible):
	for node in get_children():
		node.visible = is_visible

func _on_Continue_pressed():
	get_tree().paused = false
	set_visible(false)
