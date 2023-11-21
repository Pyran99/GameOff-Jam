extends Node

@export var description: CanvasLayer
@export var start_button: Button

func _ready() -> void:
	description.show()
	start_button.connect("pressed", _button_pressed)
#	GameManager.game_paused = true


func _button_pressed() -> void:
	description.hide()
	get_tree().get_first_node_in_group("Player").can_play = true
