extends Control


func _ready() -> void:
	$VBoxContainer/Start.grab_focus()
	# connect power choice buttons to game manager
	
	# player gets choice from game manager on spawn


func _on_start_pressed() -> void:
	# show menu to choose powerup
	$Container.show()
	$VBoxContainer.hide()


func start_game() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_options_pressed() -> void:
	GameManager.game_paused = true


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	GameManager.game_paused = false


func _on_texture_button_pressed() -> void:
	GameManager.power_selected = Player.Powers.INCREASE_RANGE
	start_game()


func _on_texture_button_2_pressed() -> void:
	GameManager.power_selected = Player.Powers.REGEN_STAMINA
	start_game()
