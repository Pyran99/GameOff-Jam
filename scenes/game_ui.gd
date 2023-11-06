extends CanvasLayer


@onready var stamina_bar: TextureProgressBar = $Stamina
@onready var stamina_text: Label = $Stamina/Label


func _ready() -> void:
	stamina_bar.max_value = PlayerStats.base_stamina
	pass


func _process(delta: float) -> void:
	stamina_bar.value = PlayerStats.stamina
	
	pass


func _on_stamina_value_changed(value: float) -> void:
	stamina_text.text = str(stamina_bar.value, "/", PlayerStats.base_stamina)
