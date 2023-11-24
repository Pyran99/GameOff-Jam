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

var power_selected: Player.Powers

var is_in_game: bool = false

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


var upgrade_points: int = 0:
	get:
		return upgrade_points

@onready var player =  get_tree().get_first_node_in_group("Player")
@onready var options = get_node("/root/Options")


func set_highscore() -> void:
	if score > highscore:
		highscore = score


func set_score(value: int) -> void:
	score = value


func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	game_paused = false


func _process(_delta: float) -> void:
	pass


func game_over() -> void:
	get_tree().get_first_node_in_group("Upgrade").show()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		game_paused = !game_paused


func reset_points() -> void:
	upgrade_points = 0
	highscore = 0
	score = 0


func start_game() -> void:
	(get_node("/root/Game/AudioStreamPlayer2D") as AudioStreamPlayer2D).play(0)


func reset_level() -> void:
	player = (get_tree().get_first_node_in_group("Player") as Player)
	player.check_for_hook()
	player.global_position = Vector2.ZERO
	player.can_click_platform = true
	player.can_play = true
	score = 0
	PlayerStats.grapple_uses = PlayerStats.base_grapple_uses
	get_tree().get_first_node_in_group("UI")._on_grapple_use_changed(0)
	PlayerStats.ability_uses = PlayerStats.base_ability_uses
	get_tree().get_first_node_in_group("UI")._on_player_used_ability()
	get_tree().get_first_node_in_group("Upgrade").hide()
	game_paused = false
	is_in_game = true


func _on_back_pressed() -> void:
	resume_game()


func resume_game() -> void:
	game_paused = false


func pause_game() -> void:
	game_paused = true


func increase_upgrade_points(value: int) -> void:
	upgrade_points += value


func decrease_upgrade_points() -> void:
	upgrade_points -= 1
