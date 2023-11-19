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

@export var mouse_icon: Sprite2D
var usable_color: Color = Color.GREEN
var unusable_color: Color = Color.RED
var changed_icon_color: bool = false

@onready var grapple_range_collision: CollisionShape2D = $ReachRange/CollisionShape2D
@onready var UI: CanvasLayer = $"Game UI"
@onready var camera: Camera2D = $Camera2D



func set_usuable_icon(body: Ledge) -> void:
	if body in platforms_in_range:
		mouse_icon.modulate = usable_color

func set_unusable_icon(_body: Ledge) -> void:
	mouse_icon.modulate = unusable_color


func _ready() -> void:
	current_power = GameManager.power_selected
	grapple_range_collision.shape.radius = PlayerStats.grapple_range
	grapple_amount_used = base_grapple_amount_used


func _process(_delta: float) -> void:
	mouse_icon.global_position = get_global_mouse_position()


func _physics_process(_delta: float) -> void:
	# move from current pos to new pos
#	var input_direction = Input.get_vector("left", "right", "up", "down")
#	velocity = input_direction * 100
#	move_and_slide()

	if global_position.distance_to(target_pos) < 6 and moving:
		moving = false
		can_click_platform = true
		spawned_hook = null
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
	$AudioStreamPlayer2D.play(0)
	spawned_hook = hook.instantiate()
	spawned_hook.position = global_position
	spawned_hook.set_target_pos(target_pos)
	$Node.add_child(spawned_hook)


func _input(event: InputEvent) -> void:
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
	
#	if event.is_action_pressed("4"):
#		upgrade_window.visible = true
#	if event.is_action_pressed("5"):
#		upgrade_window.visible = false
	
	if event.is_action_pressed("space"):
		if spawned_hook:
			spawned_hook.queue_free()
		debug_hook_finished()


func move_to_ledge() -> void:
	var distance_to_platform = target_pos - global_position
	
	velocity = distance_to_platform.normalized() * PlayerStats.grapple_speed
	move_and_slide()
	GameManager.set_score(-self.global_position.y)


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
#	body.show_label()


func _on_reach_range_body_exited(body: Node2D) -> void:
	platforms_in_range.erase(body)
#	body.hide_label()


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
