extends LineEdit


func _on_Search_focus_entered():
	add_color_override("font_color", Color.black)


func _on_Search_focus_exited():
	add_color_override("font_color", Color.white)
