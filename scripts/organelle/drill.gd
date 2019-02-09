extends "rotation_organelle.gd"

onready var animation:AnimationPlayer = find_node("animation") as AnimationPlayer
onready var drill_base:Sprite = find_node("drill_base") as Sprite

func _ready():
	rotation_sprite = drill_base

func get_rotation_sprite():
	return(drill_base)

func activate():
	animation.play("extend")
	

func deactivate():
	animation.play("retract")

func _process(delta):
	if Input.is_action_just_pressed("TEST"):
		activate()
	if Input.is_action_just_pressed("TEST2"):
		deactivate()