extends Area2D

var anillos = []
var nro_mov = 0
var dic = {"nombre":"virus"}
var nodo_ant
var hacer_movimiento = false
var tiempo_interpo = 0
var hay_pared = false

var movimiento#VARIABLE PARA EL MOVIMIENTO
var rotar
#****************************INICIO FUNCION PARA EL MOVIMIENTO************************************************
func move(target,fin):
	movimiento.interpolate_property(self, "position",target, fin,.3,Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	movimiento.start()

func mover(target,fin):
	rotar.interpolate_property(self, "position",target, fin,2,Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	rotar.start()
	
#func _ready():
#	self.scale = Vector2(0,0)
#	movimiento=get_node("mover")
#	rotar=get_node("rotar")
#****************************FIN FUNCION PARA EL MOVIMIENTO***************************************************

func _ready():
	$"../".connect("mover_virus",self,"mover1")
	$"../".connect("envia_anillos",self,"obtener_anillos")
	movimiento=get_node("mover")
	rotar=get_node("rotar")
	
func mover1():
	if hay_pared ==  false :
		#ANILLO A CUAL SALTAR
		var salto_a_anillo = anillos.size() - nro_mov -1 
		
		if salto_a_anillo >= 0 :
			nro_mov += 1 
		else:
			salto_a_anillo = 0
		
		if nro_mov > 1 :
			nodo_ant.show()
			nodo_ant.position = dic["coordenadas"]
			dic["nodo"] = nodo_ant
			dic["nombre"] = nodo_ant.get_nombre()

		while true :
			#DIC ALEATORIO
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			var rand = rng.randi_range(0,(anillos[salto_a_anillo].size()-1))
			dic = anillos[salto_a_anillo][rand]
			if dic["nombre"] != "virus":
				break
		
		nodo_ant = dic["nodo"]
		
		nodo_ant.hide()
		dic["nodo"] = self
		dic["nombre"] = "virus"
		
		hacer_movimiento = true
		
func _physics_process(delta):
	if hacer_movimiento:
		tiempo_interpo += delta
		self.position = self.position.linear_interpolate(dic["coordenadas"],tiempo_interpo)
		if tiempo_interpo >= 1 :
			hacer_movimiento = false
			tiempo_interpo = 0

func _exit_tree():
	if nro_mov >= 1 :
		nodo_ant.show()
		nodo_ant.position = dic["coordenadas"]
		dic["nodo"] = nodo_ant
		dic["nombre"] = nodo_ant.get_nombre()
	
func obtener_anillos(vec_anillos):
	anillos = vec_anillos
#	print("anillos desde virus: ",anillos)
	pass
	
func _on_Virus_area_entered(area):
	if area.is_in_group("pared"):
		hay_pared = true
		pass
