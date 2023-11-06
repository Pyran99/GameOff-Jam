extends Node
# GLOBAL PlayerStats

@export var base_reach_range: int = 400
@export var base_leap_speed: int = 300
@export var base_stamina: int = 100
@export var base_grip_strength: int = 10
@export var base_ability_uses: int = 1
var reach_range: int
var leap_speed: int
var stamina: int
var grip_strength: int
var ability_uses: int

func _ready() -> void:
	reach_range = base_reach_range
	leap_speed = base_leap_speed
	stamina = base_stamina
	grip_strength = base_grip_strength
	ability_uses = base_ability_uses


func upgrade_reach_range(value: int) -> void:
	# increase reach range
	reach_range += value
	print(reach_range)
	pass


func upgrade_leap_speed(value: int) -> void:
	# increase speed of leap (moving between ledges)
	leap_speed += value
	print(leap_speed)
	pass


func upgrade_stamina_capacity(value: int) -> void:
	# increase max stamina
	stamina += value
	print(stamina)
	pass


func upgrade_grip_strength(value: int) -> void:
	# increase amount of time player can hang on ledge
	grip_strength += value
	print(grip_strength)
	pass


func upgrade_extra_power_use(value: int) -> void:
	# adds additional uses for powers
	ability_uses += value
	print(ability_uses)
	pass

