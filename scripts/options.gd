extends CanvasLayer


@export var restart_button: Button


#func _input(event: InputEvent) -> void:
#	if event.is_action_pressed("ui_cancel"):
#		GameManager.game_paused = !GameManager.game_paused


func _ready() -> void:
	
	pass


func _on_back_pressed() -> void:
	GameManager.resume_game()


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	GameManager.game_paused = false
	GameManager.is_in_game = false


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, value)


func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, value)


func _on_restart_pressed() -> void:
	GameManager.reset_level()


func _on_visibility_changed() -> void:
	if GameManager.is_in_game:
		restart_button.show()
	else:
		restart_button.hide()
