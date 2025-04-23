class_name PlayersMgr
extends Node

## Spawns the players that connect
##
## Spawned players will be a child of this node

## Emits when a character is spawned for a connected peer
signal spawned_character(peer_id: int)
## Emits when a character is despawned for a newly disconnected peer
signal despawned_character(peer_id: int)

## The Multiplayer Spawner that spawns our local client
@onready var multiplayer_spawner: MultiplayerSpawner = $"../MultiplayerSpawner"

## Scene to instantiate for each player
#const PLAYER = preload("res://entities/player.tscn")
const MULTIPLAYER_CLIENT = preload("res://components/multiplayer_clients/multiplayer_client.tscn")


## Dictionary of player nodes, keyed by peer_id
var player_nodes: Dictionary = {}


func _ready():
	multiplayer.peer_connected.connect(on_peer_connected)
	multiplayer.peer_disconnected.connect(on_peer_disconnected)
	
	multiplayer_spawner.spawned.connect(register_local_player)


## Creates a player character when a peer is connected
func on_peer_connected(peer_id: int):
	add_player_character(peer_id)


## Removes a player character when the peer is disconnected
func on_peer_disconnected(peer_id: int):
	remove_player_character(peer_id)


## Instantiates a new character for this peer
func add_player_character(peer_id):
	# Spawn a new character for this player to control
	var player_character = MULTIPLAYER_CLIENT.instantiate()
	
	# Set the player character's name to the peer_id of the Player who owns it
	player_character.name = str(peer_id)
	
	# Store player character node by their peer id
	player_nodes[peer_id] = player_character
	
	print("Spawning player character for peer: ", str(peer_id))
	
	# Players will be a child of this PlayersMgr node
	add_child(player_character)
	
	spawned_character.emit(peer_id)


## Removes the player character for this peer
func remove_player_character(peer_id):
	# Remove player character from stored dictionary of character nodes
	player_nodes.erase(peer_id)
	
	# Find and despawn the character that peer is controlling
	var player_character = get_node_or_null(str(peer_id))
	if player_character:
		player_character.queue_free()
		despawned_character.emit(peer_id)


## Spawns a player specifically for the client that is hosting the game
func spawn_player_for_host():
	# Add a character for the Host to own and control
	print("Adding player character for the host: ", multiplayer.get_unique_id())
	add_player_character(multiplayer.get_unique_id())
	
	#print("Host is requesting for their name to be ", ClientGlobals.client_name)
	#ServerPlayerDataRpcs.request_update_player_data.rpc_id(1, 
		#multiplayer.get_unique_id(), 
		#PlayerDataMgr.PlayerDataKeys.PD_NAME, 
		#ClientGlobals.client_name)


## Registers this local player into our player_nodes.
## This is needed since the client's local player is automatically spawned
## by MultiplayerSpawner, therefore it does not go through our
## add_player_character function.
func register_local_player(local_player: Node):
	player_nodes[multiplayer.get_unique_id()] = local_player
