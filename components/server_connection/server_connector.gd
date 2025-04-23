class_name ServerConnector
extends Node

## Manages connection to an ENet server (as a client)

## Emits when the connection to the server has changed
signal server_connection_changed(connected: bool)
## Emits when we fail to connect to the server
signal connection_failed_after_secs(secs: float)

## IP of the server host to connect to
var host_ip: String = "localhost"
## Port on the server host to connect to
var port: int = 25026
## Unix time in seconds, from when we last tried joining the server
var last_join_attempt_time_secs: float
## True if we are connected to the server
var is_server_connected: bool = false : set = set_server_connection_changed


## Set the host and port that we will connect to
func set_server_connection_info(h: String, p: int):
	if !h.is_empty():
		host_ip = h
	if p > 1023 && p < 65535:
		port = p


## Create a multiplayer peer and start connecting to the server
func connect_to_server():
	var network: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	last_join_attempt_time_secs = Time.get_unix_time_from_system()
	network.create_client(host_ip, port)
	multiplayer.multiplayer_peer = network
	
	multiplayer.connection_failed.connect(on_connection_failed)
	multiplayer.connected_to_server.connect(on_connection_success)


## Disconnects from the server
func disconnect_from_server():
	#GameMgr.game_tree.player_mgr.delete_all_players()
	if not is_server_connected:
		return
	is_server_connected = false
	print("Disconnected from server")
	
	if multiplayer.multiplayer_peer:
		multiplayer.connection_failed.disconnect(on_connection_failed)
		multiplayer.connected_to_server.disconnect(on_connection_success)
		multiplayer.multiplayer_peer = null


## Handles when we fail to connect to the server
func on_connection_failed():
	is_server_connected = false
	var time_spent_joining: float = Time.get_unix_time_from_system() - last_join_attempt_time_secs
	print("Connection failed after ", str(time_spent_joining), " seconds.")
	connection_failed_after_secs.emit(time_spent_joining)
	#GameMgr.game_tree.gui_mgr.on_connection_failed()
	disconnect_from_server()


## Handles when connection to server succeeds
func on_connection_success():
	is_server_connected = true
	print("Client successfully connected!")
	#GameMgr.game_tree.gui_mgr.on_connection_success()


## Handles updating the server connection status
func set_server_connection_changed(c: bool):
	if is_server_connected != c:
		is_server_connected = c
		server_connection_changed.emit(c)
