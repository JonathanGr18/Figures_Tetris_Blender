# El jugador extiende de Area2D, lo que le permite detectar colisiones con otros cuerpos.
extends Area2D

# Señal que se emitirá cuando el jugador reciba un golpe.
signal hit

# Variable exportada que define la velocidad del jugador en píxeles por segundo.
@export var speed = 400

# Variable que almacenará el tamaño de la ventana del juego.
var screen_size

# Función que se ejecuta al iniciar la escena.
func _ready():
	# Se obtiene el tamaño de la ventana del juego.
	screen_size = get_viewport_rect().size
	# Se oculta al jugador hasta que el juego empiece.
	hide()

# Función que se llama en cada frame del juego.
func _process(delta):
	# Vector de movimiento del jugador, inicia en cero.
	var velocity = Vector2.ZERO

	# Revisa las teclas presionadas y modifica el vector según la dirección.
	if Input.is_action_pressed(&"move_right"):
		velocity.x += 1
	if Input.is_action_pressed(&"move_left"):
		velocity.x -= 1
	if Input.is_action_pressed(&"move_down"):
		velocity.y += 1
	if Input.is_action_pressed(&"move_up"):
		velocity.y -= 1

	# Si hay movimiento (longitud mayor a cero), se normaliza el vector y se multiplica por la velocidad.
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		# Se reproduce la animación del sprite (caminar/correr)
		$AnimatedSprite2D.play()
	else:
		# Si no hay movimiento, se detiene la animación
		$AnimatedSprite2D.stop()

	# Se actualiza la posición del jugador en base a la velocidad y el tiempo transcurrido (delta)
	position += velocity * delta
	# Se limita la posición para que no se salga de la pantalla.
	position = position.clamp(Vector2.ZERO, screen_size)

	# Ajuste de la animación y rotación según la dirección del movimiento
	if velocity.x != 0:
		# Si se mueve horizontalmente, se usa la animación "right"
		$AnimatedSprite2D.animation = &"right"
		$AnimatedSprite2D.flip_v = false
		$Trail.rotation = 0
		# Si se mueve hacia la izquierda, se voltea horizontalmente
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		# Si se mueve verticalmente, se usa la animación "up"
		$AnimatedSprite2D.animation = &"up"
		# Se rota el nodo si se va hacia abajo
		rotation = PI if velocity.y > 0 else 0

# Esta función inicia al jugador en una posición específica (cuando empieza una nueva partida)
func start(pos):
	position = pos
	rotation = 0
	show()
	# Activa el área de colisión para que pueda recibir daño
	$CollisionShape2D.disabled = false

# Función que se ejecuta cuando el jugador colisiona con un cuerpo (como un enemigo)
func _on_body_entered(_body):
	# Se oculta al jugador (como si "muriera")
	hide()
	# Se emite la señal de golpe (para avisar al HUD o al Main)
	hit.emit()
	# Se desactiva el área de colisión de forma diferida (evita errores de física)
	$CollisionShape2D.set_deferred(&"disabled", true)
