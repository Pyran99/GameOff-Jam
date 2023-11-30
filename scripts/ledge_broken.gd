extends Ledge
class_name LedgeBroken

@export var start_break_count: int
var break_count: int
@export var rock_break_audio: AudioStreamWAV
@export var rock_falling_audio: AudioStreamWAV
var max_breaks: int = 2

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var particle_smoke: GPUParticles2D = $GPUParticles2D
@onready var particle_rock: GPUParticles2D = $GPUParticles2D3
@onready var timer: Timer = $DestroyTimer


func _ready() -> void:
	break_count = start_break_count
	start_level_break_check()
	target_pos = $Marker2D


func start_level_break_check() -> void:
	if break_count == 0:
		$Sprite2D.show()
		$Sprite2D2.hide()
		$Sprite2D3.hide()
	if break_count == 1:
		$Sprite2D.hide()
		$Sprite2D2.show()
		$Sprite2D3.hide()
	if break_count == 2:
		$Sprite2D.hide()
		$Sprite2D2.hide()
		$Sprite2D3.show()


func check_break_count() -> void:
	if break_count == 1:
		particle_smoke.restart()
		audio_player.stream = rock_break_audio
		audio_player.play()
		$Sprite2D.hide()
		$Sprite2D2.show()
		$Sprite2D3.hide()
	if break_count == 2:
		particle_smoke.restart()
		audio_player.stream = rock_break_audio
		audio_player.play()
		$Sprite2D.hide()
		$Sprite2D2.hide()
		$Sprite2D3.show()
	if break_count > 2:
		particle_rock.emitting = true
		collision.disabled = true
		audio_player.stream = rock_falling_audio
		audio_player.play()
		$Sprite2D3.hide()
		timer.start(particle_rock.lifetime)


func increase_break_count() -> void:
	break_count += 1
	check_break_count()


func trigger_platform_break() -> void:
	hide()
	set_process(false)


func show_platform() -> void:
	set_process(true)
	show()
	break_count = start_break_count
	collision.disabled = false
	start_level_break_check()


func _on_destroy_timer_timeout() -> void:
	trigger_platform_break()

func _draw() -> void:
	if Engine.is_editor_hint():
		var center = Vector2.ZERO
		var radius = 400
		var angle_from = 0
		var angle_to = 360
		var color = Color(randi())
		color.a = 1
		draw_arc(target_pos.global_position, radius, angle_from, angle_to, 32, color, 2)


#func _on_visibility_changed() -> void:
#	start_level_break_check()
