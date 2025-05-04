class_name ChatUI
extends Control

signal start_chat
signal stop_chat

@onready var chat_log: RichTextLabel = $MarginContainer/HBoxContainer/VBoxContainer/ChatLog
@onready var typing_msg_line_edit: LineEdit = $MarginContainer/HBoxContainer/VBoxContainer/TypingMsgLineEdit


func _ready():
	# Clear text
	chat_log.text = ""
	
	typing_msg_line_edit.editing_toggled.connect(on_editing_toggled)

	ServerChatRpc.msg_received.connect(receive_message)
	pass


func _physics_process(_delta: float):
	if Input.is_action_just_pressed("enter"):
		send_message()
		stop_chat.emit()
	
	if Input.is_action_just_pressed("start_chat"):
		start_chatting()
	


func start_chatting():
	typing_msg_line_edit.grab_focus()
	typing_msg_line_edit.edit()
	start_chat.emit()


func send_message():
	if typing_msg_line_edit.text.is_empty():
		return
	
	var msg: String = typing_msg_line_edit.text
	ServerChatRpc.receive_message.rpc(msg)
	
	typing_msg_line_edit.clear()


func receive_message(msg: String):
	chat_log.text += "\n" + msg


func on_editing_toggled(is_editing: bool):
	if is_editing:
		start_chat.emit()
	else:
		stop_chat.emit()
