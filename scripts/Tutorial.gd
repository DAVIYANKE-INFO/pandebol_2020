extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.global_position = Vector2(0,0)
	$AnimationPlayer.play("animacion")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _exit_tree():
	global.nivel = 0
func _on_Button_button_down():
	self.queue_free()
	pass # Replace with function body.
