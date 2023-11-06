extends CharacterBody2D
class_name Player

var moving: bool = false
var can_powerup: bool = false
var can_click_ledge: bool = true
var target_pos: Vector2

var ledges_in_range: Array[Ledge]

enum Powers {
	INCREASE_RANGE,
	REGEN_STAMINA,
	CREATE_LEDGE
}
@export var current_power: Powers

#@export var upgrades: PlayerUpgrades

@onready var reach_collision: CollisionShape2D = $ReachRange/CollisionShape2D


func _ready() -> void:
	reach_collision.shape.radius = PlayerStats.reach_range


func _physics_process(_delta: float) -> void:
	# move from current pos to new pos
#	var input_direction = Input.get_vector("left", "right", "up", "down")
#	velocity = input_direction * 100
#	move_and_slide()

	if global_position.distance_to(target_pos) < 5:
		moving = false
		can_click_ledge = true

	if moving:
		can_click_ledge = false
		var distance_to_ledge = target_pos - global_position
		velocity = distance_to_ledge.normalized() * PlayerStats.leap_speed
		move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick"):
		if can_click_ledge:
			for i in ledges_in_range:
				if i.get_can_jump_to():
					target_pos = i.global_position
					moving = true
	
	
	if event.is_action_pressed("RightClick"):
		# activate powerup
		if can_powerup:
			print("activate powerup")
			active_power()
		else:
			print("powerup not available")
	
	if event.is_action_pressed("down"):
		PlayerStats.reach_range += 10
		print(PlayerStats.reach_range)


func active_power() -> void:
	var power = Powers
	match current_power:
		power.INCREASE_RANGE:
			print("test 1")
		power.REGEN_STAMINA:
			print("test 2")
		power.CREATE_LEDGE:
			print("test 3")
	pass


func _draw() -> void:
	var center = Vector2.ZERO
	var radius = PlayerStats.reach_range
	var angle_from = 0
	var angle_to = 360
	var color = Color(randi())
	color.a = 1
	draw_arc(center, radius, angle_from, angle_to, 32, color, 2)


func _on_reach_range_body_entered(body: Node2D) -> void:
	ledges_in_range.append(body)


func _on_reach_range_body_exited(body: Node2D) -> void:
	ledges_in_range.erase(body)


func power_increase_range() -> void:
	# increase reach range with no stamina use for next leap
	
	pass


func power_stamina_regen() -> void:
	# eat a snack to regen a large amount of stamina
	
	pass


func power_create_ledge() -> void:
	# place a ledge anywhere within reach range
	
	pass


