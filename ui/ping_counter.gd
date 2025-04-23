extends HBoxContainer

## Displays Ping

@onready var ping_label: Label = $PingLabel

func _ready():
	ClientGlobals.ping_calculated.connect(on_ping_update)
	
	if is_multiplayer_authority():
		ping_label.text = "[host]"
	
	pass


func on_ping_update(p: float):
	ping_label.text = str(p).pad_decimals(0)
	if p < 20:
		ping_label.modulate = Color.WHITE
	elif p < 50:
		ping_label.modulate = Color.YELLOW
	elif p < 100:
		ping_label.modulate = Color.ORANGE
	else:
		ping_label.modulate = Color.RED
