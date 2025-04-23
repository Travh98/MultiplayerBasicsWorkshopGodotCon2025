class_name ServerInterface
extends Node

## Manages all high-level networking nodes

signal connected_to_server()
signal disconnected_from_server()

@onready var enet_server: EnetServer = $EnetServer
@onready var server_connector: ServerConnector = $ServerConnector
@onready var ping_mgr: PingMgr = $PingMgr
@onready var connection_timeout: ConnectionTimeout = $ConnectionTimeout


func _ready():
	connection_timeout.lost_heartbeat_connection.connect(server_connector.disconnect_from_server)
	server_connector.server_connection_changed.connect(ping_mgr.on_server_connection_changed)
	server_connector.server_connection_changed.connect(server_connection_changed)


func host_game(port: int):
	enet_server.port = port
	enet_server.start_server()


func join_game(ip: String, port: int):
	server_connector.host_ip = ip
	server_connector.port = port
	server_connector.connect_to_server()


func server_connection_changed(is_server_connected: bool):
	if not is_server_connected:
		disconnected_from_server.emit()
	else:
		connected_to_server.emit()
