class_name StartConnectMenu
extends Control



signal start_join_server(ip: String, port: int)
signal start_host_server(port: int)

@onready var player_name_edit: LineEdit = $MarginContainer/VBoxContainer/HBoxContainer2/PlayerNameEdit
@onready var host_port: LineEdit = $MarginContainer/VBoxContainer/HBoxContainer/GridContainer/HostPort
@onready var host_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/GridContainer/HostButton
@onready var join_ip: LineEdit = $MarginContainer/VBoxContainer/HBoxContainer/GridContainer/JoinIp
@onready var join_port: LineEdit = $MarginContainer/VBoxContainer/HBoxContainer/GridContainer/JoinPort
@onready var join_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/GridContainer/JoinButton


func _ready():
	host_button.pressed.connect(on_host_server)
	join_button.pressed.connect(on_join_server)


func on_host_server():
	set_player_name()
	start_host_server.emit(host_port.text.to_int())
	pass


func on_join_server():
	set_player_name()
	start_join_server.emit(join_ip.text, join_port.text.to_int())
	pass


func set_player_name():
	if player_name_edit.text.is_empty():
		ClientGlobals.client_name = "silly" + str(randi_range(0, 10))
	else:
		ClientGlobals.client_name = player_name_edit.text
