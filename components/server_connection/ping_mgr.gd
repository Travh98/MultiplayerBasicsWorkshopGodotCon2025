class_name PingMgr
extends Node

## Manages pinging the server and ping calculations

signal ping_calculated(ping: float)

## Timer for periodically pinging
@onready var ping_timer: Timer = Timer.new()

## Track when the ping is started to see how long it takes to reach
var ping_start_time_msec: float 
## Report ping to the server after getting this many pings 
var report_ping_interval: int = 6
## Track the number of pings received since we have reported to server
var num_pings_since_reporting: int = 0
## How often to ping the server
var ping_interval_secs: float = 2.5


func _ready():
	# Receive pongs when the Server responds to our pings
	ServerPingRpcs.recieve_pong.connect(receive_pong)
	
	# Set up ping timer to periodically send pings
	# Pinging shouldn't take up a lot of bandwidth
	add_child(ping_timer)
	ping_timer.wait_time = ping_interval_secs
	ping_timer.one_shot = false
	ping_timer.timeout.connect(start_ping)


## Start periodically sending pings
func begin_pinging():
	ping_timer.start()


## Stop periodically sending pings
func stop_pinging():
	ping_timer.stop()


## Send a ping to the server
func start_ping():
	ping_start_time_msec = Time.get_ticks_msec()
	# Ping the server, telling it who to respond to
	ServerPingRpcs.ping_to_server.rpc_id(1, multiplayer.multiplayer_peer.get_unique_id())


## Share your ping with the server so they know how healthy the connection is
## to each connected client.
func report_ping(_ping: float):
	#Server.report_ping_to_server.rpc_id(1, multiplayer.multiplayer_peer.get_unique_id(), ping)
	pass


## Receive a pong from the server and calculate the ping time
func receive_pong():
	var ping: float = Time.get_ticks_msec() - ping_start_time_msec
	ping_calculated.emit(ping)
	
	# Report every couple pings to the server
	# so that the server knows how good your connection is
	if num_pings_since_reporting > report_ping_interval:
		report_ping(ping)
		num_pings_since_reporting = 0
	num_pings_since_reporting += 1


## Start or stop pinging based on the server connection
func on_server_connection_changed(connected: bool):
	if connected:
		begin_pinging()
	else:
		stop_pinging()
