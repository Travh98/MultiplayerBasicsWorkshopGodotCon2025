class_name GuiMgr
extends Node

## Emitted when the GUI wants to host a game
signal gui_host_game(port: int)
## Emitted when the GUI wants to join a game
signal gui_join_game(ip: String, port: int)

@onready var start_connect_menu: StartConnectMenu = $StartConnectMenu


func _ready():
	start_connect_menu.start_host_server.connect(on_start_menu_host_game)
	start_connect_menu.start_join_server.connect(on_start_menu_join_game)


func on_start_menu_host_game(port: int):
	gui_host_game.emit(port)
	start_connect_menu.visible = false


func on_start_menu_join_game(ip: String, port: int):
	gui_join_game.emit(ip, port)
	start_connect_menu.visible = false
