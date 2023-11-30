extends CanvasLayer

@export var score_node: Control
@export var grapples_used_text: Label
@export var score_text: Label
@export var final_score_text: Label

@export var grapples_shot_value: Label
@export var score_value: Label
@export var final_score_value: Label

var final_score: int


func _ready() -> void:
	grapples_used_text.hide()
	score_text.hide()
	final_score_text.hide()
	$Timer.start(1)
	$Timer2.start(2)
	$Timer3.start(3)


func show_grapple_used_text() -> void:
	grapples_shot_value.text = str(GameManager.grapples_shot)
	grapples_used_text.show()


func show_score() -> void:
	score_value.text = str(add_comma_to_int(GameManager.highscore), " - (", GameManager.grapples_shot, " * 50)")
	score_text.show()


func show_final_score() -> void:
	final_score = GameManager.highscore - (GameManager.grapples_shot * 50)
	final_score_value.text = str(add_comma_to_int(final_score))
	final_score_text.show()


func add_comma_to_int(value: int) -> String:
	# Convert value to string.
	var str_value: String = str(value)
	
	# Check if the value is positive or negative.
	# Use index 0(excluded) if positive to avoid comma before the 1st digit.
	# Use index 1(excluded) if negative to avoid comma after the - sign.
	var loop_end: int = 0 if value > -1 else 1
	
	# Loop backward starting at the last 3 digits,
	# add comma then, repeat every 3rd step.
	for i in range(str_value.length()-3, loop_end, -3):
		str_value = str_value.insert(i, ",")
	
	# Return the formatted string.
	return str_value


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	GameManager.game_paused = false
	GameManager.is_in_game = false


func _on_timer_timeout() -> void:
	show_grapple_used_text()

func _on_timer_2_timeout() -> void:
	show_score()

func _on_timer_3_timeout() -> void:
	show_final_score()
