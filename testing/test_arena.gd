extends Node2D

const MAX_PLAYERS := 8
const PLAYER_CONFIGS: Array[Dictionary] = [
	{"id": 0, "device_id": 0, "debug_spawn": "ui_key_1", "spawn_path": NodePath("SpawnLocation1")},
	{"id": 1, "device_id": 1, "debug_spawn": "ui_key_2", "spawn_path": NodePath("SpawnLocation2")},
	{"id": 2, "device_id": 2, "debug_spawn": "ui_key_3", "spawn_path": NodePath("SpawnLocation3")},
	{"id": 3, "device_id": 3, "debug_spawn": "ui_key_4", "spawn_path": NodePath("SpawnLocation4")},
	{"id": 4, "device_id": 4, "debug_spawn": "ui_key_5", "spawn_path": NodePath("SpawnLocation5")},
	{"id": 5, "device_id": 5, "debug_spawn": "ui_key_6", "spawn_path": NodePath("SpawnLocation6")},
	{"id": 6, "device_id": 6, "debug_spawn": "ui_key_7", "spawn_path": NodePath("SpawnLocation7")},
	{"id": 7, "device_id": 7, "debug_spawn": "ui_key_8", "spawn_path": NodePath("SpawnLocation8")},
]

@export var player: PackedScene

var _player_slots: Array[Dictionary] = []
var _spawned_players: Dictionary = {}

func _ready():
	_build_player_slots()
	_spawned_players.clear()

func _input(event):
	for cfg in _player_slots:
		if _spawned_players.has(cfg["id"]):
			continue
		if _is_spawn_pressed(event, cfg):
			_spawn_player(cfg)

func reset_arena():
	for spawned in _spawned_players.values():
		if is_instance_valid(spawned):
			spawned.queue_free()
	_spawned_players.clear()

func _build_player_slots():
	_player_slots.clear()
	for cfg in PLAYER_CONFIGS:
		var spawn_node: Path2D = get_node_or_null(cfg["spawn_path"])
		if not spawn_node:
			push_warning("Missing spawn node: %s" % cfg["spawn_path"])
			continue

		var resolved_cfg: Dictionary = cfg.duplicate()
		resolved_cfg["spawn_node"] = spawn_node
		_player_slots.append(resolved_cfg)

func _is_spawn_pressed(event: InputEvent, cfg: Dictionary) -> bool:
	if event.is_action_pressed(cfg["debug_spawn"]):
		return true

	if event is InputEventJoypadButton:
		var btn_event: InputEventJoypadButton = event
		return btn_event.pressed \
			and btn_event.device == cfg["device_id"] \
			and btn_event.button_index == JoyButton.JOY_BUTTON_START

	return false

func _spawn_player(cfg: Dictionary):
	if not player:
		push_error("Player scene is not assigned.")
		return
	if _spawned_players.size() >= MAX_PLAYERS:
		return

	var new_player: CharacterBody2D = player.instantiate()
	new_player.player_id = cfg["id"]
	new_player.position = cfg["spawn_node"].position
	add_child(new_player)

	_spawned_players[cfg["id"]] = new_player
