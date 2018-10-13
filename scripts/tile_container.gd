extends Control

export(String) var tile_name = "TEST"

onready var name_label = find_node("name")
onready var count_label = find_node("count")

func _ready():
	name_label.text = tile_name
	set_count(hash(tile_name))

func set_count(num):
	count_label.text = str(num)

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			print("Pressed: ", tile_name)