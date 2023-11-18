extends CanvasLayer


@onready var grapple_uses: TextureProgressBar = $GrappleUses
@onready var grapple_uses_text: Label = $GrappleUses/Label
@onready var ability_uses_text: Label = $Ability/UsesLeft
var ability_uses_left: int


func _ready() -> void:
	grapple_uses.max_value = PlayerStats.base_grapple_uses
	grapple_uses.value = PlayerStats.grapple_uses
#	ability_uses_left = PlayerStats.ability_uses
	ability_uses_text.text = str(PlayerStats.ability_uses)
	PlayerStats.connect("grapple_uses_changed", _on_grapple_use_changed)
	PlayerStats.connect("ability_upgraded", ability_use_upgraded)


func _process(_delta: float) -> void:
	$Container/Score/Label4.text = str(GameManager.score)
	$Container/Highscore/Label3.text = str(GameManager.highscore)
	$UpgradePoints/Label.text = str(GameManager.upgrade_points)


func _on_grapple_use_changed(value: float) -> void:
#	grapple_uses.value = PlayerStats.grapple_uses
	grapple_uses_text.text = str(PlayerStats.grapple_uses, "/", PlayerStats.base_grapple_uses)
	grapple_uses.max_value = PlayerStats.base_grapple_uses
	grapple_uses.value = PlayerStats.grapple_uses


func ability_use_upgraded() -> void:
#	ability_uses_left = PlayerStats.ability_uses
	ability_uses_text.text = str(PlayerStats.ability_uses)


func _on_player_used_ability() -> void:
#	ability_uses_left -= 1
	ability_uses_text.text = str(PlayerStats.ability_uses)
