extends Node2D

var c = 0 #posicion de cada bola
var radio = global.radio
var vec_nodo = []
var vec_anillos =[]
var vec_obj = []

var amarillo = preload("res://escenas/bolitas/Amarillo.tscn")
var azul = preload("res://escenas/bolitas/Azul.tscn")
var lila = preload("res://escenas/bolitas/Lila.tscn")
var rojo = preload("res://escenas/bolitas/Rojo.tscn")
var naranja = preload("res://escenas/bolitas/Naranja.tscn")
var verde = preload("res://escenas/bolitas/Verde.tscn")

var nodo_select_id
var nodo_intercambio_id

var dic_seleccionado
var dic_a_intercambiar
var hacer_interpolacion = false
var tiempo_interpolacion = 0

var nro_movidas = 0
signal mover_virus
signal envia_anillos(anillos)

var vir_preload = preload("res://escenas/Virus.tscn")

var nodo = []

var vec_anillos_aux=[]
var posicion1
var posicion2
#********************PARA LA VERIFICACION DE POSIBLES JUGADAS******************
var vectoraux=[]
var vectoraux2=[]
var almacena
var alma
var nodo_adyacente_1
var nodo_adyacente_3
#********************FIN PARA LA VERIFICACION DE POSIBLES JUGADAS******************

var nro_virus_a_eliminar = global.nro_virus_a_eliminar
var velocidad_virus = global.velocidad_virus

var cant_virus = 3

func _ready():
	#TUTORIAL PARA EL PRIMER NIVEL
	if global.nivel == 1 :
		var tuto =preload("res://escenas/Tutorial.tscn")
		var insTuto = tuto.instance()
		add_child(insTuto)
	ocultar_botones_poder()
	ocultar_paredes()
	#OCULTAR PANTALLA GANAR
	$Ganar.scale = Vector2(0.0,0.0)
	#establecer label de meta
	$meta/Panel/Label.text = "Elimina a " + str(nro_virus_a_eliminar) +" Virus"
	#ocultar pantalla perder
	$Perder.scale = Vector2(0,0)
	vec_obj = [amarillo,azul,lila,verde,naranja,rojo]
	mostrar_anillos(global.nro_anillos)
	sistema_verifica_continuos()


func mostrar_anillos(num):
	for i in num:
		genera_anillo(i+1)
func genera_anillo(nro_anillo):
	c = 0
	var angulo = (60.0 / nro_anillo)
	var angini = (angulo * ((nro_anillo - 1)/2.0)) + angulo + 30
	var suma = angulo
	var nro_veces = (360/angulo)
#	var radio_anillo = global.radio * nro_anillo
	var radio_anillo = radio * nro_anillo

	vec_nodo = []

	for i in range(nro_veces):
		var pendiente = tan(deg2rad(angini))
		var corX
		var corY
		
		corX = sqrt((radio_anillo*radio_anillo)/(1+(pendiente * pendiente)))
		corY = sqrt((radio_anillo*radio_anillo)-(corX*corX))

		if angini > 90 and angini <= 180  :
			corX *= (-1)
		if angini > 180 and angini <= 270 :
			corX *= (-1)
			corY *= (-1)
		if angini > 270 and angini <= 360 :
			corY *= (-1)
	
		var obj = obj_aleatorio()
		
		#ASIGNA AL DICCIONARIO CREADO TODOS SUS PARAMETROS
		c = c + 1
		obj["posicion"] = (c)
		obj["seccion"] = seccion(obj["posicion"],nro_anillo)
		obj["anillo"] = nro_anillo
		obj["coordenadas"] = Vector2(corX,corY)
		
		#**********INICIO CODIGO AUMENTADO PARA EN TEMA DE LA INTERPOLACION***************
#		nodo_principal=get_node("/root/Principal")
		obj["eje_pixel_x"]=corX
		obj["eje_pixel_y"]=corY
		#**********FIN CODIGO AUMENTADO PARA EN TEMA DE LA INTERPOLACION******************
		
		obj["nodo"].position = obj["coordenadas"]
		obj["nodo"].connect("envi_id",self,"obtiene_nodo_select")
		obj["nodo"].connect("envi_id_intercambio",self,"obtiene_nodo_intercambio")

		vec_nodo.append(obj)
		add_child(obj["nodo"])
		angini += suma
		
	vec_anillos.append(vec_nodo)
	
func _physics_process(delta):
	intercambia(delta)
	pass

func intercambia(delta):
	if nodo_intercambio_id != null and nodo_select_id != null :

		var aux_nodo
		var aux_id
		var aux_nombre 
	
		var vec  = restringemovida()
	
		if vec.find(busca_dic(nodo_intercambio_id))>=0 :
			dic_seleccionado = busca_dic(nodo_select_id)
			dic_a_intercambiar = busca_dic(nodo_intercambio_id)

			aux_nodo = dic_a_intercambiar["nodo"]
			aux_id = dic_a_intercambiar["id"]
			aux_nombre = dic_a_intercambiar["nombre"]
	
			dic_a_intercambiar["nodo"] = dic_seleccionado["nodo"]
			dic_a_intercambiar["id"] = dic_seleccionado["id"]
			dic_a_intercambiar["nombre"] = dic_seleccionado["nombre"]
	
			dic_seleccionado["nodo"] = aux_nodo
			dic_seleccionado["id"] = aux_id
			dic_seleccionado["nombre"] = aux_nombre

			hacer_interpolacion = true
			crear_virus()
			sistema_verifica_continuos()
			posibles_jugadas()

		nodo_intercambio_id = null
		nodo_select_id = null
		
	if hacer_interpolacion: 
		tiempo_interpolacion += delta
		dic_seleccionado["nodo"].position = dic_seleccionado["nodo"].position.linear_interpolate(dic_seleccionado["coordenadas"],tiempo_interpolacion)
		dic_a_intercambiar["nodo"].position = dic_a_intercambiar["nodo"].position.linear_interpolate(dic_a_intercambiar["coordenadas"],tiempo_interpolacion)
		if tiempo_interpolacion >=1:
			tiempo_interpolacion = 0
			hacer_interpolacion = false

