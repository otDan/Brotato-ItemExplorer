tool
extends ScrollContainer


onready var _v_scroll := get_v_scrollbar()
onready var margin := $MarginContainer


func _ready() -> void:
	var _visibility_changed = _v_scroll.connect("visibility_changed", self, "_on_scroll_bar_visibility_changed")


func _on_scroll_bar_visibility_changed() -> void:
	if _v_scroll.visible:
		margin.set("custom_constants/margin_right", 0)
	else:
		margin.set("custom_constants/margin_right", _v_scroll.rect_size.x)
