extends Ledge
class_name LedgeBroken

@export var break_count: int
var max_breaks: int = 2

@onready var particle_smoke: GPUParticles2D = $GPUParticles2D
@onready var particle_rock: GPUParticles2D = $GPUParticles2D3
@onready var timer: Timer = $DestroyTimer


func increase_break_count() -> void:
	break_count += 1
	if break_count == 1:
		particle_smoke.emitting = true
		$Sprite2D.hide()
		$Sprite2D2.show()
		$Sprite2D3.hide()
	if break_count == 2:
		particle_smoke.emitting = true
		$Sprite2D.hide()
		$Sprite2D2.hide()
		$Sprite2D3.show()
	if break_count > 2:
		particle_rock.emitting = true
		timer.start(particle_rock.lifetime)


func trigger_platform_break() -> void:
	if break_count > 2:
		hide()
		set_process(false)


func show_platform() -> void:
	set_process(true)
	break_count = 0
	$Sprite2D.show()
	$Sprite2D2.hide()
	$Sprite2D3.hide()
	show()


func _on_destroy_timer_timeout() -> void:
	trigger_platform_break()
