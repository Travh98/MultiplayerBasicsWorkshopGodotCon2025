extends Node

@onready var gui_mgr: GuiMgr = $GuiMgr
@onready var server_interface: ServerInterface = $ServerInterface
@onready var enet_server: EnetServer = $ServerInterface/EnetServer
@onready var players_mgr: PlayersMgr = $PlayersMgr


func _ready():
	## Handle joining and hosting.
	## When GUI sees button presses to host or join, it signals to
	## the ServerInterface to take the IP and port and start connecting
	gui_mgr.gui_host_game.connect(server_interface.host_game)
	gui_mgr.gui_join_game.connect(server_interface.join_game)
	
	# Spawn a player for the host if hosting
	enet_server.create_player_for_host.connect(players_mgr.spawn_player_for_host)
