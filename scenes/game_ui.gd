extends CanvasLayer


@onready var grapple_uses: TextureProgressBar = $GrappleUses
@onready var grapple_uses_text: Label = $GrappleUses/Label
@onready var ability_uses_text: Label = $Ability/UsesLeft
@onready var ability_icon: TextureRect = $Ability
@onready var grapples_used: Label = $GrapplesUsed
@onready var player: Player = (get_tree().get_first_node_in_group("Player") as Player)
var ability_uses_left: int


func _ready() -> void:
	grapple_uses.max_value = PlayerStats.base_grapple_uses
	grapple_uses.value = PlayerStats.grapple_uses
	ability_uses_text.text = str(PlayerStats.ability_uses)
	PlayerStats.connect("grapple_uses_changed", _on_grapple_use_changed)
	PlayerStats.connect("ability_upgraded", ability_use_upgraded)


func set_icon() -> void:
	if GameManager.power_selected == Player.Powers.INCREASE_RANGE:
		ability_icon.texture = load("res://assets/uparrows.png")
	else:
		ability_icon.texture = load("res://assets/hook.png")


func _physics_process(_delta: float) -> void:
	if player.moving:
		set_score_text()


func set_score_text() -> void:
	$Container/Score/Label4.text = str(add_comma_to_int(GameManager.score))

func set_highscore_text() -> void:
	$Container/Highscore/Label3.text = str(add_comma_to_int(GameManager.highscore))

func set_upgrade_points_text() -> void:
	$UpgradePoints/Label.text = str(GameManager.upgrade_points)


func _on_grapple_use_changed(value: float) -> void:
	grapple_uses_text.text = str(PlayerStats.grapple_uses, "/", PlayerStats.base_grapple_uses)
	grapple_uses.max_value = PlayerStats.base_grapple_uses
	grapple_uses.value = PlayerStats.grapple_uses
	grapples_used.text = str("Total Grapples Used : ", GameManager.grapples_shot)


func ability_use_upgraded() -> void:
	ability_uses_text.text = str(PlayerStats.base_ability_uses)


func _on_player_used_ability() -> void:
	ability_uses_text.text = str(PlayerStats.ability_uses)


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
