class_name ItemToggle
extends PanelContainer

signal item_toggle_focus_entered(item_data)
signal item_button_pressed

const NOT_UNLOCKED_COLOR = Color(0, 0, 0, 0.25)
const NOT_UNLOCKED_DARK_COLOR = Color(0, 0, 0, 0.5)

onready var item_icon = $"%ItemIcon"
onready var toggle_button = $"%ToggleButton"

var item_data: ItemData

func _ready():
	if item_data == null:
		return

	item_icon.texture = item_data.icon

	var stylebox_color = get_stylebox("panel").duplicate()
	ItemService.change_panel_stylebox_from_tier(stylebox_color, item_data.tier)
	add_stylebox_override("panel", stylebox_color)

	if ProgressData.items_unlocked.has(item_data.my_id):
		return

	toggle_button.disabled = true
	item_icon.self_modulate.a = 0.45


func set_item(item_data: ItemData):
	self.item_data = item_data
	pass


func send_item():
	if item_data == null:
		return

	emit_signal("item_toggle_focus_entered", item_data)


func _on_Button_focus_entered():
	send_item()


func _on_Button_mouse_entered():
	send_item()


func _on_ToggleButton_pressed():
	emit_signal("item_button_pressed")
