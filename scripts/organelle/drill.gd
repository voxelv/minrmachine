extends "rotation_organelle.gd"

onready var extend_animation:AnimationPlayer = find_node("extend_animation") as AnimationPlayer
onready var drilling_animation:AnimationPlayer = find_node("drilling_animation") as AnimationPlayer
onready var drill_timer:Timer = find_node("drill_timer") as Timer
onready var drill_base:Sprite = find_node("drill_base") as Sprite
onready var drilling_pos:Position2D = find_node("drilling_pos") as Position2D
enum DRILL_STATE {SLEEP, EXTEND, DRILLING, RETRACT}

var drill_state:int = DRILL_STATE.SLEEP

func _ready():
	# connections
	extend_animation.connect("animation_finished", self, "_anim_finished")
	drill_timer.connect("timeout", self, "_drilling_done")
	
	rotation_sprite = drill_base

func get_rotation_sprite() -> Sprite:
	return(drill_base)

func activate():
	extend_animation.play("extend")
	drilling_animation.play("drilling")
	drill_state = DRILL_STATE.EXTEND

func deactivate():
	extend_animation.play_backwards("extend")
	drill_state = DRILL_STATE.RETRACT

func _process(delta):
	if Input.is_action_just_pressed("TEST"):
		activate()
	if Input.is_action_just_pressed("TEST2"):
		deactivate()

func _anim_finished(anim):
	match(drill_state):
		DRILL_STATE.EXTEND:
			drill_state = DRILL_STATE.DRILLING
			drill_timer.start()
		DRILL_STATE.RETRACT:
			drilling_animation.stop(true)
			drill_state = DRILL_STATE.SLEEP

func _drilling_done():
	var global_drilling_pos = to_global(drilling_pos.position)
	var coord = cell.get_coord_from_pos(global_drilling_pos)
	print("DRILLING POS: ", global_drilling_pos)
	emit_signal("interact_at_coord", coord, utl.INTERACTION.REMOVE)

















