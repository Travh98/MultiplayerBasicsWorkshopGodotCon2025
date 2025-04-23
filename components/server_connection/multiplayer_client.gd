class_name MultiplayerClient
extends Node3D

## The object that holds each client's player entity.
## The name of this node will be the peer_id of the client.
## Use this for setting multiplayer peer on _enter_tree.

## The player entity for the client to control
@onready var player: CharacterBody3D = $Player


func _enter_tree():
	# Assign multiplayer authority to the ID of the player (parent)
	var peer_id: int = str(name).to_int()
	set_multiplayer_authority(peer_id)
	pass


func _ready():
	var peer_id: int = str(name).to_int()
	player.name = str(peer_id)
	
	# Set the debug label on the player for seeing Peer ID 
	if player.has_node("PeerIdLabel"):
		player.get_node("PeerIdLabel").text = player.name
