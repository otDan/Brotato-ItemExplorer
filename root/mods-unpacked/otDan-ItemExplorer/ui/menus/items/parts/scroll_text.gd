extends Label


export (float) var scroll_speed = 40.0
var scrolling = false
var initial_position


func _ready():
	initial_position = rect_position.x


func _process(delta):
	if not scrolling:
		rect_position.x = initial_position
		return
	rect_position.x -= scroll_speed * delta
	if rect_position.x < -rect_size.x:
		rect_position.x = get_parent().get_rect().size.x
