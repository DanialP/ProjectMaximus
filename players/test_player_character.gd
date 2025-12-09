extends CharacterBody2D

@export var player_id: int = 0
var input_velocity: Vector2 = Vector2.ZERO
var speed: float = 200.0

@onready var player_sprite: Sprite2D = get_node("Sprite2D")

func _ready():
    pass

func _physics_process(delta):
    input_velocity = Vector2.ZERO

    if Input.is_joy_button_pressed(player_id, JoyButton.JOY_BUTTON_DPAD_RIGHT) or Input.is_action_pressed("ui_right"):
        input_velocity.x = 1
    if Input.is_joy_button_pressed(player_id, JoyButton.JOY_BUTTON_DPAD_LEFT) or Input.is_action_pressed("ui_left"):
        input_velocity.x = -1
    if Input.is_joy_button_pressed(player_id, JoyButton.JOY_BUTTON_DPAD_DOWN) or Input.is_action_pressed("ui_down"):
        input_velocity.y = 1
    if Input.is_joy_button_pressed(player_id, JoyButton.JOY_BUTTON_DPAD_UP) or Input.is_action_pressed("ui_up"):
        input_velocity.y = -1


    position.x += input_velocity.x * speed * delta
    position.y += input_velocity.y * speed * delta

    if (input_velocity != Vector2.ZERO):
        player_sprite.rotation = lerp(player_sprite.rotation, input_velocity.angle(), .2)
