extends CharacterBody2D

# 1. Konstanten und Variablen 
const SPEED = 300.0

# Zustand um zu verhindern, dass Laufen/springen während des Angriffs möglist ist
var is_attacking = false

# 2. Referenzen holen, sobald die Szene geladen ist
@onready var anim = %Gladiator

func _ready():
	anim.animation_finished.connect(on_animation_finished)
	anim.play("Idle")

func _physics_process(delta: float) -> void:
	# Hauptlogikschleife für die Physik

	# ----------------------------------------------------
	# A) Eingaben und Zustand prüfen (z.B. Angriff)
	# ----------------------------------------------------
	if is_attacking:
		velocity = Vector2.ZERO 
		move_and_slide()
		return
		
	if Input.is_action_just_pressed("attack"):
		attack()
		return
	# ----------------------------------------------------
	# B) Eingaben für 8 Richtungen abrufen
	# ----------------------------------------------------
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_axis("ui_left", "ui_right")
	input_vector.y = Input.get_axis("ui_up", "ui_down")
	
	input_vector = input_vector.normalized() 
	# ----------------------------------------------------
	# C) Geschwindigkeit, Animation und flip_h bestimmen
	# ----------------------------------------------------
	if input_vector != Vector2.ZERO:
		# Wende die Geschwindigkeit auf beide Achsen an
		velocity.x = input_vector.x * SPEED
		velocity.y = input_vector.y * SPEED

		anim.play("Run")
		
		# **FLIP_H LOGIK (Richtung spiegeln)**
		if input_vector.x != 0:
			anim.flip_h = input_vector.x < 0 # Setzt flip_h auf true, wenn input_vector.x negativ ist (links)
			
	else:
		# Keine Eingabe: Geschwindigkeit auf 0 abbremsen
		velocity = Vector2.ZERO
		anim.play("Idle")

	# ----------------------------------------------------
	# D) Bewegung ausführen
	# ----------------------------------------------------
	move_and_slide()
	
# 3. separate Funktion für den Angriff
func attack():
	is_attacking = true
	anim.play("Attack")
	
func on_animation_finished():
	if anim.animation == "Attack":
		is_attacking = false
		anim.play("Idle")
