extends Node

@export var menus: Dictionary[GameTypes.MenuState, PackedScene];
var current_menu: Control = null;

func load_menu(state: GameTypes.MenuState) -> void:
	if current_menu != null:
		current_menu.hide()
		current_menu.queue_free()
	
	current_menu = menus[state].instantiate()
	add_child(current_menu)
	
