extends Area2D

export var nombre ="negro"
signal envi_id(mi_id)
signal envi_id_intercambio(mi_id)

var crecer = true

var movimiento#VARIABLE PARA EL MOVIMIENTO
var rotar
#****************************INICIO FUNCION PARA EL MOVIMIENTO************************************************
#func move(target,fin):
#	movimiento.interpolate_property(self, "position",target, fin,.3,Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#	movimiento.start()
#
#func mover(target,fin):
#	rotar.interpolate_property(self, "position",target, fin,2,Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#	rotar.start()
	

#****************************FIN FUNCION PARA EL MOVIMIENTO***************************************************

func _process(delta):
	crecer(delta)
#
func crecer(delta):
	if crecer:
		self.scale += Vector2(0.1 , 0.1) * delta
		if self.scale > Vector2(global.escala , global.escala) :
			crecer = false  
#		if self.scale > Vector2(0.2 , 0.2) :
#			crecer = false  

func get_nombre():
	return nombre

#func _on_Amarillo_input_event(viewport, event, shape_idx):
#	if event is InputEventScreenTouch:
#		if event.is_pressed():
#			emit_signal("envi_id",self.get_instance_id())
#		if !event.is_pressed() :
#			emit_signal("envi_id_intercambio",self.get_instance_id())


#****************************INICIO FUNCION PARA EL MOVIMIENTO************************************************
func move(target,fin):
	movimiento.interpolate_property(self, "position",target, fin,.3,Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	movimiento.start()

func mover(target,fin):
	rotar.interpolate_property(self, "position",target, fin,2,Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	rotar.start()
	
func _ready():
	self.scale = Vector2(0,0)
	movimiento=get_node("mover")
	rotar=get_node("rotar")
#****************************FIN FUNCION PARA EL MOVIMIENTO***************************************************


func _on_GenericoBolita_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			emit_signal("envi_id",self.get_instance_id())
		if !event.is_pressed() :
			emit_signal("envi_id_intercambio",self.get_instance_id())
	pass # Replace with function body.


func _on_Amarillo_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			emit_signal("envi_id",self.get_instance_id())
		if !event.is_pressed() :
			emit_signal("envi_id_intercambio",self.get_instance_id())
	pass # Replace with function body.


func _on_Azul_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			emit_signal("envi_id",self.get_instance_id())
		if !event.is_pressed() :
			emit_signal("envi_id_intercambio",self.get_instance_id())
	pass # Replace with function body.


func _on_Lila_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			emit_signal("envi_id",self.get_instance_id())
		if !event.is_pressed() :
			emit_signal("envi_id_intercambio",self.get_instance_id())
	pass # Replace with function body.


func _on_Naranja_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			emit_signal("envi_id",self.get_instance_id())
		if !event.is_pressed() :
			emit_signal("envi_id_intercambio",self.get_instance_id())

func _on_Rojo_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			emit_signal("envi_id",self.get_instance_id())
		if !event.is_pressed() :
			emit_signal("envi_id_intercambio",self.get_instance_id())
			pass # Replace with function body.

func _on_Verde_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			emit_signal("envi_id",self.get_instance_id())
		if !event.is_pressed() :
			emit_signal("envi_id_intercambio",self.get_instance_id())
			pass # Replace with function body.

