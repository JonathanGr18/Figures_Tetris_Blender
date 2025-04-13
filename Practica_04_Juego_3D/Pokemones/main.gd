# El script extiende de Node, por lo que es un nodo base del juego (probablemente el nodo Main).
extends Node

# Se exporta una variable que contendrá la escena del enemigo (Mob), permitiendo asignarla desde el editor.
@export var mob_scene: PackedScene

# Variable para llevar el conteo del puntaje.
var score

# Función que se llama cuando el juego termina
func game_over():
	# Se detiene el temporizador de puntaje
	$ScoreTimer.stop()
	# Se detiene el temporizador de enemigos (mobs)
	$MobTimer.stop()
	# Se muestra la pantalla de "Game Over" en el HUD
	$HUD.show_game_over()
	# Se detiene la música de fondo
	$Music.stop()
	# Se reproduce el sonido de muerte
	$DeathSound.play()

# Función que reinicia el juego (se llama al comenzar una nueva partida)
func new_game():
	# Se eliminan todos los enemigos que estén en el grupo "mobs"
	get_tree().call_group(&"mobs", &"queue_free")
	# Se reinicia el puntaje
	score = 0
	# Se coloca al jugador en la posición de inicio
	$Player.start($StartPosition.position)
	# Se inicia el temporizador para comenzar el juego tras unos segundos
	$StartTimer.start()
	# Se actualiza el puntaje mostrado en pantalla
	$HUD.update_score(score)
	# Se muestra un mensaje temporal "Get Ready"
	$HUD.show_message("Estas listoo")
	# Se reproduce la música del juego
	$Music.play()

# Función que se ejecuta cada vez que el temporizador de los mobs se activa
func _on_MobTimer_timeout():
	# Crea una nueva instancia del enemigo (Mob)
	var mob = mob_scene.instantiate()

	# Obtiene la posición aleatoria sobre el camino definido en el Path2D
	var mob_spawn_location = get_node(^"MobPath/MobSpawnLocation")
	mob_spawn_location.progress = randi()

	# Coloca al mob en esa posición aleatoria
	mob.position = mob_spawn_location.position

	# Calcula la dirección del mob de forma perpendicular al camino
	var direction = mob_spawn_location.rotation + PI / 2

	# Agrega algo de aleatoriedad a la dirección
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Se genera una velocidad aleatoria dentro de un rango
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	# Se rota esa velocidad para que se mueva en la dirección definida
	mob.linear_velocity = velocity.rotated(direction)

	# Finalmente, se añade el mob como hijo de la escena principal (Main)
	add_child(mob)

# Función que se ejecuta cada vez que el temporizador de score se activa
func _on_ScoreTimer_timeout():
	# Se incrementa el puntaje
	score += 1
	# Se actualiza el HUD con el nuevo puntaje
	$HUD.update_score(score)

# Función que se ejecuta cuando termina el StartTimer (es decir, cuando empieza el juego realmente)
func _on_StartTimer_timeout():
	# Se inicia el temporizador que genera mobs
	$MobTimer.start()
	# Se inicia el temporizador que actualiza el puntaje
	$ScoreTimer.start()
