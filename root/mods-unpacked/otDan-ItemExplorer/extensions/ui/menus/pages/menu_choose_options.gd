extends "res://ui/menus/pages/menu_choose_options.gd"


signal item_explorer_button_pressed


func _ready():
	var item_explorer_button = Button.new()
	item_explorer_button.name = "ItemExplorer"
	item_explorer_button.text = "Items"
	item_explorer_button.connect("pressed", self, "item_explorer_button_pressed")
	item_explorer_button.set_script(preload("res://ui/menus/global/my_menu_button.gd"))
	var buttons = get_child(0)
	buttons.add_child(item_explorer_button)
	buttons.move_child(item_explorer_button, buttons.get_child_count() - 2)


func item_explorer_button_pressed():
	emit_signal("item_explorer_button_pressed")
