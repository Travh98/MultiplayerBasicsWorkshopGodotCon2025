class_name ConnectionTimeout
extends Node

## Watches pings and disconnects from server if pings stop

## Emits when we lost connection to the server
signal lost_heartbeat_connection

@export var num_pings_missed_before_disconnect: float = 2.5

@onready var ping_mgr: PingMgr = $"../PingMgr"
@onready var heartbeat_timer: Timer = Timer.new()

func _ready():
	# If we miss enough pings, then we have lost connection
	add_child(heartbeat_timer)
	heartbeat_timer.wait_time = ping_mgr.ping_interval_secs * num_pings_missed_before_disconnect
	heartbeat_timer.one_shot = true
	heartbeat_timer.timeout.connect(on_heartbeat_timeout)
	
	# Restart the heartbeat timer whenever a ping is received
	ping_mgr.ping_calculated.connect(on_ping_received)
	pass


## Handle when a ping-response is received from the server
func on_ping_received(_ping: float):
	# Start or reset heartbeat timer
	heartbeat_timer.start()


## Handle when we haven't gotten a response from the server
func on_heartbeat_timeout():
	print("Lost connection heartbeat!!")
	lost_heartbeat_connection.emit()
