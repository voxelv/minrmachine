extends Control

export(String) var tile_name = "TEST"

func _ready():
	$MarginContainer/HBoxContainer/VBoxContainer/name.text = tile_name

func set_selected(selected):
	$MarginContainer/HBoxContainer/select_bg.visible = selected

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			print("Pressed: ", tile_name)