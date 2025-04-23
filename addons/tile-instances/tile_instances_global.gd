# res://globals.gd added as an autoload

extends Node

var window_margin_gap: int = 0 # pixels

func _ready() -> void:
	EngineDebugger.register_message_capture("tile-instances", _on_tile_instances)
	EngineDebugger.send_message.call_deferred("tile-instances:get_id", [])


func _on_tile_instances(message:String, data:Array) -> bool:
	match message:
		"session_id":
			var info:Dictionary = data[0]
			var id = info.get("id", -1)
			var all = info.get("all", [])
			#print(info)
			if all.size() > 1:
				for i in all.size():
					var other = all[i]
					if other == id:
						tile_window(i, all.size())
	
			return true
	
	return false


func tile_window(i:int, total:int) -> void:
	var window = get_window()
	var screen = window.current_screen
	var screen_rect = DisplayServer.screen_get_usable_rect(screen)
	var window_rect = window.get_visible_rect()
	#print(window_rect, screen_rect)
	match total:
		2:
			window.position.x = (screen_rect.size.x / 2 - window_rect.size.x / 2)
			window.position.y = (screen_rect.size.y / 2 - window_rect.size.y / 2)
			if i == 1:
				window.position.x -= window_rect.size.x / 2 + window_margin_gap
			else:
				window.position.x += window_rect.size.x / 2 + window_margin_gap
		3:
			# Set the location of each window (i)
			match i:
				0:
					window.position.x = (screen_rect.size.x / 2 - window_rect.size.x / 2)
					window.position.x -= window_rect.size.x / 2 + window_margin_gap
					window.position.y = (screen_rect.size.y / 2 - window_rect.size.y / 2)
					window.position.y -= window_rect.size.y / 2 + window_margin_gap
					pass
				1:
					window.position.x = (screen_rect.size.x / 2 - window_rect.size.x / 2)
					window.position.x += window_rect.size.x / 2 + window_margin_gap
					window.position.y = (screen_rect.size.y / 2 - window_rect.size.y / 2)
					window.position.y -= window_rect.size.y / 2 + window_margin_gap
					pass
				2:
					window.position.x = (screen_rect.size.x / 2 - window_rect.size.x / 2)
					window.position.x += window_rect.size.x / 2 + window_margin_gap
					window.position.y = (screen_rect.size.y / 2 - window_rect.size.y / 2)
					window.position.y += window_rect.size.y / 2 + window_margin_gap
					pass
			pass
		4:
			pass