func sistema_verifica_continuos():
	#print("entro func")
	while verifica_continuos()["hay_continuos"] :
		#print(verifica_continuos()["hay_continuos"])
		#print("entro sistema de verificacion")
		#print(verifica_continuos()["ver1"].size())
		#print(verifica_continuos()["ver2"].size())
		aumenta_poder(verifica_continuos()["ver1"],verifica_continuos()["ver2"])
		renueva_obj_dic(verifica_continuos()["ver1"],verifica_continuos()["ver2"])
		posibles_jugadas()


func restringemovida():#DEVUELVE TODOS LOS COLINDANTES
	var nodes = []
	dic_seleccionado = busca_dic(nodo_select_id)
#	print("DIC SELECCIONADO: ",dic_seleccionado)
	if dic_seleccionado != null :
	#	for dic_seleccionado in vec_iguales:
		var seccion = dic_seleccionado["seccion"]
		var anillo = dic_seleccionado["anillo"]
		var posicion = dic_seleccionado["posicion"]
#		VERIFICACION ATRAS
		if posicion == 1:
			var obj_dic = encuentra_obj_dic(anillo, anillo * 6 )
			nodes.append(obj_dic)
		else:
			var obj_dic = encuentra_obj_dic(anillo, posicion-1 )
			nodes.append(obj_dic)
				#VERIFICACION ADELANTE
		if posicion == (anillo*6): # es el ultimo?
			var obj_dic = encuentra_obj_dic(anillo, 1 )
			nodes.append(obj_dic)
		else:
			var obj_dic = encuentra_obj_dic(anillo, posicion + 1 )
			nodes.append(obj_dic)
			#VERIFICACION ARRIBA
		if anillo != vec_anillos.size():
			var obj_dic = encuentra_obj_dic(anillo+1, posicion + seccion)
			nodes.append(obj_dic)
			var obj_dic2 = encuentra_obj_dic(anillo+1, posicion + seccion -1)
			nodes.append(obj_dic2)
			#VERIFICACION ABAJO
		if anillo != 1: #es distinto del primeranillo?
			if posicion != 1: # la posicion 1 nunca podra intercambiar con el primero de abajo 
				var obj_dic = encuentra_obj_dic(anillo-1, posicion - seccion)
				if obj_dic["seccion"] == seccion :
					nodes.append(obj_dic)
			if posicion != (anillo * 6):
				var obj_dic2 = encuentra_obj_dic(anillo-1, posicion - seccion+1)
				if obj_dic2["seccion"] == seccion :
					nodes.append(obj_dic2)
	return nodes

func verifica_continuos():
#VERIFICA LAS EXPLOSIONES
	var ver1 = []
	var ver2 = []
	var vec_nuevos_ver1 = []
	var vec_nuevos_ver2 = []
	var vec_nuevos = []
	
	var hay_continuos = false
	
	for i in vec_anillos:
		for j in i : # j ES CADA VECTOR ANILLO
			var vec_igual_ver1 = []
			var vec_igual_ver2 = []
			vec_igual_ver1.append(j)
			vec_igual_ver2.append(j)
			for k in vec_igual_ver1:
				var nombre_obj = k["nombre"]
				var seccion = k["seccion"]
				var anillo = k["anillo"]
				var posicion = k["posicion"]
				var nodo = k["nodo"]
				#VERIFICACION ARRIBA
				if anillo != vec_anillos.size():
					var obj_dic = encuentra_obj_dic(anillo+1, posicion + seccion)
					if obj_dic["nombre"] == nombre_obj and vec_igual_ver1.find(obj_dic) < 0 and obj_dic["nombre"] != "virus":
						vec_igual_ver1.append(obj_dic)
				#VERIFICACION ABAJO
				if anillo != 1: #es distinto del primer anillo?
					if posicion != 1: # la posicion 1 nunca podra intercambiar con el primero de abajo 
						var obj_dic = encuentra_obj_dic(anillo-1, posicion - seccion)
						if obj_dic["nombre"] == nombre_obj and obj_dic["seccion"] == seccion and vec_igual_ver1.find(obj_dic) < 0 and obj_dic["nombre"] != "virus":
							vec_igual_ver1.append(obj_dic)
			for x in vec_igual_ver1:
				if vec_igual_ver1.size() > 2:
					x["nodo"].set_scale(Vector2(0.5,0.5))
					if vec_nuevos.find(x) < 0:#CORRIGE DICCIONARIOS IGUALES EN EL VECTOR
						vec_nuevos.append(x) # para crear nuevos obj_dic
						vec_nuevos_ver1.append(x)

			for k in vec_igual_ver2:
				var nombre_obj = k["nombre"]
				var seccion = k["seccion"]
				var anillo = k["anillo"]
				var posicion = k["posicion"]
				var nodo = k["nodo"]
				#VERIFICACION ARRIBA
				if anillo != vec_anillos.size():
					var obj_dic2 = encuentra_obj_dic(anillo+1, posicion + seccion -1)
					if obj_dic2["nombre"] == nombre_obj and vec_igual_ver2.find(obj_dic2)< 0 and obj_dic2["nombre"] != "virus":
						vec_igual_ver2.append(obj_dic2)
				#VERIFICACION ABAJO
				if anillo != 1: #es distinto del primeranillo?
					if posicion != (anillo * 6):
						var obj_dic2 = encuentra_obj_dic(anillo-1, posicion - seccion+1)
						if obj_dic2["nombre"] == nombre_obj and obj_dic2["seccion"] == seccion and vec_igual_ver2.find(obj_dic2) < 0 and obj_dic2["nombre"] != "virus":
							vec_igual_ver2.append(obj_dic2)
			for x in vec_igual_ver2:
				if vec_igual_ver2.size() > 2:
					x["nodo"].set_scale(Vector2(0.5,0.5))
					if vec_nuevos.find(x) < 0:#CORRIGE DICCIONARIOS IGUALES EN EL VECTOR
						vec_nuevos.append(x) # para crear nuevos obj_dic
						vec_nuevos_ver2.append(x)
			
			if vec_nuevos_ver1 != null and  ver1.find(vec_nuevos_ver1) < 0 and (vec_nuevos_ver1.size() >= 1 ):
				ver1.append(vec_nuevos_ver1)
				vec_nuevos_ver1 = []

			if vec_nuevos_ver2 != null and ver2.find(vec_nuevos_ver2) < 0 and  (vec_nuevos_ver2.size() >= 1):
				ver2.append(vec_nuevos_ver2)
				vec_nuevos_ver2 = []

	if ver1.size() > 0 or ver2.size() > 0:
		hay_continuos = true
		
	return {"hay_continuos":hay_continuos, "ver1":ver1, "ver2":ver2}

