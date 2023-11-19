extends CanvasLayer



#func _input(event: InputEvent) -> void:
#	if event.is_action_pressed("ui_cancel"):
#		GameManager.game_paused = !GameManager.game_paused


#func _ready() -> void:
#	visible = false


func _on_back_pressed() -> void:
	GameManager.resume_game()


func _on_main_menu_pressed() -> void:
#	GameManager.reset_level() # TODO: replace with main menu
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	GameManager.game_paused = false


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, value)


func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, value)
