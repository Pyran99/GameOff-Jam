extends CharacterBody2D
class_name Player


signal shot_grapple
signal used_ability

var moving: bool = false
var can_powerup: bool = false
var can_click_platform: bool = true
var target_pos: Vector2
var platform_pos: Vector2
var hook_position: Vector2
var current_platform: Ledge
var next_platform: Ledge

var can_play: bool = false

#var highest_point: Vector2

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
var hook: PackedScene = preload("res://scenes/hook.tscn")
var spawned_hook: CharacterBody2D

var usable_color: Color = Color.GREEN
var unusable_color: Color = Color.RED
var changed_icon_color: bool = false

@export var animated_sprite: AnimatedSprite2D
@export var audio_grapple: AudioStreamWAV
@export var audio_ability: AudioStreamWAV
@export var grapple_distance_line: Line2D
@export var hook_sprite: Sprite2D

#var normal_cursor = load()
var hook_cursor = load("res://assets/hookcursor.png")

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var grapple_range_collision: CollisionShape2D = $ReachRange/CollisionShape2D
@onready var UI: CanvasLayer = $"Game UI"
@onready var camera: Camera2D = $Camera2D



func set_usuable_icon(body: Ledge) -> void:
	if body in platforms_in_range:
		Input.set_custom_mouse_cursor(hook_cursor, Input.CURSOR_ARROW, Vector2(16,16))

func set_unusable_icon(_body: Ledge) -> void:
	Input.set_custom_mouse_cursor(null, Input.CURSOR_ARROW)


func reset_level() -> void:
	check_for_hook()


func get_can_click_platform() -> bool:
	return can_click_platform


func _ready() -> void:
	current_power = GameManager.power_selected
	grapple_range_collision.shape.radius = PlayerStats.grapple_range
	grapple_amount_used = base_grapple_amount_used
	Input.set_custom_mouse_cursor(null, Input.CURSOR_ARROW)
	grapple_distance_line.add_point(self.global_position)
	grapple_distance_line.add_point(get_global_mouse_position())


func _process(_delta: float) -> void:
	if can_click_platform:
		change_sprite_to_mouse()


func _physics_process(_delta: float) -> void:
	var max_range = PlayerStats.grapple_range
	var direction = (get_global_mouse_position() - self.global_position).normalized()
	grapple_distance_line.set_point_position(1, to_local(get_global_mouse_position()))
	if current_power == Powers.INCREASE_RANGE:
		if current_power_active:
			max_range = PlayerStats.power_increased_grapple_range()
		else:
			max_range = PlayerStats.grapple_range
		if self.global_position.distance_to(get_global_mouse_position()) > max_range:
			grapple_distance_line.set_point_position(1, direction * max_range)
	if current_power == Powers.REGEN_STAMINA:
		if self.global_position.distance_to(get_global_mouse_position()) > max_range:
			grapple_distance_line.set_point_position(1, direction * max_range)
		else:
			grapple_distance_line.set_point_position(1, to_local(get_global_mouse_position()))
		
	hook_sprite.global_position = to_global(grapple_distance_line.get_point_position(1))
	
	if global_position.distance_to(target_pos) < 6 and moving:
		debug_hook_finished()
		spawned_hook = null
		GameManager.set_highscore()
		get_tree().get_first_node_in_group("UI").set_highscore_text()
		check_game_over()

	if moving:
		move_to_ledge()
		grapple_distance_line.set_point_position(0, to_local(self.global_position))


func hook_finished() -> void:
	moving = true
	left_platform()


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
	elif direction.y < 0:
		animated_sprite.play("shoot_down")
	audio_player.stream = audio_grapple
	audio_player.play()
	spawned_hook = hook.instantiate()
	spawned_hook.position = global_position
	spawned_hook.set_target_pos(platform_pos)
	$Node.add_child(spawned_hook)
	GameManager.grapple_shot()


func left_platform() -> void:
	if current_platform != null:
		if current_platform is LedgeBroken:
			(current_platform as LedgeBroken).increase_break_count()
	if next_platform != null:
		current_platform = next_platform


func _input(event: InputEvent) -> void:
	if !can_play:
		return
	
	if event.is_action_pressed("LeftClick"):
		if PlayerStats.get_grapple_uses_value() > 0:
			if can_click_platform:
				for i in platforms_in_range:
					if i.get_can_jump_to():
						next_platform = i
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
	
	if event.is_action_pressed("L"): # use if hook is stuck
		if !moving:
			debug_hook_finished()
#
#	if event.is_action_pressed("1"): # TODO: REMOVE TESTING END
#		self.global_position = Vector2(0, -46000)

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
	audio_player.stream = audio_ability
	audio_player.play()
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
	var color = Color.GREEN
#	var color = Color(randi())
	color.a = 0
	if current_power == Powers.INCREASE_RANGE and current_power_active:
		radius = PlayerStats.power_increased_grapple_range()
		grapple_range_collision.shape.radius = radius
	draw_arc(center, radius, angle_from, angle_to, 48, color, 1, true)


func _on_reach_range_body_entered(body: Node2D) -> void:
	platforms_in_range.append(body)


func _on_reach_range_body_exited(body: Node2D) -> void:
	platforms_in_range.erase(body)


func power_stamina_regen() -> void:
	# eat a snack to regen a large amount of stamina
	PlayerStats.increase_grapple_uses(grapple_use_gain_amount)


func _on_upgrade_window_upgrade_applied() -> void:
	queue_redraw()


func _on_animated_sprite_2d_animation_finished() -> void:
	animated_sprite.animation = str("idle_down")
