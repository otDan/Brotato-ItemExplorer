extends "res://ui/menus/title_screen/title_screen_menus.gd"

onready var item_menu_choose_options = get_node("MenuChooseOptions")

var _menu_item_explorer


func _ready():
	_menu_item_explorer = load("res://mods-unpacked/otDan-ItemExplorer/ui/menus/menu_item_explorer.tscn").instance()
	add_child(_menu_item_explorer)
	_menu_item_explorer.visible = false
	_menu_item_explorer.connect("back_button_pressed", self, "item_explorer_back_button_pressed")
	item_menu_choose_options.connect("item_explorer_button_pressed", self, "item_explorer_button_pressed")


func back() -> void:
	.back()
	_menu_item_explorer.full_reset()
	

func item_explorer_button_pressed() -> void:
	switch(item_menu_choose_options, _menu_item_explorer)


func item_explorer_back_button_pressed() -> void:
	switch(_menu_item_explorer, item_menu_choose_options)
