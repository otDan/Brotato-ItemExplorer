class_name ItemExplorer
extends MarginContainer

signal back_button_pressed

export (PackedScene) var item_toggle

onready var item_container = $"%ItemContainer"
onready var item_panel_ui = $"%ItemPanelUI"
onready var not_unlocked = $"%NotUnlocked"

onready var ContentLoader = get_node("/root/ModLoader/Darkly77-ContentLoader/ContentLoader")


func init()->void:
	for child in item_container.get_children():
		item_container.remove_child(child)

	var first_item: Button = null
	for item in ItemService.items:
		var instance: ItemToggle = item_toggle.instance()
		instance.set_item(item)
		instance.connect("item_toggle_focus_entered", self, "item_toggle_focus_entered")
		item_container.add_child(instance)

		if first_item == null:
			first_item = instance.get_node("%ToggleButton")

	first_item.grab_focus()


func item_toggle_focus_entered(item_data: ItemData)->void:
	item_panel_ui.set_data(item_data)
	if not ProgressData.items_unlocked.has(item_data.my_id):
		var item_description: ItemDescription = item_panel_ui._item_description
		item_description._name.text = "???"
		item_description._effects.visible = false
		item_description._effects_scrolled.visible = false
		not_unlocked.visible = true
	else:
		not_unlocked.visible = false

func _on_BackButton_pressed()->void:
	emit_signal("back_button_pressed")