func aumenta_poder(ver1,ver2):
	for i in ver1 :
		match i[0]["nombre"]:
			"rojo":
				$BarraProgreso/TextureProgress.value += 10
				$BarraProgreso/TextureProgress/Label.text = str($BarraProgreso/TextureProgress.value)
				if $BarraProgreso/TextureProgress.value >= 50 :
					$BotonesPoder/TextureButton1.show()
			"amarillo":
				$BarraProgreso/TextureProgress2.value += 10
				$BarraProgreso/TextureProgress2/Label2.text = str($BarraProgreso/TextureProgress2.value)
				if $BarraProgreso/TextureProgress2.value >= 50 :
					$BotonesPoder/TextureButton2.show()
			"verde":
				$BarraProgreso/TextureProgress3.value += 10
				$BarraProgreso/TextureProgress3/Label3.text = str($BarraProgreso/TextureProgress3.value)
				if $BarraProgreso/TextureProgress3.value >= 50 :
					$BotonesPoder/TextureButton3.show()
			"lila":
				$BarraProgreso/TextureProgress4.value += 10
				$BarraProgreso/TextureProgress4/Label4.text = str($BarraProgreso/TextureProgress4.value)
				if $BarraProgreso/TextureProgress4.value >= 50 :
					$BotonesPoder/TextureButton4.show()
			"naranja":
				$BarraProgreso/TextureProgress5.value += 10
				$BarraProgreso/TextureProgress5/Label5.text = str($BarraProgreso/TextureProgress5.value)
				if $BarraProgreso/TextureProgress5.value >= 50 :
					$BotonesPoder/TextureButton5.show()
			"azul":
				$BarraProgreso/TextureProgress6.value += 10
				$BarraProgreso/TextureProgress6/Label6.text = str($BarraProgreso/TextureProgress6.value)
				if $BarraProgreso/TextureProgress6.value >= 50 :
					$BotonesPoder/TextureButton6.show()
				
	for i in ver2 :
		match i[0]["nombre"]:
			"rojo":
				$BarraProgreso/TextureProgress.value += 10
				$BarraProgreso/TextureProgress/Label.text = str($BarraProgreso/TextureProgress.value)
				if $BarraProgreso/TextureProgress.value >= 50 :
					$BotonesPoder/TextureButton1.show()
			"amarillo":
				$BarraProgreso/TextureProgress2.value += 10
				$BarraProgreso/TextureProgress2/Label2.text = str($BarraProgreso/TextureProgress2.value)
				if $BarraProgreso/TextureProgress2.value >= 50 :
					$BotonesPoder/TextureButton2.show()
			"verde":
				$BarraProgreso/TextureProgress3.value += 10
				$BarraProgreso/TextureProgress3/Label3.text = str($BarraProgreso/TextureProgress3.value)
				if $BarraProgreso/TextureProgress3.value >= 50 :
					$BotonesPoder/TextureButton3.show()
			"lila":
				$BarraProgreso/TextureProgress4.value += 10
				$BarraProgreso/TextureProgress4/Label4.text = str($BarraProgreso/TextureProgress4.value)
				if $BarraProgreso/TextureProgress4.value >= 50 :
					$BotonesPoder/TextureButton4.show()
			"naranja":
				$BarraProgreso/TextureProgress5.value += 10
				$BarraProgreso/TextureProgress5/Label5.text = str($BarraProgreso/TextureProgress5.value)
				if $BarraProgreso/TextureProgress5.value >= 50 :
					$BotonesPoder/TextureButton5.show()
			"azul":
				$BarraProgreso/TextureProgress6.value += 10
				$BarraProgreso/TextureProgress6/Label6.text = str($BarraProgreso/TextureProgress6.value)
				if $BarraProgreso/TextureProgress6.value >= 50 :
					$BotonesPoder/TextureButton6.show()
					

func ganar():
	#print("NIVEL --->  ",global.nivel_actual)
	$Ganar.scale = Vector2(1,1)
	$Ganar.show()
	$Ganar/AnimationPlayer.play("ganar")
	yield($Ganar/AnimationPlayer,"animation_finished")
	#GANASTE EL JUEGO
	if global.nivel == 24 :
		global.cambia_escenita("res://escenas/Creditos.tscn")
	else :
		global.cambia_escenita("res://escenas/Niveles.tscn")
	
	if global.nivel_actual!=24:
		global.guardar_partida(global.nivel_actual+1)
	else:
		global.guardar_partida(global.nivel_actual)
	
func renueva_obj_dic(ver1,ver2):
#RENUEVA OBJETO DICCIONARIO
	for i in ver1:
		for j in i:
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			var rand = rng.randi_range(0,5)
			var nue_obj = vec_obj[rand].instance()
			
			add_child(nue_obj)
			j["nodo"].queue_free()
			j["nodo"] = nue_obj
			j["nombre"] = nue_obj.get_nombre()
			j["id"] = nue_obj.get_instance_id()
			j["nodo"].position = j["coordenadas"]
			j["nodo"].connect("envi_id",self,"obtiene_nodo_select")
			j["nodo"].connect("envi_id_intercambio",self,"obtiene_nodo_intercambio")
			#ANIMACION DE EXPLOSION
			explotar(j["coordenadas"])
#			print("renovacion de objetos")
	for i in ver2:
		for j in i:
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			var rand = rng.randi_range(0,5)
			var nue_obj = vec_obj[rand].instance()
			
			add_child(nue_obj)
			j["nodo"].queue_free()
			j["nodo"] = nue_obj
			j["nombre"] = nue_obj.get_nombre()
			j["id"] = nue_obj.get_instance_id()
			j["nodo"].position = j["coordenadas"]
			j["nodo"].connect("envi_id",self,"obtiene_nodo_select")
			j["nodo"].connect("envi_id_intercambio",self,"obtiene_nodo_intercambio")
			#ANIMACION DE EXPLOSION
			explotar(j["coordenadas"])
