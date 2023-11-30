extends Node
# GLOBAL PlayerStats


signal grapple_uses_changed
signal ability_upgraded

@export var base_grapple_range: int = 500
@export var base_grapple_speed: int = 300
@export var base_grapple_uses: int = 20
@export var start_grapple_uses: int = 20
@export var base_grip_strength: int = 10
@export var base_ability_uses: int = 1
@export var start_ability_uses: int = 1

var grapple_range: int
var grapple_speed: int
var grapple_uses: int
var grip_strength: int
var ability_uses: int

var current_ability_uses: int = 0


func _ready() -> void:
	grapple_range = base_grapple_range
	grapple_speed = base_grapple_speed
	base_grapple_uses = start_grapple_uses
	grapple_uses = base_grapple_uses
	grip_strength = base_grip_strength
	ability_uses = start_ability_uses


func _process(_delta: float) -> void:
	pass


func increase_grapple_uses(value: int) -> void:
	grapple_uses += value
	emit_signal("grapple_uses_changed", grapple_uses)

func decrease_grapple_uses(value: int) -> void:
	grapple_uses -= value
	emit_signal("grapple_uses_changed", grapple_uses)


func reset_all_values() -> void:
	grapple_range = base_grapple_range
	grapple_speed = base_grapple_speed
	base_grapple_uses = start_grapple_uses
	grapple_uses = base_grapple_uses
	grip_strength = base_grip_strength
	ability_uses = start_ability_uses
	current_ability_uses = 0


func reset_grapple_uses() -> void:
	grapple_uses = base_grapple_uses

func get_grapple_uses_value() -> int:
	return grapple_uses


func power_increased_grapple_range() -> int:
	var temp_range: int = grapple_range * 2
	return temp_range


func upgrade_grapple_range(value: int) -> void:
	# increase reach range
	grapple_range += value
	(get_tree().get_first_node_in_group("Player") as Player).grapple_range_collision.shape.radius = grapple_range
	print(grapple_range)


func upgrade_grapple_speed(value: int) -> void:
	# increase speed of leap (moving between ledges)
	grapple_speed += value
	print(grapple_speed)


func upgrade_grapple_uses_capacity(value: int) -> void:
	# increase max grapple_uses
	base_grapple_uses += value
	grapple_uses += value
	emit_signal("grapple_uses_changed", grapple_uses)
	print(base_grapple_uses)


func upgrade_grip_strength(value: int) -> void:
	# increase amount of time player can hang on ledge
	# possibly not using
	grip_strength += value
	print(grip_strength)


func upgrade_extra_power_use(value: int) -> void:
	# adds additional uses for powers
	base_ability_uses += value
	print(base_ability_uses)
	emit_signal("ability_upgraded")


func used_ability() -> void:
	ability_uses -= 1
	current_ability_uses += 1
