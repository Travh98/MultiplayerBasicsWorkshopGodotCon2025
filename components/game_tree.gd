extends Node

@onready var gui_mgr: GuiMgr = $GuiMgr
@onready var server_interface: ServerInterface = $ServerInterface


func _ready():
	## Handle joining and hosting.
	## When GUI sees button presses to host or join, it signals to
	## the ServerInterface to take the IP and port and start connecting
	gui_mgr.gui_host_game.connect(server_interface.host_game)
	gui_mgr.gui_join_game.connect(server_interface.join_game)