#			print("renovacion de objetos")

#	vec_nuevos = []
	ver1 = []
	ver2 = []
	

#RECUPERAMOS EL ID DE LA BOLA CON LA QUE QUEREMOS INTERCAMBIAR 
func obtiene_nodo_intercambio(id):
	nodo_intercambio_id = id
#	print(busca_dic(id)["nombre"]  + str("ggggg"))
	pass

#RECUPERAMOS EL ID DE LA BOLA QUE TOCAMOS
func obtiene_nodo_select(id):
	nodo_select_id = id
#	print(busca_dic(id)["nombre"]+ str("ggggg"))

func obj_aleatorio():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rand = rng.randi_range(0,5)
	
	var nue_obj = vec_obj[rand].instance()
#	print(nue_obj.get_nombre())

	var dic_obj = {"nombre":nue_obj.get_nombre(), "seccion":0,"anillo":0, "posicion":0,"nodo":nue_obj, "coordenadas":Vector2(0,0), "id":nue_obj.get_instance_id()}
	return dic_obj
	
func seccion(pos,anillo):
	var r :float 
	r = float(pos) / float(anillo)
	return ceil(r)

#RETORNA EL OBJETO DICCIONARIO DADO EL ANILLO Y LA POSICION
func encuentra_obj_dic(anillo,pos):
	for i in vec_anillos :
		for j in i :
			if j["anillo"] == anillo and j["posicion"] == pos:
				return j

func busca_dic(id):
	for i in vec_anillos:
		for j in i :
			if j["id"] == id:
#				if j == null:
#					print("nulllll")
				return j

func explotar(position):
	$ParticlesExplo.position = position
	$ParticlesExplo.emitting = true

func crear_virus():
	nro_movidas += 1
	
	if nro_movidas % velocidad_virus == 0 :
		#MUEVE LOS VIRUS ANTERIORES
#		var vec_virus = get_tree().get_nodes_in_group("virus")
#		if vec_virus.size() > 0 :
#			emit_signal("envia_anillos",vec_anillos)
#			emit_signal("mover_virus")
		emit_signal("envia_anillos",vec_anillos)
		emit_signal("mover_virus")
		
		# CREA VIRUS Y DA POSICION
		for i in range(cant_virus):
			var vir = vir_preload.instance()
			add_child(vir)
			
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			var rand = rng.randi_range(0,5)
			
			match rand:
				0:
					vir.position = $Node/Position2D.position
					pass
				1:
					vir.position = $Node/Position2D2.position
					pass
				2:
					vir.position = $Node/Position2D3.position
					pass
				3:
					vir.position = $Node/Position2D4.position
					pass
				4:
					vir.position = $Node/Position2D5.position
					pass
				5:
					vir.position = $Node/Position2D6.position
					pass
	# VERIFICACION DE VIRUS EN EL PRIMER ANILLO PARA PERDER JUEGO
	for i in vec_anillos[0]:
		if i["nombre"] == "virus":
#			print(vec_anillos[0])
			perder()
			pass
#	for i in vec_anillos:
#		print(i)

func perder():
	$Perder.scale = Vector2(1,1)
	$Perder.show()
	$Ganar/AnimationPlayer.play("perder")
	yield($Ganar/AnimationPlayer,"animation_finished")
	global.cambia_escenita("res://escenas/Niveles.tscn")


func ocultar_botones_poder():
	$BotonesPoder/TextureButton1.hide()
	$BotonesPoder/TextureButton2.hide()
	$BotonesPoder/TextureButton3.hide()
	$BotonesPoder/TextureButton4.hide()
	$BotonesPoder/TextureButton5.hide()
	$BotonesPoder/TextureButton6.hide()

func ocultar_paredes():
	$Paredes/Area2D.hide()
	$Paredes/Area2D2.hide()
	$Paredes/Area2D3.hide()
	$Paredes/Area2D4.hide()
	$Paredes/Area2D5.hide()
	$Paredes/Area2D6.hide()
	$Paredes/Area2D/CollisionShape2D.disabled = true
	$Paredes/Area2D2/CollisionShape2D.disabled = true
	$Paredes/Area2D3/CollisionShape2D.disabled = true
	$Paredes/Area2D4/CollisionShape2D.disabled = true
	$Paredes/Area2D5/CollisionShape2D.disabled = true
	$Paredes/Area2D6/CollisionShape2D.disabled = true
	
# BOTONES DE PODER
func _on_TextureButton1_button_down():
	$BarraProgreso/TextureProgress.value = $BarraProgreso/TextureProgress.value-50
	$BarraProgreso/TextureProgress/Label.text = str($BarraProgreso/TextureProgress.value)
	if $BarraProgreso/TextureProgress.value < 50 :
		$BotonesPoder/TextureButton1.hide()
	$Paredes/Area2D.show()
	elimina_virus()
	$Paredes/Area2D/CollisionShape2D.disabled = false
	$ParticlesLadrillo.global_position = $Paredes/Area2D/CollisionShape2D.global_position
	$ParticlesLadrillo.emitting = true
	
func _on_TextureButton2_button_down():
	$BarraProgreso/TextureProgress2.value = $BarraProgreso/TextureProgress2.value-50
	$BarraProgreso/TextureProgress2/Label2.text = str($BarraProgreso/TextureProgress2.value)
	if $BarraProgreso/TextureProgress2.value < 50 :
		$BotonesPoder/TextureButton2.hide()
	$Paredes/Area2D2.show()
	$Paredes/Area2D2/CollisionShape2D.disabled = false
	elimina_virus()
	$ParticlesLadrillo.global_position = $Paredes/Area2D2/CollisionShape2D.global_position
	$ParticlesLadrillo.emitting = true
	
	pass # Replace with function body.

