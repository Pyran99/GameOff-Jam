extends CanvasLayer
# GLOBAL Options

@export var restart_button: Button


func _ready() -> void:
	
	pass


func _on_back_pressed() -> void:
	GameManager.resume_game()


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	GameManager.game_paused = false
	GameManager.is_in_game = false


func _on_music_slider_value_changed(value: float) -> void:
	if value <= -40:
		value = -80
	AudioServer.set_bus_volume_db(1, value)


func _on_sfx_slider_value_changed(value: float) -> void:
	if value <= -40:
		value = -80
	AudioServer.set_bus_volume_db(2, value)


func _on_restart_pressed() -> void:
	GameManager.selected_new_run = true
	GameManager.game_over()


func _on_visibility_changed() -> void:
	if GameManager.is_in_game:
		restart_button.show()
	else:
		restart_button.hide()
