extends "res://ui/menus/title_screen/title_screen_menus.gd"

onready var menu_choose_options = get_node("MenuChooseOptions")

var _menu_item_explorer

func _ready():
	_menu_item_explorer = load("res://mods-unpacked/otDan-ItemExplorer/ui/menus/items/item_explorer.tscn").instance()
	add_child(_menu_item_explorer)
	_menu_item_explorer.visible = false
	_menu_item_explorer.connect("back_button_pressed", self, "item_explorer_back_button_pressed")
	menu_choose_options.connect("item_explorer_button_pressed", self, "item_explorer_button_pressed")


func item_explorer_button_pressed()->void:
	switch(menu_choose_options, _menu_item_explorer)


func item_explorer_back_button_pressed()->void:
	switch(_menu_item_explorer, menu_choose_options)
