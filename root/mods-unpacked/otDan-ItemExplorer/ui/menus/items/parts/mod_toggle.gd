extends MyMenuButtonParent


signal mod_toggled(mod, state)


onready var label = $MarginContainer/Label


func _ready()->void :
	var _error_focus = connect("focus_entered", self, "on_focus_entered")
	var _error_press = connect("pressed", self, "on_pressed")
	var _error_mouse = connect("mouse_entered", self, "on_mouse_entered")

	label.text = name


func on_focus_entered():
	.on_focus_entered()
	label.scrolling = true
	label.add_color_override("font_color", Color.black)


func _on_ModToggle_toggled(button_pressed):
	emit_signal("mod_toggled", name, button_pressed)


func _on_ModToggle_focus_exited():
	label.scrolling = false
	label.add_color_override("font_color", Color.white)
