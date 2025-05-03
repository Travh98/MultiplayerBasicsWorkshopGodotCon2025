extends Node

## Autoloaded script that holds RPC functions
## for sending and receiving chat messages

signal msg_received(msg: String)


## Call this function on the peer's computer to
## make them receive your message
func receive_message(msg: String):
	msg_received.emit(msg)
	pass

## An RPC function is a function that you can call
## on someone else's computer.
##
## any_peer means anyone can call it, not just the host
## reliable mean that this message will send until the
## receiver gets the message and says that they got it
## call_local means that this function will run on their 
## computer and also on this computer too
