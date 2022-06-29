tool
extends TextureButton

export(String) var text = "Text Button"
export(int) var arrow_margin_from_center = 100

class_name Buttons

func _ready():
	setup_text()
	hide_arrow()
	set_focus_mode(true)

func _process(delta):
	if Engine.editor_hint:
		setup_text()
		show_arrow()

func setup_text():
	$RichTextLabel.bbcode_text = "[center] %s [/center]" % [text]

func show_arrow():
	$Arrow.visible = true
	$Arrow.global_position.y = rect_global_position.y + (rect_size.y / 3.0)
		
	var center_x = rect_global_position.x + (rect_size.x / 2)
	$Arrow.global_position.x = center_x - arrow_margin_from_center
	
func hide_arrow():
	$Arrow.visible = false


func _on_TextureButton_focus_entered():
	show_arrow()

func _on_TextureButton_focus_exited():
	hide_arrow()

func _on_TextureButton_mouse_entered():
	grab_focus()
