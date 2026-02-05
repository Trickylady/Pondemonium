extends Control

func _ready() -> void:
	%mast.value = AudioServer.get_bus_volume_linear(0)
	%sfx.value = AudioServer.get_bus_volume_linear(1)
	%mus.value = AudioServer.get_bus_volume_linear(2)

func _on_mast_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(0, value)

func _on_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(1, value)

func _on_mus_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(2, value)
