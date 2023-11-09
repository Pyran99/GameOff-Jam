extends CharacterBody2D
class_name Player


signal used_ability

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
var current_power_active: bool = false
var powered_reach_range: int

@export var base_stamina_consumption: int
var stamina_consumption: int
@export var stamina_gain_amount: int

@export var upgrade_window: CanvasLayer

@onready var reach_collision: CollisionShape2D = $ReachRange/CollisionShape2D
@onready var UI: CanvasLayer = $"Game UI"
@onready var camera: Camera2D = $Camera2D
@onready var line: Line2D = $Line2D
@onready var hook: Sprite2D = $Hook


func set_line_on_click() -> void:
	if line.points.size() == 0:
		line.add_point(to_local(global_position))
		line.add_point(to_local(get_global_mouse_position()))
	else:
		line.add_point(to_local(get_global_mouse_position()))


func _ready() -> void:
	reach_collision.shape.radius = PlayerStats.reach_range
	stamina_consumption = base_stamina_consumption


func _process(delta: float) -> void:
	
	hook.look_at(get_global_mouse_position())
	
	if line.points.size() > 0:
		line.set_point_position(0, to_local(self.global_position))
		line.set_point_position(1, to_local(get_global_mouse_position()))
	
	if Input.is_action_just_pressed("test"):
		set_line_on_click()
	
	if Input.is_action_just_pressed("test2"):
		line.clear_points()


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
		move_to_ledge()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick"):
		if can_click_ledge:
			for i in ledges_in_range:
				if i.get_can_jump_to():
					target_pos = i.global_position
					moving = true
					if current_power_active and current_power == Powers.INCREASE_RANGE:
						PlayerStats.decrease_stamina(0)
					else:
						PlayerStats.decrease_stamina(stamina_consumption)
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


func move_to_ledge() -> void:
	var distance_to_ledge = target_pos - global_position
	
#	var speed = PlayerStats.leap_speed
	
	velocity = distance_to_ledge.normalized() * PlayerStats.leap_speed
	move_and_slide()


func increased_reach_range() -> void:
	powered_reach_range = PlayerStats.power_increased_reach_range()
	var tween = create_tween()
	var zoom_out: Vector2 = Vector2(0.4,0.4)
	tween.tween_property(camera, "zoom", zoom_out, 1)
	queue_redraw()


func active_power() -> void:
	var power = Powers
	match current_power:
		power.INCREASE_RANGE:
			print("range")
			increased_reach_range()
		power.REGEN_STAMINA:
			print("stamina")
			PlayerStats.increase_stamina(stamina_gain_amount)
		power.CREATE_LEDGE:
			print("ledge")


func reset_power() -> void:
#	current_power = Powers.NULL
	current_power_active = false
	reach_collision.shape.radius = PlayerStats.reach_range
	var tween = create_tween()
	var zoom_in: Vector2 = Vector2(0.6,0.6)
	tween.tween_property(camera, "zoom", zoom_in, 1)
	queue_redraw()


func _draw() -> void:
	var center = Vector2.ZERO
	var radius = PlayerStats.reach_range
	var angle_from = 0
	var angle_to = 360
	var color = Color(randi())
	color.a = 1
	if current_power == Powers.INCREASE_RANGE and current_power_active:
		radius = PlayerStats.power_increased_reach_range()
		reach_collision.shape.radius = radius
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
	PlayerStats.increase_stamina(stamina_gain_amount)
	pass


func power_create_ledge() -> void:
	# place a ledge anywhere within reach range
	
	pass


func _on_upgrade_window_upgrade_applied() -> void:
	queue_redraw()
