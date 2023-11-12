extends CanvasLayer


@onready var grapple_uses: TextureProgressBar = $Stamina
@onready var grapple_uses_text: Label = $Stamina/Label
@onready var ability_uses_text: Label = $Ability/UsesLeft
var ability_uses_left: int


func _ready() -> void:
	grapple_uses.max_value = PlayerStats.base_stamina
	grapple_uses.value = PlayerStats.stamina
#	ability_uses_left = PlayerStats.ability_uses
	ability_uses_text.text = str(PlayerStats.ability_uses)
	PlayerStats.connect("stamina_changed", _on_stamina_value_changed)
	PlayerStats.connect("ability_upgraded", ability_use_upgraded)


func _process(_delta: float) -> void:
	pass


func _on_stamina_value_changed(value: float) -> void:
	grapple_uses.value = PlayerStats.stamina
	grapple_uses_text.text = str(grapple_uses.value, "/", PlayerStats.base_stamina)


func ability_use_upgraded() -> void:
#	ability_uses_left = PlayerStats.ability_uses
	ability_uses_text.text = str(PlayerStats.ability_uses)


func _on_player_used_ability() -> void:
#	ability_uses_left -= 1
	ability_uses_text.text = str(PlayerStats.ability_uses)
