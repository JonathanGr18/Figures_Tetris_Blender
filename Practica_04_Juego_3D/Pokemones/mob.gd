# El mob hereda de RigidBody2D, lo que significa que se mueve con física realista.
extends RigidBody2D

# Función que se ejecuta cuando el nodo entra a la escena (al iniciar)
func _ready():
	# Obtiene una lista de las animaciones disponibles en el AnimatedSprite2D (por ejemplo: "walk", "run", etc.)
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	
	# Selecciona aleatoriamente una de las animaciones
	$AnimatedSprite2D.animation = mob_types.pick_random()
	
	# Reproduce la animación seleccionada
	$AnimatedSprite2D.play()

# Función que se ejecuta cuando el mob sale de la pantalla (ya no es visible)
func _on_VisibilityNotifier2D_screen_exited():
	# Elimina el mob de la escena para liberar memoria
	queue_free()
