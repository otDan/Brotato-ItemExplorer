class_name ItemExplorerMenu
extends MarginContainer

signal back_button_pressed

export (PackedScene) var mod_toggle
export (PackedScene) var item_toggle
export (PackedScene) var character_toggle

onready var ContentLoader = get_node("/root/ModLoader/Darkly77-ContentLoader/ContentLoader")
onready var ItemExplorer = get_node("/root/ModLoader/otDan-ItemExplorer/ItemExplorer")
onready var StringComparer = get_node("/root/ModLoader/otDan-ItemExplorer/ItemStringComparer")

onready var mod_container = $"%ModContainer"
onready var item_container = $"%ItemContainer"
onready var not_unlocked = $"%NotUnlocked"
onready var item_panel_ui = $"%ItemPanelUI"
onready var item_tags = $"%ItemTags"
onready var character_container = $"%CharacterContainer"
onready var start_run_button = $"%StartRunButton"

onready var item_preview_container = $"%ItemPreviewContainer"
onready var preview_player = item_preview_container.get_node("%PreviewPlayer")

var item_dictionary: Dictionary
var character_toggle_dictionary: Dictionary
var mod_items: Dictionary
var item_appearances: Array = []

var visible_items: Dictionary
enum visible_keys {
	SEARCH,
	MOD_TOGGLE,
}


func _ready():
	var _size_changed = get_tree().root.connect("size_changed", self, "_on_viewport_size_changed")


func init() -> void:
	_on_viewport_size_changed()

	reset()

	var first_item: Button = null
	for item in ItemService.items:
		var mod = ContentLoader.lookup_modid_by_itemdata(item)
		if mod == "CL_Notice-NotFound":
			mod = "Vanilla"
		else:
			mod = get_string_after_character(mod, "-")

		for key in visible_keys:
			if not visible_items.has(key):
				visible_items[key] = {}
			visible_items[key][item] = true

		var instance = item_toggle.instance()
		instance.set_item(item)
		instance.connect("item_toggle_focus_entered", self, "item_toggle_focus_entered")
		instance.connect("item_button_pressed", self, "item_button_pressed")
		item_container.add_child(instance)

		if not mod_items.has(mod):
			mod_items[mod] = []
		mod_items[mod].append(item)

		item_dictionary[item] = instance

		if first_item == null:
			first_item = instance.get_node("%ToggleButton")

	for character in ItemService.characters:
		var instance = character_toggle.instance()
		instance.set_character(character)
		instance.connect("character_button_pressed", self, "character_button_pressed")
		character_container.add_child(instance)
		character_toggle_dictionary[character] = instance

	for mod in mod_items.keys():
		var instance: CheckBox = mod_toggle.instance()
		var _mod_toggled = instance.connect("mod_toggled", self, "on_mod_toggled")
		mod_container.add_child(instance)
		instance.set_info(mod, mod_items[mod].size())

	first_item.grab_focus()


func reset():
	ItemExplorer.selected_character = null
	start_run_button.disabled = true

	for child in item_container.get_children():
		item_container.remove_child(child)

	for child in mod_container.get_children():
		mod_container.remove_child(child)

	character_toggle_dictionary.clear()
	for child in character_container.get_children():
		character_container.remove_child(child)

	reset_preview_player()


func reset_preview_player():
	for appearance in item_appearances:
		appearance.queue_free()
	item_appearances.clear()


func get_string_after_character(a: String, character: String) -> String:
	var parts = a.split(character)
	if parts.size() > 1:
		return parts[1]
	else:
		return a


func item_toggle_focus_entered(item_data: ItemData) -> void:
	ItemExplorer.selected_character = null
	start_run_button.disabled = true
	item_panel_ui.set_data(item_data)

	var animation_node = preview_player.get_node("Animation")

	reset_preview_player()
	for appearance in item_data.item_appearances:
		if appearance == null:
			continue
		if appearance.sprite == null:
			continue

		var item_sprite = Sprite.new()
		item_sprite.texture = appearance.sprite
		animation_node.add_child(item_sprite)
		if appearance.depth < - 1:
			animation_node.move_child(item_sprite, 2)
		item_appearances.append(item_sprite)

	if ProgressData.items_unlocked.has(item_data.my_id):
		not_unlocked.visible = false
		item_tags.visible = true

		var has_character = false
		for character in character_toggle_dictionary:
			var has_tag = false
			for tag in item_data.tags:
				if character.wanted_tags.has(tag):
					has_tag = true
			if has_tag:
				has_character = true

			character_toggle_dictionary[character].visible = has_tag
		item_tags.visible = has_character
		return

	var item_description: ItemDescription = item_panel_ui._item_description
	item_description._name.text = "???"
	item_description._effects.visible = false
	item_description._effects_scrolled.visible = false
	not_unlocked.visible = true
	item_tags.visible = false


func item_button_pressed() -> void:
	for character_node in character_container.get_children():
		if character_node.visible:
			if not InputService.using_gamepad:
				var center = character_node.rect_global_position + (character_node.rect_size / 2)
				get_viewport().warp_mouse(center)

			character_node.get_node("%ToggleButton").grab_focus()
			return


func character_button_pressed(character: CharacterData)->void:
	if not ProgressData.characters_unlocked.has(character.my_id):
		return

	ItemExplorer.selected_character = character

	if not InputService.using_gamepad:
		var center = start_run_button.rect_global_position + (start_run_button.rect_size / 2)
		get_viewport().warp_mouse(center)

	start_run_button.grab_focus()
	start_run_button.disabled = false


func on_mod_toggled(mod, state):
	for item in item_dictionary:
		var item_mod = ContentLoader.lookup_modid_by_itemdata(item)
		if item_mod == "CL_Notice-NotFound":
			item_mod = "Vanilla"
		else:
			item_mod = get_string_after_character(item_mod, "-")
		if not item_mod == mod:
			continue
		visible_items[visible_keys.keys()[visible_keys.MOD_TOGGLE]][item] = state
	handle_item_visiblity()


func _show_search_results(search: String):
	for child in item_container.get_children():
		var result = StringComparer._check_similarity(child.name.to_lower(), search.to_lower(), 1)
		if search == "":
			result = true
		visible_items[visible_keys.keys()[visible_keys.SEARCH]][child.item_data] = result
	handle_item_visiblity()


func handle_item_visiblity():
	for item in item_dictionary:
		var item_visible = true
		for key in visible_keys:
			if not visible_items[key][item]:
				item_visible = false
		var item_button = item_dictionary[item]
		item_button.visible = item_visible


func _on_viewport_size_changed():
	var items = int(round(get_viewport().get_visible_rect().size.x * 0.5 / 90))
	item_container.columns = items


func _on_BackButton_pressed() -> void:
	emit_signal("back_button_pressed")


func _on_StartRunButton_pressed():
	if ItemExplorer.selected_character == null:
		return

	MusicManager.tween(-5)
	var _error = get_tree().change_scene(MenuData.character_selection_scene)


func _on_Search_text_changed(search: String):
	_show_search_results(search)
