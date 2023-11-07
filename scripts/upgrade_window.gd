extends CanvasLayer
# attach button signal to upgrades

signal upgrade_applied

@export var upgrade_increase_reach_range: int
@export var max_upgrade_reach_range: int
var current_reach_upgrades: int

@export var upgrade_increase_leap_speed: int
@export var max_upgrade_leap_speed: int
var current_leap_upgrades: int

@export var upgrade_increase_stamina: int
@export var max_upgrade_stamina: int
var current_stamina_upgrades: int

@export var upgrade_increase_grip_strength: int
@export var max_upgrade_grip_strength: int
var current_grip_upgrades: int

@export var upgrade_increase_power_uses: int
@export var max_upgrade_power_uses: int
var current_power_upgrades: int


func upgrade_reach_range() -> void:
	if current_reach_upgrades < max_upgrade_reach_range:
		PlayerStats.upgrade_reach_range(upgrade_increase_reach_range)
		emit_signal("upgrade_applied")
		current_reach_upgrades += 1

func upgrade_leap_speed() -> void:
	if current_leap_upgrades < max_upgrade_leap_speed:
		PlayerStats.upgrade_leap_speed(upgrade_increase_leap_speed)
		emit_signal("upgrade_applied")
		current_leap_upgrades += 1

func upgrade_stamina() -> void:
	if current_stamina_upgrades < max_upgrade_stamina:
		PlayerStats.upgrade_stamina_capacity(upgrade_increase_stamina)
		emit_signal("upgrade_applied")
		current_stamina_upgrades += 1

func upgrade_grip_strength() -> void:
	if current_grip_upgrades < max_upgrade_grip_strength:
		PlayerStats.upgrade_grip_strength(upgrade_increase_grip_strength)
		emit_signal("upgrade_applied")
		current_grip_upgrades += 1

func upgrade_power_uses() -> void:
	if current_power_upgrades < max_upgrade_power_uses:
		PlayerStats.upgrade_extra_power_use(upgrade_increase_power_uses)
		emit_signal("upgrade_applied")
		current_power_upgrades += 1