func _on_TextureButton3_button_down():
	$BarraProgreso/TextureProgress3.value = $BarraProgreso/TextureProgress3.value-50
	$BarraProgreso/TextureProgress3/Label3.text = str($BarraProgreso/TextureProgress3.value)
	if $BarraProgreso/TextureProgress3.value < 50 :
		$BotonesPoder/TextureButton3.hide()
	$Paredes/Area2D3.show()
	$Paredes/Area2D3/CollisionShape2D.disabled = false
	elimina_virus()
	$ParticlesLadrillo.global_position = $Paredes/Area2D3/CollisionShape2D.global_position
	$ParticlesLadrillo.emitting = true

func _on_TextureButton4_button_down():
	$BarraProgreso/TextureProgress4.value = $BarraProgreso/TextureProgress4.value-50
	$BarraProgreso/TextureProgress4/Label4.text = str($BarraProgreso/TextureProgress4.value)
	if $BarraProgreso/TextureProgress4.value < 50 :
		$BotonesPoder/TextureButton4.hide()
	$Paredes/Area2D4.show()
	$Paredes/Area2D4/CollisionShape2D.disabled = false
	elimina_virus()
	$ParticlesLadrillo.global_position = $Paredes/Area2D4/CollisionShape2D.global_position
	$ParticlesLadrillo.emitting = true

func _on_TextureButton5_button_down():
	$BarraProgreso/TextureProgress5.value = $BarraProgreso/TextureProgress5.value-50
	$BarraProgreso/TextureProgress5/Label5.text = str($BarraProgreso/TextureProgress5.value)
	if $BarraProgreso/TextureProgress5.value < 50 :
		$BotonesPoder/TextureButton5.hide()
	$Paredes/Area2D5.show()
	$Paredes/Area2D5/CollisionShape2D.disabled = false
	elimina_virus()
	$ParticlesLadrillo.global_position = $Paredes/Area2D5/CollisionShape2D.global_position
	$ParticlesLadrillo.emitting = true

func _on_TextureButton6_button_down():
	$BarraProgreso/TextureProgress6.value = $BarraProgreso/TextureProgress6.value-50
	$BarraProgreso/TextureProgress6/Label6.text = str($BarraProgreso/TextureProgress6.value)
	if $BarraProgreso/TextureProgress6.value < 50 :
		$BotonesPoder/TextureButton6.hide()
	$Paredes/Area2D6.show()
	$Paredes/Area2D6/CollisionShape2D.disabled = false
	elimina_virus()
	$ParticlesLadrillo.global_position = $Paredes/Area2D6/CollisionShape2D.global_position
	$ParticlesLadrillo.emitting = true

func elimina_virus():
	var vec_virus = get_tree().get_nodes_in_group("virus")
	if vec_virus.size() > 0:
		vec_virus[0].queue_free()
		$ParticlesBurbujas.position = vec_virus[0].position
		$ParticlesBurbujas.emitting = true
		sistema_verifica_continuos()
		#VERIFICACION DE CANTIDAD DE VIRUS ELIMINADOS
		nro_virus_a_eliminar -= 1
		$meta/Panel/Label.text = "Elimina a " + str(nro_virus_a_eliminar) +" Virus"
		if nro_virus_a_eliminar <= 0 :
			ganar()

func encontrar_coincidencias():
	vectoraux=[]
	for e in vec_anillos.size():
		if e+1>=3: #&& e+1<=vec_anillos.size()-1:
			var nronodosanillo=vec_anillos[e].size()
			var nodo_color
			var nodo_patron
			var nodo_bloque
			var nodo_anillo
			var bloq1
			var bloq2
			var nuevo_patron_1
			var nuevo_patron_2
			var contador=1
			var adyacentes=[]
			for f in vec_anillos[e].size():
				nodo_color=vec_anillos[e][f]["nombre"]
				nodo_patron=vec_anillos[e][f]["posicion"]
				nodo_bloque=vec_anillos[e][f]["seccion"]
				nodo_anillo=vec_anillos[e][f]["anillo"]
				nuevo_patron_1=nodo_patron-1;
				nuevo_patron_2=nodo_patron+1;
				if contador==1:
					bloq1=nodo_bloque-1;
				else:
					bloq1=nodo_bloque;
				if contador==nodo_anillo:
					contador=0;
					bloq2=nodo_bloque+1
				else:
					bloq2=nodo_bloque;
				contador=contador+1;
				if bloq1==0 || bloq2==7:
					if bloq1==0:
						nuevo_patron_1=nronodosanillo;
						nodo_adyacente_1 = buscar_nodo(nodo_anillo,6,nuevo_patron_1);
						nodo_adyacente_3 = buscar_nodo(nodo_anillo,bloq2,nuevo_patron_2);
					if bloq2==7:
						nuevo_patron_2=1;
						nodo_adyacente_1 = buscar_nodo(nodo_anillo,bloq1,nuevo_patron_1);
						nodo_adyacente_3 = buscar_nodo(nodo_anillo,1,nuevo_patron_2);
				else:
					nodo_adyacente_1 = buscar_nodo(nodo_anillo,bloq1,nuevo_patron_1);
					nodo_adyacente_3 = buscar_nodo(nodo_anillo,bloq2,nuevo_patron_2);
					
				adyacentes.append({"nodoant":nodo_adyacente_1,"nodosig":nodo_adyacente_3})
			vectoraux.append(adyacentes)

func encontrar_coincidencias_2():
	vectoraux2=[]
	#puntos_finales = ordenar(puntos_finales);
	var nodo_color
	for e in vec_anillos.size():
		if e+1>=3 && e+1<=vec_anillos.size()-1:
			var cont=1;
			var dia_1;
			var dia_2;
			var adyacentes2=[]
			for f in vec_anillos[e].size():
				if vec_anillos[e][f]["nodo"]!=null:
					nodo_color=vec_anillos[e][f]["nombre"];
					var nodo_patron=vec_anillos[e][f]["posicion"];
					var nodo_bloque=vec_anillos[e][f]["seccion"];
					var nodo_anillo=vec_anillos[e][f]["anillo"];
					if cont==1 || cont==e+1:
						if ((f+1)%(e+1))==0:
							dia_1=buscar_nodo(nodo_anillo-1,nodo_bloque,nodo_patron-nodo_bloque);
							dia_2=buscar_nodo(nodo_anillo+1,nodo_bloque,nodo_patron+nodo_bloque);
							cont=0;
						else:
							dia_1=buscar_nodo(nodo_anillo-1,nodo_bloque,nodo_patron-(nodo_bloque-1));
							dia_2=buscar_nodo(nodo_anillo+1,nodo_bloque,nodo_patron+(nodo_bloque-1));
					else:
						for j in ((e+1)-2):
							dia_1=buscar_nodo(nodo_anillo-1,nodo_bloque,nodo_patron-nodo_bloque);
							dia_2=buscar_nodo(nodo_anillo+1,nodo_bloque,nodo_patron+nodo_bloque);
