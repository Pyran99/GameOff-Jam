extends CanvasLayer
# attach button signal to upgrades

signal upgrade_applied

@export var grapple_label: Label
@export var upgrade_increase_grapple_range: int
@export var max_upgrade_grapple_range: int
var current_grapple_range_upgrades: int

@export var grapple_speed_label: Label
@export var upgrade_increase_grapple_speed: int
@export var max_upgrade_grapple_speed: int
var current_grapple_speed_upgrades: int

@export var grapple_uses_label: Label
@export var upgrade_increase_grapple_uses: int
@export var max_upgrade_grapple_uses: int
var current_grapple_uses_upgrades: int

@export var grip_label: Label
@export var upgrade_increase_grip_strength: int
@export var max_upgrade_grip_strength: int
var current_grip_upgrades: int

@export var ability_label: Label
@export var upgrade_increase_ability_uses: int
@export var max_upgrade_ability_uses: int
var current_ability_upgrades: int


func _ready() -> void:
	grapple_label.text = str(current_grapple_range_upgrades, "/", max_upgrade_grapple_range)
	grapple_speed_label.text = str(current_grapple_speed_upgrades, "/", max_upgrade_grapple_speed)
	grapple_uses_label.text = str(current_grapple_uses_upgrades, "/", max_upgrade_grapple_uses)
	grip_label.text = str(current_grip_upgrades, "/", max_upgrade_grip_strength)
	ability_label.text = str(current_ability_upgrades, "/", max_upgrade_ability_uses)
	$Panel/Button.connect("pressed", GameManager.reset_level)


func upgrade_grapple_range() -> void:
	if current_grapple_range_upgrades < max_upgrade_grapple_range:
		if upgrade():
			PlayerStats.upgrade_grapple_range(upgrade_increase_grapple_range)
			emit_signal("upgrade_applied")
			current_grapple_range_upgrades += 1
			grapple_label.text = str(current_grapple_range_upgrades, "/", max_upgrade_grapple_range)

func upgrade_grapple_speed() -> void:
	if current_grapple_speed_upgrades < max_upgrade_grapple_speed:
		if upgrade():
			PlayerStats.upgrade_grapple_speed(upgrade_increase_grapple_speed)
			emit_signal("upgrade_applied")
			current_grapple_speed_upgrades += 1
			grapple_speed_label.text = str(current_grapple_speed_upgrades, "/", max_upgrade_grapple_speed)

func upgrade_grapple_use_amount() -> void:
	if current_grapple_uses_upgrades < max_upgrade_grapple_uses:
		if upgrade():
			PlayerStats.upgrade_grapple_uses_capacity(upgrade_increase_grapple_uses)
			emit_signal("upgrade_applied")
			current_grapple_uses_upgrades += 1
			grapple_uses_label.text = str(current_grapple_uses_upgrades, "/", max_upgrade_grapple_uses)

func upgrade_grip_strength() -> void:
	if current_grip_upgrades < max_upgrade_grip_strength:
		if upgrade():
			PlayerStats.upgrade_grip_strength(upgrade_increase_grip_strength)
			emit_signal("upgrade_applied")
			current_grip_upgrades += 1
			grip_label.text = str(current_grip_upgrades, "/", max_upgrade_grip_strength)

func upgrade_power_uses() -> void:
	if current_ability_upgrades < max_upgrade_ability_uses:
		if upgrade():
			PlayerStats.upgrade_extra_power_use(upgrade_increase_ability_uses)
			emit_signal("upgrade_applied")
			current_ability_upgrades += 1
			ability_label.text = str(current_ability_upgrades, "/", max_upgrade_ability_uses)


func upgrade() -> bool:
	if GameManager.upgrade_points > 0:
		GameManager.decrease_upgrade_points()
		return true
	else:
		return false


func _on_upgrades_button_pressed() -> void:
	$Panel.show()
	$Panel2.hide()


func _on_menu_button_pressed() -> void:
	# go back to main menu
	
	pass
