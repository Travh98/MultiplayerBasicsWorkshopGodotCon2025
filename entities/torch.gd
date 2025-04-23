class_name Torch
extends Node2D

@export var button: StandOnButton

@onready var flame_sprite: Sprite2D = $FlameSprite

var is_lit: bool = false

func _ready():
	if not is_multiplayer_authority(): return
	
	if button == null:
		push_warning("Forgot to set button for torch")
	
	button.pressed.connect(on_button_toggled)


func on_button_toggled(is_pressed: bool):
	flame_sprite.visible = is_pressed
	is_lit = is_pressed