#							
							if j<1:
								adyacentes2.append({"nodoantiguo":dia_1,"nodofuturo":dia_2})
								
							dia_1=buscar_nodo(nodo_anillo-1,nodo_bloque,nodo_patron-(nodo_bloque-1));
							dia_2=buscar_nodo(nodo_anillo+1,nodo_bloque,nodo_patron+(nodo_bloque-1));
					adyacentes2.append({"nodoantiguo":dia_1,"nodofuturo":dia_2})
					cont=cont+1;
			vectoraux2.append(adyacentes2)
			
func buscar_nodo(anillo,bloque,patron):
	for l in vec_anillos.size():
		if l+1==anillo:
			for jj in vec_anillos[l].size():
				if vec_anillos[l][jj]["seccion"]==bloque:
					if vec_anillos[l][jj]["posicion"]==patron:
						return (vec_anillos[l][jj]);

func generar():
	var almacen
	almacena=[]
	for d in vectoraux2.size():
		almacen=[]
		var cuenta=d+1
		var conj=1
		var anillo=cuenta+2
		var a=0
		while a<vectoraux2[d].size():
			if conj==1||conj==anillo:
				if conj==1:
					almacen.append(vectoraux2[d][a])
				if conj==anillo:
					almacen.append(vectoraux2[d][a])
					conj=0
			else:
				for j in cuenta:
					alma=[]
					alma.append(vectoraux2[d][a])
					alma.append(vectoraux2[d][a+1])
					almacen.append(alma)
					if anillo==3:
						a=a+cuenta
					if anillo==4||anillo==5:
						a=a+2
				conj=cuenta+1
				if anillo==4||anillo==5:
					a=a-1
			conj=conj+1
			a=a+1
		almacena.append(almacen)

func posibles_jugadas():
	encontrar_coincidencias()
	encontrar_coincidencias_2()
	generar()
	var anill
	for i in nodo :
		i.get_node("Sprite").material = null
	
	nodo = []
	for r in range(2,vec_anillos.size(),1):
		var contadorsito=1
		anill=r+1
		var color
		var mascolor
		for s in vec_anillos[r].size():
			var bloquesito=vec_anillos[r][s]["seccion"]
			var patronsito=vec_anillos[r][s]["posicion"]
			var antiguo1
			var masantiguo1
			var antiguo2
			var masantiguo2
			if contadorsito==1||contadorsito==anill:
				if contadorsito==1:
					antiguo1=buscar_nodo(anill-1,bloquesito,patronsito-(bloquesito-1))
					masantiguo1=buscar_nodo(anill-2,bloquesito,patronsito-((bloquesito-1)*2))
					color=antiguo1.nombre
					mascolor=masantiguo1.nombre
					if color==mascolor:
						if (r+1)==vec_anillos.size():
							#AQUI ES POR ANILLOS 2 VERIFICACIONES
							if devuelve_adyacentes_2(r-2,s).nodoant.nombre==color:
								#animar_nodo(r,s)
#								devuelve_adyacentes_2(r-2,s).nodoant.nodo.scale=Vector2(0.7,0.7)
								nodo.append(devuelve_adyacentes_2(r-2,s).nodoant.nodo)
								
							if devuelve_adyacentes_2(r-2,s).nodosig.nombre==color:
								#animar_nodo(r,s)
#								devuelve_adyacentes_2(r-2,s).nodosig.nodo.scale=Vector2(0.7,0.7)
								nodo.append(devuelve_adyacentes_2(r-2,s).nodosig.nodo)
						else:
							if devuelve_adyacentes(r-2,s).nodofuturo.nombre==color:
								#animar_nodo(r,s)
#								devuelve_adyacentes(r-2,s).nodofuturo.nodo.scale=Vector2(0.7,0.7)
								nodo.append(devuelve_adyacentes(r-2,s).nodofuturo.nodo)
							#AQUI ES POR ANILLOS 2 VERIFICACIONES
							
							if devuelve_adyacentes_2(r-2,s).nodoant.nombre==color:
								#animar_nodo(r,s)
#								devuelve_adyacentes_2(r-2,s).nodoant.nodo.scale=Vector2(0.7,0.7)
								nodo.append(devuelve_adyacentes_2(r-2,s).nodoant.nodo)
							if devuelve_adyacentes_2(r-2,s).nodosig.nombre==color:
								#animar_nodo(r,s)
#								devuelve_adyacentes_2(r-2,s).nodosig.nodo.scale=Vector2(0.7,0.7)
								nodo.append(devuelve_adyacentes_2(r-2,s).nodosig.nodo)

				if contadorsito==anill:
					contadorsito=0
					antiguo2=buscar_nodo(anill-1,bloquesito,patronsito-(bloquesito))
					masantiguo2=buscar_nodo(anill-2,bloquesito,patronsito-((bloquesito)*2))
					color=antiguo2.nombre
					mascolor=masantiguo2.nombre
					if color==mascolor:
						if (r+1)==vec_anillos.size():
							#AQUI ES POR ANILLOS 2 VERIFICACIONES
							if devuelve_adyacentes_2(r-2,s).nodoant.nombre==color:
								#animar_nodo(r,s)
#								devuelve_adyacentes_2(r-2,s).nodoant.nodo.scale=Vector2(0.7,0.7)
								nodo.append(devuelve_adyacentes_2(r-2,s).nodoant.nodo)
							if devuelve_adyacentes_2(r-2,s).nodosig.nombre==color:
								#animar_nodo(r,s)
#								devuelve_adyacentes_2(r-2,s).nodosig.nodo.scale=Vector2(0.7,0.7)
								nodo.append(devuelve_adyacentes_2(r-2,s).nodosig.nodo)
						else:
							if devuelve_adyacentes(r-2,s).nodofuturo.nombre==color:
								#animar_nodo(r,s)
