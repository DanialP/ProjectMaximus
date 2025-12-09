extends Control

@export var local_multipayer_scene: PackedScene

func _on_local_pressed() -> void:
    if local_multipayer_scene:
        get_tree().change_scene_to_packed(local_multipayer_scene)
    else:
        push_warning("No local_multiplayer_scene set for GameModeSelection")
