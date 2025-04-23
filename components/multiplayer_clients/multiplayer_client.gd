class_name MultiplayerClient
extends Node

## The object that holds each client's player entity.
## The name of this node will be the peer_id of the client.
## Use this for setting multiplayer peer on _enter_tree.

## The player entity for the client to control
@onready var player: Node = $Player


func _enter_tree():
	# Assign multiplayer authority to the ID of the player (parent)
	# Multiplayer authority is inherited by child nodes,
	# so by setting the authority of this MultiplayerClient,
	# then any entities under this will be owned by that client.
	var peer_id: int = str(name).to_int()
	set_multiplayer_authority(peer_id)
	pass


func _ready():
	var peer_id: int = str(name).to_int()
	player.name = str(peer_id)
	
	# Set the debug label on the player for seeing Peer ID 
	if player.has_node("PlayerController"):
		var player_controller: PlayerController = player.get_node("PlayerController")
		player_controller.peer_id_label.text = player.name
