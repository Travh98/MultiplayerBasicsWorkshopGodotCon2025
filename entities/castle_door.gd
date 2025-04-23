class_name CastleDoor
extends Node2D


@export var torch1: Torch
@export var torch2: Torch

@onready var anim_player: AnimationPlayer = $AnimationPlayer

@export var is_open: bool = false

func _ready():
	if not is_multiplayer_authority(): return
	
	if torch1 == null:
		push_warning("Forgot to set torch for castle door")
	if torch2 == null:
		push_warning("Forgot to set torch for castle door")


func _physics_process(_delta: float):
	if not is_multiplayer_authority(): return
	
	if is_open:
		return
	
	if torch1.is_lit and torch2.is_lit:
		anim_player.play("open_door")
		is_open = true