#								devuelve_adyacentes(r-2,s).nodofuturo.nodo.scale=Vector2(0.7,0.7)
								nodo.append(devuelve_adyacentes(r-2,s).nodofuturo.nodo)
							#AQUI ES POR ANILLOS 2 VERIFICACIONES
							if devuelve_adyacentes_2(r-2,s).nodoant.nombre==color:
								#animar_nodo(r,s)
#								devuelve_adyacentes_2(r-2,s).nodoant.nodo.scale=Vector2(0.7,0.7)
								nodo.append(devuelve_adyacentes_2(r-2,s).nodoant.nodo)
							if devuelve_adyacentes_2(r-2,s).nodosig.nombre==color:
								#animar_nodo(r,s)
#								devuelve_adyacentes_2(r-2,s).nodosig.nodo.scale=Vector2(0.7,0.7)
								nodo.append(devuelve_adyacentes_2(r-2,s).nodosig.nodo)
			else:
				antiguo1=buscar_nodo(anill-1,bloquesito,patronsito-(bloquesito-1))
				masantiguo1=buscar_nodo(anill-2,bloquesito,patronsito-((bloquesito-1)*2))
				if antiguo1!=null && masantiguo1!=null:
					color=antiguo1.nombre
					if antiguo1.nombre==masantiguo1.nombre:
						if (r+1)==vec_anillos.size():
							#AQUI ES POR ANILLOS 2 VERIFICACIONES
							if devuelve_adyacentes_2(r-2,s).nodoant.nombre==color:
								#animar_nodo(r,s)
#								devuelve_adyacentes_2(r-2,s).nodoant.nodo.scale=Vector2(0.7,0.7)
								nodo.append(devuelve_adyacentes_2(r-2,s).nodoant.nodo)
							if devuelve_adyacentes_2(r-2,s).nodosig.nombre==color:
								#animar_nodo(r,s)
#								devuelve_adyacentes_2(r-2,s).nodosig.nodo.scale=Vector2(0.7,0.7)
								nodo.append(devuelve_adyacentes_2(r-2,s).nodosig.nodo)
						#print(devuelve_adyacentes(r-2,s)[1].nodofuturo.nombre," == ",color)
						else:
							if devuelve_adyacentes(r-2,s)[1].nodofuturo.nombre==color:
								#animar_nodo(r,s)
#								devuelve_adyacentes(r-2,s)[1].nodofuturo.nodo.scale=Vector2(0.7,0.7)
								nodo.append(devuelve_adyacentes(r-2,s)[1].nodofuturo.nodo)
							#AQUI ES POR ANILLOS 2 VERIFICACIONES
							if devuelve_adyacentes_2(r-2,s).nodoant.nombre==color:
								#animar_nodo(r,s)
#								devuelve_adyacentes_2(r-2,s).nodoant.nodo.scale=Vector2(0.7,0.7)
								nodo.append(devuelve_adyacentes_2(r-2,s).nodoant.nodo)
							if devuelve_adyacentes_2(r-2,s).nodosig.nombre==color:
								#animar_nodo(r,s)
#								devuelve_adyacentes_2(r-2,s).nodosig.nodo.scale=Vector2(0.7,0.7)
								nodo.append(devuelve_adyacentes_2(r-2,s).nodosig.nodo)
				#print("")

				antiguo2=buscar_nodo(anill-1,bloquesito,patronsito-(bloquesito))
				masantiguo2=buscar_nodo(anill-2,bloquesito,patronsito-((bloquesito)*2))
				if antiguo2!=null && masantiguo2!=null:
					color=antiguo2.nombre
					if antiguo2.nombre==masantiguo2.nombre:
						if (r+1)==vec_anillos.size():
							#AQUI ES POR ANILLOS 2 VERIFICACIONES
							if devuelve_adyacentes_2(r-2,s).nodoant.nombre==color:
								#animar_nodo(r,s)
#								devuelve_adyacentes_2(r-2,s).nodoant.nodo.scale=Vector2(0.7,0.7)
								nodo.append(devuelve_adyacentes_2(r-2,s).nodoant.nodo)
							if devuelve_adyacentes_2(r-2,s).nodosig.nombre==color:
								#animar_nodo(r,s)
#								devuelve_adyacentes_2(r-2,s).nodosig.nodo.scale=Vector2(0.7,0.7)
								nodo.append(devuelve_adyacentes_2(r-2,s).nodosig.nodo)
						else:	
							if devuelve_adyacentes(r-2,s)[0].nodofuturo.nombre==color:
								#animar_nodo(r,s)
#								devuelve_adyacentes(r-2,s)[0].nodofuturo.nodo.scale=Vector2(0.7,0.7)
								nodo.append(devuelve_adyacentes(r-2,s)[0].nodofuturo.nodo)
							#AQUI ES POR ANILLOS 2 VERIFICACIONES
							if devuelve_adyacentes_2(r-2,s).nodoant.nombre==color:
								#animar_nodo(r,s)
#								devuelve_adyacentes_2(r-2,s).nodoant.nodo.scale=Vector2(0.7,0.7)
								nodo.append(devuelve_adyacentes_2(r-2,s).nodoant.nodo)
							if devuelve_adyacentes_2(r-2,s).nodosig.nombre==color:
								#animar_nodo(r,s)
#								devuelve_adyacentes_2(r-2,s).nodosig.nodo.scale=Vector2(0.7,0.7)
								nodo.append(devuelve_adyacentes_2(r-2,s).nodosig.nodo)
			contadorsito = contadorsito+1
	#ANIMACION VIBRAR en posibles jugadas
	var sha = preload("res://recursos/shader_mueve.tres")
	for i in nodo:
		i.get_node("Sprite").material = sha
		i.get_node("Sprite").material.set_shader_param("mov",30.0)
	if nodo.size() > 0:
		return true
	else:
		return false

func devuelve_adyacentes(anillo,posicionamiento):
	for g in almacena[anillo].size():
		if posicionamiento==g:
			var valoras=almacena[anillo][g]
			if valoras.size()==2:
				for p in almacena[anillo][g].size():
					return almacena[anillo][g]
			else:
				return almacena[anillo][g]

