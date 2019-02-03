extends "rotation_organelle.gd"

onready var animation = find_node("animation") as AnimationPlayer
onready var drill_base = find_node("drill_base") as Sprite

func _ready():
	rotation_sprite = drill_base

func activate():
	animation.play("extend")

func deactivate():
	animation.play("retract")

