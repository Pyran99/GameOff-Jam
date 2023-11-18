extends Node
#class_name GameManager

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
#		$root/Game/Options.visible = game_paused
		options.visible = game_paused
#		get_node("/root/Game/Options").visible = game_paused
		emit_signal("toggle_game_paused", game_paused)

var highscore: int
var score: int:
	get:
		return score
var player_is_moving: bool = false:
	get:
		return player_is_moving
	set(value):
		player_is_moving = value

var upgrade_points: int = 0:
	get:
		return upgrade_points

@onready var player =  get_tree().get_first_node_in_group("Player")
@onready var options = get_node("/root/Game/Options")


func set_highscore() -> void:
	if score > highscore:
		highscore = score


func set_score() -> void:
	score = -player.global_position.y


func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	(get_node("/root/Game/AudioStreamPlayer2D") as AudioStreamPlayer2D).play(0)
	
	pass


func _process(_delta: float) -> void:
	if player_is_moving:
		set_score()
	if PlayerStats.grapple_uses <= 0:
		# show upgrade window with button for new run
		get_tree().get_first_node_in_group("Upgrade").show()
		# new run button sets player back to 0 position
		
#		reset_level()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		game_paused = !game_paused
#		options.visible = true


func reset_level() -> void:
	# set player position back to 0
	player.global_position = Vector2.ZERO
	PlayerStats.grapple_uses = PlayerStats.base_grapple_uses
	get_tree().get_first_node_in_group("UI")._on_grapple_use_changed(0)


func _on_back_pressed() -> void:
	resume_game()
#	$Options.visible = false
#	options.visible = false


func resume_game() -> void:
	game_paused = false
#	options.visible = false


func pause_game() -> void:
	game_paused = true
#	options.visible = true


func increase_upgrade_points(value: int) -> void:
	upgrade_points += value


func decrease_upgrade_points() -> void:
	upgrade_points -= 1
