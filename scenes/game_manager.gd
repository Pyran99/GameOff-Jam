extends Node
class_name GameManager

# on game start show power select window
# start game after selecting power
#
# upon running out of stamina or falling from grip\
# show upgrade window with *stars* collected, available upgrades,\
# a restart button and a main menu button
# warning on menu button to say progress is lost

signal toggle_game_paused(is_paused: bool)

var options_shown: bool = false

var game_paused: bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		$Options.visible = game_paused
		emit_signal("toggle_game_paused", game_paused)


func _ready() -> void:
	
	pass


func _process(_delta: float) -> void:
	
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		game_paused = !game_paused
#		$Options.visible = true


func _on_back_pressed() -> void:
	resume_game()
	$Options.visible = false


func resume_game() -> void:
	game_paused = false
	pass


func pause_game() -> void:
	game_paused = true
	pass
