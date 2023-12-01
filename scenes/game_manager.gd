extends Node
# GLOBAL GameManager


signal toggle_game_paused(is_paused: bool)

var broken_ledge_array: Array

var power_selected: Player.Powers

var is_in_game: bool = false
var selected_new_run: bool = false

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
var grapples_shot: int

var upgrade_points: int = 0:
	get:
		return upgrade_points

var win_screen: PackedScene = preload("res://scenes/win_screen.tscn")

@onready var player = (get_tree().get_first_node_in_group("Player") as Player)
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


func grapple_shot() -> void:
	grapples_shot += 1


func game_win() -> void:
	var win = win_screen.instantiate()
	get_tree().get_first_node_in_group("Game").add_child(win)


func game_over() -> void:
	(get_tree().get_first_node_in_group("Player") as Player).can_play = false
	var upgrade_window = get_tree().get_first_node_in_group("Upgrade")
	game_paused = false
	if !selected_new_run:
		upgrade_window.show()
	else:
		upgrade_window.show()
		upgrade_window._on_upgrades_button_pressed()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		game_paused = !game_paused


func reset_points() -> void:
	upgrade_points = 0
	highscore = 0
	score = 0
	grapples_shot = 0


func start_game() -> void:
#	(get_node("/root/Game/AudioStreamPlayer2D") as AudioStreamPlayer2D).play(0)
	get_tree().get_first_node_in_group("UI").set_icon()
	get_broken_ledges()


func get_broken_ledges() -> void:
	broken_ledge_array = get_tree().get_nodes_in_group("LedgeBroken")

func show_broken_platforms() -> void:
	for i in broken_ledge_array:
		i.show_platform()

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
	selected_new_run = false
	show_broken_platforms()


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
