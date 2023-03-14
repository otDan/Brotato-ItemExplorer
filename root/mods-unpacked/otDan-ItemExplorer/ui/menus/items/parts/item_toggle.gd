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

	name = tr(item_data.name)
	item_icon.texture = item_data.icon

	var stylebox_color: StyleBoxFlat = get_stylebox("panel").duplicate()
	ItemService.change_panel_stylebox_from_tier(stylebox_color, item_data.tier)
#	stylebox_color.content_margin_top = 0
#	stylebox_color.content_margin_bottom = 0
#	stylebox_color.content_margin_right = 0
#	stylebox_color.content_margin_left = 0
	add_stylebox_override("panel", stylebox_color)
	update_background_color()

	if ProgressData.items_unlocked.has(item_data.my_id):
		return

	toggle_button.disabled = true
	item_icon.self_modulate.a = 0.65


func set_item(item_data: ItemData):
	self.item_data = item_data
	pass


func send_item():
	if item_data == null:
		return
	emit_signal("item_toggle_focus_entered", item_data)


func update_background_color(p_color:int = - 1)->void :
	var stylebox_color: StyleBoxFlat = toggle_button.get_stylebox("normal").duplicate()
	change_inventory_element_stylebox_from_tier(stylebox_color, p_color if p_color != - 1 else item_data.tier, 0.35)
	toggle_button.add_stylebox_override("normal", stylebox_color)


func change_inventory_element_stylebox_from_tier(stylebox:StyleBoxFlat, tier:int, alpha:float = 1)->void :
	var tier_color = ItemService.get_color_from_tier(tier)

	if tier_color == Color.white:
		tier_color = Color.black
		tier_color.a = 0.39
	else :
		tier_color.a = alpha

	stylebox.bg_color = tier_color


func _on_Button_focus_entered():
	send_item()


func _on_Button_mouse_entered():
	send_item()


func _on_ToggleButton_pressed():
	emit_signal("item_button_pressed")
