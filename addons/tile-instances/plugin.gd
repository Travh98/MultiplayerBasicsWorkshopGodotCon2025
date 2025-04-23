# res://addons/tile-instances/plugin.gd

@tool
extends EditorPlugin

var tile_instances = preload("res://addons/tile-instances/tile_instances.gd").new()

func _enter_tree():
		add_debugger_plugin(tile_instances)

func _exit_tree():
		remove_debugger_plugin(tile_instances)
