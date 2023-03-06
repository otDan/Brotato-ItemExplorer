class_name CharacterToggle
extends PanelContainer

signal character_button_pressed(character_data)

const NOT_UNLOCKED_COLOR = Color(0, 0, 0, 0.25)
const NOT_UNLOCKED_DARK_COLOR = Color(0, 0, 0, 0.5)

onready var icon = $"%Icon"
onready var toggle_button = $"%ToggleButton"

var character_data: CharacterData

func _ready():
	if character_data == null:
		return

	icon.texture = character_data.icon
	toggle_button.hint_tooltip = character_data.name

	var stylebox_color = get_stylebox("panel").duplicate()
	ItemService.change_panel_stylebox_from_tier(stylebox_color, character_data.tier)
	add_stylebox_override("panel", stylebox_color)

	if ProgressData.characters_unlocked.has(character_data.my_id):
		return

	toggle_button.hint_tooltip = "???"
	toggle_button.disabled = true
	icon.self_modulate.a = 0.25


func set_character(character_data: CharacterData):
	self.character_data = character_data
	pass


func _on_ToggleButton_pressed():
	emit_signal("character_button_pressed", character_data)
