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

	var diff_info = ProgressData.get_character_difficulty_info(character_data.my_id, RunData.current_zone)
	if diff_info.max_difficulty_beaten.difficulty_value == 0:
		character_data.tier = Tier.DANGER_0
	elif diff_info.max_difficulty_beaten.difficulty_value > 0:
		character_data.tier = diff_info.max_difficulty_beaten.difficulty_value

	var stylebox_color: StyleBoxFlat = get_stylebox("panel").duplicate()
	ItemService.change_panel_stylebox_from_tier(stylebox_color, character_data.tier)
	add_stylebox_override("panel", stylebox_color)
	update_background_color()

	if ProgressData.characters_unlocked.has(character_data.my_id):
		return

	toggle_button.hint_tooltip = "???"
	toggle_button.disabled = true
	icon.self_modulate.a = 0.25


func set_character(_character_data: CharacterData):
	character_data = _character_data


func update_background_color(p_color:int = - 1) -> void:
	var stylebox_color: StyleBoxFlat = toggle_button.get_stylebox("normal").duplicate()
	change_inventory_element_stylebox_from_tier(stylebox_color, p_color if p_color != - 1 else character_data.tier, 0.35)
	toggle_button.add_stylebox_override("normal", stylebox_color)


func change_inventory_element_stylebox_from_tier(stylebox: StyleBoxFlat, tier: int, alpha: float = 1) -> void:
	var tier_color = ItemService.get_color_from_tier(tier)

	if tier_color == Color.white:
		tier_color = Color.black
		tier_color.a = 0.39
	else :
		tier_color.a = alpha

	stylebox.bg_color = tier_color


func _on_ToggleButton_pressed():
	emit_signal("character_button_pressed", character_data)
