extends CheckBox

signal mod_toggled(mod, state)


func _ready():
	text = name


func _on_ModToggle_toggled(button_pressed):
	emit_signal("mod_toggled", name, button_pressed)
	pass # Replace with function body.
