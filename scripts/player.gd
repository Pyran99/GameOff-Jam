extends CharacterBody2D
class_name Player


signal used_ability

var moving: bool = false
var can_powerup: bool = false
var can_click_platform: bool = true
var target_pos: Vector2
var hook_position: Vector2

var platforms_in_range: Array[Ledge]

enum Powers {
	INCREASE_RANGE,
	REGEN_STAMINA,
	CREATE_LEDGE
}
@export var current_power: Powers
var current_power_active: bool = false
var powered_grapple_range: int

@export var base_grapple_amount_used: int
var grapple_amount_used: int
@export var grapple_use_gain_amount: int

@export var upgrade_window: CanvasLayer
@export var hook: PackedScene
var spawned_hook: CharacterBody2D

@onready var grapple_range_collision: CollisionShape2D = $ReachRange/CollisionShape2D
@onready var UI: CanvasLayer = $"Game UI"
@onready var camera: Camera2D = $Camera2D



func _ready() -> void:
	grapple_range_collision.shape.radius = PlayerStats.grapple_range
	grapple_amount_used = base_grapple_amount_used


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	# move from current pos to new pos
#	var input_direction = Input.get_vector("left", "right", "up", "down")
#	velocity = input_direction * 100
#	move_and_slide()

	if global_position.distance_to(target_pos) < 6 and moving:
		moving = false
		can_click_platform = true
		spawned_hook = null
		GameManager.player_is_moving = false
		GameManager.set_highscore()

	if moving:
		move_to_ledge()


func hook_finished() -> void:
	moving = true


func debug_hook_finished() -> void:
	moving = false
	can_click_platform = true


func shoot_hook() -> void:
	can_click_platform = false
	spawned_hook = hook.instantiate()
	spawned_hook.position = global_position
	spawned_hook.set_target_pos(target_pos)
	$Node.add_child(spawned_hook)


func _input(event: InputEvent) -> void:
	# when click ledge, fire hook with rope line between hook and player
	if event.is_action_pressed("LeftClick"):
		if PlayerStats.get_grapple_uses_value() > 0:
			if can_click_platform:
				for i in platforms_in_range:
					if i.get_can_jump_to():
						target_pos = i.global_position
						shoot_hook()
						if current_power_active and current_power == Powers.INCREASE_RANGE:
							PlayerStats.decrease_grapple_uses(0)
						else:
							PlayerStats.decrease_grapple_uses(grapple_amount_used)
						if current_power_active:
							reset_power()
	
	
	if event.is_action_pressed("RightClick"):
		# activate powerup
		if PlayerStats.ability_uses > 0 and !current_power_active:
			print("activate powerup")
			current_power_active = true
			active_power()
			PlayerStats.used_ability()
			used_ability.emit()
		else:
			print("powerup not available")
	
	# for testing
	if event.is_action_pressed("1"):
		current_power = Powers.INCREASE_RANGE
	if event.is_action_pressed("2"):
		current_power = Powers.REGEN_STAMINA
	if event.is_action_pressed("3"):
		current_power = Powers.CREATE_LEDGE
		
	if event.is_action_pressed("4"):
		upgrade_window.visible = true
	if event.is_action_pressed("5"):
		upgrade_window.visible = false
	
	if event.is_action_pressed("space"):
		if spawned_hook:
			spawned_hook.queue_free()
		debug_hook_finished()


func move_to_ledge() -> void:
	var distance_to_platform = target_pos - global_position
	
	velocity = distance_to_platform.normalized() * PlayerStats.grapple_speed
	move_and_slide()
	GameManager.player_is_moving = true


func increased_grapple_range() -> void:
	powered_grapple_range = PlayerStats.power_increased_grapple_range()
	var tween = create_tween()
	var zoom_out: Vector2 = Vector2(0.3,0.3)
	tween.tween_property(camera, "zoom", zoom_out, 1)
	queue_redraw()


func active_power() -> void:
	var power = Powers
	match current_power:
		power.INCREASE_RANGE:
			print("range")
			increased_grapple_range()
		power.REGEN_STAMINA:
			print("stamina")
			PlayerStats.increase_grapple_uses(grapple_use_gain_amount)
		power.CREATE_LEDGE:
			print("ledge")


func reset_power() -> void:
#	current_power = Powers.NULL
	current_power_active = false
	grapple_range_collision.shape.radius = PlayerStats.grapple_range
	var tween = create_tween()
	var zoom_in: Vector2 = Vector2(0.4,0.4)
	tween.tween_property(camera, "zoom", zoom_in, 2)
	queue_redraw()


func _draw() -> void:
	var center = Vector2.ZERO
	var radius = PlayerStats.grapple_range
	var angle_from = 0
	var angle_to = 360
	var color = Color(randi())
	color.a = 1
	if current_power == Powers.INCREASE_RANGE and current_power_active:
		radius = PlayerStats.power_increased_grapple_range()
		grapple_range_collision.shape.radius = radius
	draw_arc(center, radius, angle_from, angle_to, 32, color, 2)


func _on_reach_range_body_entered(body: Node2D) -> void:
	platforms_in_range.append(body)


func _on_reach_range_body_exited(body: Node2D) -> void:
	platforms_in_range.erase(body)


func power_increase_range() -> void:
	# increase reach range with no stamina use for next leap
	
	pass


func power_stamina_regen() -> void:
	# eat a snack to regen a large amount of stamina
	PlayerStats.increase_grapple_uses(grapple_use_gain_amount)
	pass


func power_create_ledge() -> void:
	# place a ledge anywhere within reach range
	
	pass


func _on_upgrade_window_upgrade_applied() -> void:
	queue_redraw()
