extends Control

export(String) var tile_name = "TEST"
export(int) var tile_count = 0

onready var name_label = find_node("name")
onready var count_label = find_node("count")

var data = null

func set_name(name_str):
	tile_name = name_str
	name_label.text = name_str

func set_count(num):
	tile_count = num
	count_label.text = str(num)

func set_data(new_data):
	var prev_data = data
	data = new_data
	return prev_data

func get_data():
	return data

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			print("Pressed: ", tile_name)
			get_parent().inv_clicked(get_position_in_parent())
