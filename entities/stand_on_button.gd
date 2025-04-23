class_name StandOnButton
extends Node2D

signal pressed(button_pressed: bool)

@onready var detect_stander_area: Area2D = $DetectStanderArea
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var is_pressed: bool = false


func _ready():
	if not is_multiplayer_authority(): return
	
	detect_stander_area.body_entered.connect(on_body_entered)
	detect_stander_area.body_exited.connect(on_body_exited)
	
	# Look for players in the area
	detect_stander_area.set_collision_mask_value(2, true)
	pass


func on_body_entered(body: Node2D):
	if not is_multiplayer_authority(): return
	
	if body == null:
		return
	
	if detect_stander_area.get_overlapping_bodies().size() > 0:
		is_pressed = true
		pressed.emit(is_pressed)
		anim_player.play("spin_button")


func on_body_exited(body: Node2D):
	if not is_multiplayer_authority(): return
	
	if detect_stander_area.get_overlapping_bodies().size() == 0:
		is_pressed = false
		pressed.emit(is_pressed)
		anim_player.pause()
