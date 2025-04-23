class_name PlayerController
extends Node

## Controls the player character.

@onready var player: CharacterBody2D = $".."
@onready var anim_player: AnimationPlayer = $"../AnimationPlayer"
@onready var player_name_label: Label = $"../PanelContainer/MarginContainer/VBoxContainer/PlayerNameLabel"
@onready var peer_id_label: Label = $"../PanelContainer/MarginContainer/VBoxContainer/PeerIdLabel"
@onready var camera_2d: Camera2D = $"../Camera2D"


## Speed of the player in pixels per second
@export var speed: float = 200.0


func _ready():
	if not is_multiplayer_authority(): return
	camera_2d.make_current()
	pass


func _physics_process(_delta: float):
	if not is_multiplayer_authority(): return
	
	var direction: Vector2 = Input.get_vector("move_left", "move_right", 
		"move_up", "move_down").normalized()
	
	player.velocity = direction * speed
	player.move_and_slide()
	
	if player.velocity.length() > 0.1:
		anim_player.play("walking")
	else:
		anim_player.play("idle")
