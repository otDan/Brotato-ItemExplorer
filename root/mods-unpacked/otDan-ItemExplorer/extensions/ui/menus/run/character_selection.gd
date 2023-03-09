extends "res://ui/menus/run/character_selection.gd"


onready var ItemExplorer = get_node("/root/ModLoader/otDan-ItemExplorer/ItemExplorer")


func _ready():
	var selected_character = ItemExplorer.selected_character
	if selected_character == null:
		return
	for element in _inventory.get_children():
		if element.item == null:
			continue
		if element.item.my_id == selected_character.my_id:
			element._on_InventoryElement_pressed()
			ItemExplorer.selected_character = null
