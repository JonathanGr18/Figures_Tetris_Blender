# Este script extiende de CanvasLayer, que se usa para dibujar elementos de interfaz (UI) encima del juego.
extends CanvasLayer

# Se define una señal personalizada que se emitirá cuando el jugador presione el botón de empezar el juego.
signal start_game

# Función para mostrar un mensaje temporal en pantalla
func show_message(text):
	# Asigna el texto al label "MessageLabel"
	$MessageLabel.text = text
	# Muestra el label
	$MessageLabel.show()
	# Inicia el temporizador para ocultar el mensaje luego de un tiempo
	$MessageTimer.start()

# Función para mostrar el mensaje de "Game Over" y reiniciar la UI
func show_game_over():
	# Muestra el mensaje "Game Over"
	show_message("Perdiste")
	# Espera a que el temporizador termine para continuar (espera asincrónica)
	await $MessageTimer.timeout
	# Cambia el texto a una especie de pantalla de título
	$MessageLabel.text = "Esquiva los\nPokemones"
	# Muestra el nuevo mensaje
	$MessageLabel.show()
	# Espera 1 segundo antes de mostrar el botón de empezar
	await get_tree().create_timer(1).timeout
	# Muestra el botón de empezar (StartButton)
	$StartButton.show()

# Función para actualizar el puntaje mostrado en pantalla
func update_score(score):
	# Convierte el puntaje a string y lo muestra en el ScoreLabel
	$ScoreLabel.text = str(score)

# Función que se llama cuando se presiona el botón de inicio
func _on_StartButton_pressed():
	# Oculta el botón de inicio
	$StartButton.hide()
	# Emite la señal de que el juego ha comenzado
	start_game.emit()

# Función que se llama cuando el temporizador de mensaje termina
func _on_MessageTimer_timeout():
	# Oculta el mensaje
	$MessageLabel.hide()
