extends Camera2D

const zoom_speed = 0.05

onready var game_glass = get_node("/root/main/top_ui_layer/HBoxContainer/VBoxContainer/game_glass")
onready var prev_ggc = game_glass.get_node("game_glass_center").get_rect().position
onready var game_grid = get_node("/root/main/game_area/game_grid")
onready var tm = game_grid.get_node("TileMap")

signal zoom_label_set

var zoom_factor = 1.0
var middle_mouse_pressed = false

# Available Zoom Levels and the relative zoom (e.g. 2x)
var zoom_set =   [ 0.125, 0.25,  0.5,  1.0 ]
var zoom_times = [     8,    4,    2,    1 ]
var zoom_idx = zoom_set.find(1.0)  # Current zoom index

func _ready():
	set_zoom_label()
	get_tree().get_root().connect("size_changed", self, "_window_size_changed")
	
	# Wait a frame before doing the following
	yield(get_tree(), "idle_frame")
	constrain_offset()

func set_zoom_label():
	emit_signal("zoom_label_set", zoom_times[zoom_idx])

func _input(event):
	if event is InputEventMouseMotion && middle_mouse_pressed:
		offset.x -= event.relative.x * zoom_factor
		offset.y -= event.relative.y * zoom_factor
		constrain_offset()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_MIDDLE:
			middle_mouse_pressed = event.pressed
		elif event.button_index == BUTTON_WHEEL_UP && !event.pressed:
			zoom_in()
			constrain_offset()
		elif event.button_index == BUTTON_WHEEL_DOWN && !event.pressed:
			zoom_out()
			constrain_offset()
		elif event.button_index == BUTTON_LEFT && event.pressed:
			var v = tm.world_to_map((event.position * zoom_factor) + offset)
			print(v)
			print(tm.get_cellv(v))

func zoom_in():
	zoom_idx -= 1
	if zoom_idx < 0:
		zoom_idx = 0
	set_zoom_at_mouse(zoom_set[zoom_idx])
	print(zoom_set[zoom_idx])
	set_zoom_label()

func zoom_out():
	zoom_idx += 1
	if zoom_idx > zoom_set.size() - 1:
		zoom_idx = zoom_set.size() - 1
	set_zoom_at_mouse(zoom_set[zoom_idx])
	print(zoom_set[zoom_idx])
	set_zoom_label()

func set_zoom_at_mouse(set_zoom_to):
	var old_zoom = zoom_factor
	var zoom_at = get_local_mouse_position() - offset
	zoom_factor = set_zoom_to
	var diff = 1.0 - (zoom_factor / old_zoom)
	
	offset.x += zoom_at.x * diff
	offset.y += zoom_at.y * diff
	
	zoom.x = zoom_factor
	zoom.y = zoom_factor

func constrain_offset():
	var TOP_LEFT_MARGIN = -1
	var game_glass_size = game_glass.rect_size * zoom
	var game_grid_size = game_grid.get_grid_rect().size
	
	var x_test = game_grid_size.x - game_glass_size.x
	if offset.x > x_test:
		offset.x = x_test
	var y_test = game_grid_size.y - game_glass_size.y
	if offset.y > y_test:
		offset.y = y_test
	if offset.x < TOP_LEFT_MARGIN:
		offset.x = TOP_LEFT_MARGIN
	if offset.y < TOP_LEFT_MARGIN:
		offset.y = TOP_LEFT_MARGIN
	
	# If game_glass is bigger than the game_grid, the above code will result
	# in the game_grid being 'snapped' to the top left corner. Now we can
	# offset it centerwise:
	if game_glass_size.x > game_grid_size.x:
		offset.x = (game_grid_size.x / 2.0) - (game_glass_size.x / 2.0)
	if game_glass_size.y > game_grid_size.y:
		offset.y = (game_grid_size.y / 2.0) - (game_glass_size.y / 2.0)

func _on_ResetViewButton_pressed():
	zoom_idx = zoom_set.find(1.0)
	zoom_factor = zoom_set[zoom_idx]
	zoom.x = 1.0
	zoom.y = 1.0
	offset.x = 0
	offset.y = 0
	set_zoom_label()
	
	var gg_center = (game_glass.rect_size / 2.0) + game_glass.rect_position
	var gg_center_ratio = gg_center / get_node("/root").size
	constrain_offset()
	
func _window_size_changed():
	yield(get_tree(), "idle_frame")
	var ggc = game_glass.get_node("game_glass_center").rect_position
	var offset_by = Vector2((prev_ggc.x - ggc.x) * zoom.x, (prev_ggc.y - ggc.y) * zoom.y)
	offset += offset_by
	prev_ggc = ggc
	constrain_offset()
