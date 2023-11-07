extends Control


func _ready() -> void:
	$VBoxContainer/Start.grab_focus()


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_options_pressed() -> void:
	$Options.visible = true


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	$Options.visible = false
