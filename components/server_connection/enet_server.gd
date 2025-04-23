class_name EnetServer
extends Node

## Manages creating the ENet server (if you are hosting)

## Emits when the host needs a player character spawned for them
signal create_player_for_host()

## The port to host the server on
var port: int = 25026
## The max number of players that can be connected at once
var max_players: int = 64


## Creates a multiplayer peer and starts hosting a server
func start_server():
	# Create the server
	var network: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	network.create_server(port, max_players)
	
	# Store the peer in the Multiplayer Singleton
	multiplayer.multiplayer_peer = network
	
	print("Server started on port: ", str(port))
	
	create_player_for_host.emit()
