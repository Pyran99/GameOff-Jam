extends CharacterBody2D
class_name Player


signal used_ability

var moving: bool = false
var can_powerup: bool = false
var can_click_platform: bool = true
var target_pos: Vector2
var platform_pos: Vector2
var hook_position: Vector2

var can_play: bool = false

var highest_point: Vector2

var platforms_in_range: Array[Ledge]

enum Powers {
	INCREASE_RANGE,
	REGEN_STAMINA
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

@export var animated_sprite: AnimatedSprite2D

@onready var grapple_range_collision: CollisionShape2D = $ReachRange/CollisionShape2D
@onready var UI: CanvasLayer = $"Game UI"
@onready var camera: Camera2D = $Camera2D



func set_usuable_icon(body: Ledge) -> void:
	if body in platforms_in_range:
		mouse_icon.modulate = usable_color

func set_unusable_icon(_body: Ledge) -> void:
	mouse_icon.modulate = unusable_color


func reset_level() -> void:
	check_for_hook()


func get_can_click_platform() -> bool:
	return can_click_platform


func _ready() -> void:
	current_power = GameManager.power_selected
	grapple_range_collision.shape.radius = PlayerStats.grapple_range
	grapple_amount_used = base_grapple_amount_used


func _process(_delta: float) -> void:
	mouse_icon.global_position = get_global_mouse_position()
	if can_click_platform:
		change_sprite_to_mouse()


func _physics_process(_delta: float) -> void:
	# move from current pos to new pos
#	var input_direction = Input.get_vector("left", "right", "up", "down")
#	velocity = input_direction * 100
#	move_and_slide()

	if global_position.distance_to(target_pos) < 6 and moving:
		debug_hook_finished()
#		moving = false
#		can_click_platform = true
		spawned_hook = null
		GameManager.set_highscore()
#		highest_point.y = -self.global_position.y
#		highest_point.y = GameManager.highscore
		check_game_over()

	if moving:
		move_to_ledge()


func hook_finished() -> void:
	moving = true


func check_game_over() -> void:
	if PlayerStats.grapple_uses <= 0:
		can_play = false
		GameManager.game_over()


func debug_hook_finished() -> void:
	if spawned_hook != null:
		spawned_hook.clear_hook()
	moving = false
	can_click_platform = true


func change_sprite_to_mouse() -> void:
	var direction = (global_position - get_global_mouse_position()).normalized()
	if atan2(direction.y, direction.x) < 1.5 and atan2(direction.y, direction.x) > -1.5:
		animated_sprite.animation = str("idle_left")
	if atan2(direction.y, direction.x) > 1.5 or atan2(direction.y, direction.x) < -1.5:
		animated_sprite.animation = str("idle_right")


func shoot_hook() -> void:
	can_click_platform = false
	var direction = (global_position - get_global_mouse_position()).normalized()
	if direction.y > 0:
		animated_sprite.play("shoot_up")
	if direction.y < 0:
		animated_sprite.play("shoot_down")
	$AudioStreamPlayer2D.play(0)
	spawned_hook = hook.instantiate()
	spawned_hook.position = global_position
	spawned_hook.set_target_pos(platform_pos)
	$Node.add_child(spawned_hook)


func _input(event: InputEvent) -> void:
	if !can_play:
		return
	
	if event.is_action_pressed("LeftClick"):
		if PlayerStats.get_grapple_uses_value() > 0:
			if can_click_platform:
				for i in platforms_in_range:
					if i.get_can_jump_to():
						platform_pos = i.global_position
						target_pos = i.target_pos.global_position
						if global_position.distance_to(target_pos) < 12:
							return
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
	
	if event.is_action_pressed("space"):
		check_for_hook()
		debug_hook_finished()
	
	if event.is_action_pressed("1"): # TODO: REMOVE TESTING
		self.global_position = Vector2(0, -45000)

func check_for_hook() -> void:
	debug_hook_finished()


func move_to_ledge() -> void:
	var distance_to_platform = target_pos - global_position
	
	velocity = distance_to_platform.normalized() * PlayerStats.grapple_speed
	move_and_slide()
	
	if -self.global_position.y > GameManager.score:
		GameManager.set_score(-self.global_position.y)


func increased_grapple_range() -> void:
	powered_grapple_range = PlayerStats.power_increased_grapple_range()
	var tween = create_tween()
	var zoom_out: Vector2 = Vector2(0.2,0.2)
	tween.tween_property(camera, "zoom", zoom_out, 1)
	queue_redraw()


func active_power() -> void:
	var power = Powers
	match current_power:
		power.INCREASE_RANGE:
			increased_grapple_range()
		power.REGEN_STAMINA:
			power_stamina_regen()


func reset_power() -> void:
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


func power_stamina_regen() -> void:
	# eat a snack to regen a large amount of stamina
	PlayerStats.increase_grapple_uses(grapple_use_gain_amount)


func _on_upgrade_window_upgrade_applied() -> void:
	queue_redraw()


func _on_animated_sprite_2d_animation_finished() -> void:
	animated_sprite.animation = str("idle_down")
