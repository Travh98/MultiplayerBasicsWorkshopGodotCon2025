class_name PlayerController
extends Node

## Controls the player character.

@onready var player: CharacterBody2D = $".."
@onready var anim_player: AnimationPlayer = $"../AnimationPlayer"
@onready var player_name_label: Label = $"../PanelContainer/MarginContainer/PlayerNameLabel"

## Speed of the player in pixels per second
@export var speed: float = 200.0


func _ready():
	pass


func _physics_process(_delta: float):
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", 
		"move_down").normalized()
	
	player.velocity = direction * speed
	player.move_and_slide()
	
	if player.velocity.length() > 0.1:
		anim_player.play("walking")
	else:
		anim_player.play("idle")
