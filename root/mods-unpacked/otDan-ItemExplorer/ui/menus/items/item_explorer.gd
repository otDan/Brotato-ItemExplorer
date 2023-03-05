class_name ItemExplorer
extends MarginContainer

signal back_button_pressed

export (PackedScene) var item_toggle
export (PackedScene) var character_toggle

onready var item_container = $"%ItemContainer"

onready var not_unlocked = $"%NotUnlocked"
onready var item_panel_ui = $"%ItemPanelUI"
onready var item_tags = $"%ItemTags"
onready var item_tags_label = $"%ItemTagsLabel"

onready var character_container = $"%CharacterContainer"

onready var ContentLoader = get_node("/root/ModLoader/Darkly77-ContentLoader/ContentLoader")

var character_toggle_dictionary: Dictionary


func init()->void:
	for child in item_container.get_children():
		item_container.remove_child(child)

	var first_item: Button = null
	for item in ItemService.items:
		var instance = item_toggle.instance()
		instance.set_item(item)
		instance.connect("item_toggle_focus_entered", self, "item_toggle_focus_entered")
		instance.connect("item_button_pressed", self, "item_button_pressed")
		item_container.add_child(instance)

		if first_item == null:
			first_item = instance.get_node("%ToggleButton")

	for character in ItemService.characters:
		var instance = character_toggle.instance()
		instance.set_character(character)
		character_container.add_child(instance)
		character_toggle_dictionary[character] = instance

	first_item.grab_focus()


func item_toggle_focus_entered(item_data: ItemData)->void:
	item_panel_ui.set_data(item_data)
	if not ProgressData.items_unlocked.has(item_data.my_id):
		var item_description: ItemDescription = item_panel_ui._item_description
		item_description._name.text = "???"
		item_description._effects.visible = false
		item_description._effects_scrolled.visible = false
		not_unlocked.visible = true
		item_tags.visible = false
	else:
		not_unlocked.visible = false
		item_tags.visible = true
		item_tags_label.text = str(item_data.tags)

		var has_character = false
		for character in character_toggle_dictionary:
			var has_tag = false
			for tag in item_data.tags:
				if character.wanted_tags.has(tag):
					has_tag = true
			if has_tag:
				has_character = true
				character_toggle_dictionary[character].visible = true
			else:
				character_toggle_dictionary[character].visible = false
		item_tags.visible = has_character


func item_button_pressed()->void:
	for character_node in character_container.get_children():
		if character_node.visible:
			character_node.get_node("%ToggleButton").grab_focus()

			# Get the center position of the panel container globally
			var center = character_node.rect_global_position + (character_node.rect_size / 2)

			# Set the mouse position to the center of the panel container
			get_viewport().warp_mouse(center)
			return

func _on_BackButton_pressed()->void:
	emit_signal("back_button_pressed")
