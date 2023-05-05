extends CheckBox


signal mod_toggled(mod, state)


onready var label = $MarginContainer/Label


func _ready():
	label.text = name


func _on_ModToggle_toggled(button_pressed):
	emit_signal("mod_toggled", name, button_pressed)


func _on_ModToggle_mouse_entered():
	label.scrolling = true


func _on_ModToggle_mouse_exited():
	label.scrolling = false