func devuelve_adyacentes_2(anillo,posicionamiento):
	for g in vectoraux[anillo].size():
		if posicionamiento == g:
			return vectoraux[anillo][g]

func rotaranillos():
	var global=[]
	for p in vec_anillos.size():
		vec_anillos_aux=[]
		var auxpositioninicial=vec_anillos[p][0]["nodo"].position
		for o in vec_anillos[p].size():

			var aux_objeto={}
			if p%2==0:
				aux_objeto["anillo"]=vec_anillos[p][o]["anillo"]
				aux_objeto["coordenadas"]=vec_anillos[p][o]["coordenadas"]
				aux_objeto["eje_pixel_x"]=vec_anillos[p][o]["eje_pixel_x"]
				aux_objeto["eje_pixel_y"]=vec_anillos[p][o]["eje_pixel_y"]
				aux_objeto["posicion"]=vec_anillos[p][o]["posicion"]
				aux_objeto["seccion"]=vec_anillos[p][o]["seccion"]
				if o==vec_anillos[p].size()-1:
					posicion1=Vector2(vec_anillos[p][o]["eje_pixel_x"],vec_anillos[p][o]["eje_pixel_y"])
					posicion2=vec_anillos[p][0]["nodo"].position
					aux_objeto["id"]=vec_anillos[p][0]["id"]
					vec_anillos[p][0]["nodo"].position=Vector2(vec_anillos[p][o]["eje_pixel_x"],vec_anillos[p][o]["eje_pixel_y"])
					aux_objeto["nodo"]=vec_anillos[p][0]["nodo"]
					aux_objeto["nombre"]=vec_anillos[p][0]["nombre"]
					aux_objeto["nodo"].mover(posicion2,posicion1)
				else:
					posicion1=Vector2(vec_anillos[p][o]["eje_pixel_x"],vec_anillos[p][o]["eje_pixel_y"])
					posicion2=vec_anillos[p][o+1]["nodo"].position
					aux_objeto["id"]=vec_anillos[p][o+1]["id"]
					vec_anillos[p][o+1]["nodo"].position=Vector2(vec_anillos[p][o]["eje_pixel_x"],vec_anillos[p][o]["eje_pixel_y"])#vec_anillos[p][o]["nodo"].position
					aux_objeto["nodo"]=vec_anillos[p][o+1]["nodo"]
					aux_objeto["nombre"]=vec_anillos[p][o+1]["nombre"]
					aux_objeto["nodo"].mover(posicion2,posicion1)
				vec_anillos_aux.append(aux_objeto)

			else:
				aux_objeto["anillo"]=vec_anillos[p][o]["anillo"]
				aux_objeto["coordenadas"]=vec_anillos[p][o]["coordenadas"]
				aux_objeto["eje_pixel_x"]=vec_anillos[p][o]["eje_pixel_x"]
				aux_objeto["eje_pixel_y"]=vec_anillos[p][o]["eje_pixel_y"]
				aux_objeto["posicion"]=vec_anillos[p][o]["posicion"]
				aux_objeto["seccion"]=vec_anillos[p][o]["seccion"]
				if o==0:
					posicion1=vec_anillos[p][o]["nodo"].position
					posicion2=vec_anillos[p][vec_anillos[p].size()-1]["nodo"].position
					aux_objeto["id"]=vec_anillos[p][vec_anillos[p].size()-1]["id"]
					vec_anillos[p][vec_anillos[p].size()-1]["nodo"].position=vec_anillos[p][o]["nodo"].position
					aux_objeto["nodo"]=vec_anillos[p][vec_anillos[p].size()-1]["nodo"]
					aux_objeto["nombre"]=vec_anillos[p][vec_anillos[p].size()-1]["nombre"]
					aux_objeto["nodo"].mover(posicion2,posicion1)
				else:
					posicion1=Vector2(vec_anillos[p][o]["eje_pixel_x"],vec_anillos[p][o]["eje_pixel_y"])
					posicion2=vec_anillos[p][o-1]["nodo"].position
					aux_objeto["id"]=vec_anillos[p][o-1]["id"]
					if (o+1)==vec_anillos[p].size():
						vec_anillos[p][o-1]["nodo"].position=Vector2(vec_anillos[p][o]["eje_pixel_x"],vec_anillos[p][o]["eje_pixel_y"])
					else:
						vec_anillos[p][o-1]["nodo"].position=vec_anillos[p][o]["nodo"].position
					aux_objeto["nodo"]=vec_anillos[p][o-1]["nodo"]
					aux_objeto["nombre"]=vec_anillos[p][o-1]["nombre"]
					aux_objeto["nodo"].mover(posicion2,posicion1)
				vec_anillos_aux.append(aux_objeto)
		global.append(vec_anillos_aux)
	vec_anillos=global
	posibles_jugadas()
	sistema_verifica_continuos()

func _on_Button2_button_up():#ROTAR ANILLOS
	rotaranillos()
	pass # Replace with function body.

func _on_Button_button_down():# BOTON ROTAR ANILLOS
	var hay_virus = false
	for i in vec_anillos:
		for j in i:
			if j["nombre"] == "virus":
				hay_virus = true 
				break
	if !hay_virus:
		rotaranillos()
	else:
		$Button/WindowDialog.popup_centered()
	$Button.disabled = true
	yield(get_tree().create_timer(2.0), "timeout")
	$Button.disabled = false

func _on_TextureButton_button_down():
	pass # Replace with function body.


func _on_BotonPausa_button_down():
	$Pausa.show()

func _on_Reanudar_button_up():
#	get_tree().paused = false
	$Pausa.hide()

func _on_Niveles_button_down():
	global.cambia_escenita("res://escenas/Niveles.tscn")
	pass # Replace with function body.

func _on_Sonido_button_down():
	if $AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.stop()
		$Pausa/Panel/Sonido.icon = preload("res://recursos/sonido off.png")
	else:
		$AudioStreamPlayer2D.play()
		$Pausa/Panel/Sonido.icon = preload("res://recursos/sonido on.png")

func emitir_particulas_virus():
	$ParticlesBurbujas.emitting = true
