extends Node2D
var datos_partida = {
	nivel=0,
	uno=false,
	dos=false,
	tres=false,
	cuatro=false,
	cinco=false,
	seis=false,
	siete=false,
	ocho=false,
	nueve=false,
	diez=false,
	once=false,
	doce=false,
	trece=false,
	catorce=false,
	quince=false,
	dieciseis=false,
	diecisiete=false,
	dieciocho=false,
	}
func _ready():
# ++++++++++++PARA LOS NIVELES CANDADOS+++++++++++++++++++++++
	#global.cargar_partida(global.nivel_actual)
	var cargar = File.new()
	if(!cargar.file_exists("user://database.json")):
		#print("NO HAY PARTIDAS GUARDADAS")
		return
	
	cargar.open("user://database.json",File.READ)
	
	var datos_cargar = datos_partida
	#var todos_datos
	while(!cargar.eof_reached()):
		var dato_provis = parse_json(cargar.get_line())
		if(dato_provis!=null):
			datos_cargar = dato_provis
	cargar.close()
	global.cargar_partida(datos_cargar.nivel)
	var nivel_1=get_node("/root/Niveles/Node2D/VSlider/VBoxContainer/HBoxContainer/Button")
	nivel_1.disabled=global.uno_1
	var nivel_2=get_node("/root/Niveles/Node2D/VSlider/VBoxContainer/HBoxContainer/Button2")
	nivel_2.disabled=global.dos_2
	var nivel_3=get_node("/root/Niveles/Node2D/VSlider/VBoxContainer/HBoxContainer/Button3")
	nivel_3.disabled=global.tres_3
	var nivel_4=get_node("/root/Niveles/Node2D/VSlider/VBoxContainer/HBoxContainer2/Button4")
	nivel_4.disabled=global.cuatro_4
	var nivel_5=get_node("/root/Niveles/Node2D/VSlider/VBoxContainer/HBoxContainer2/Button5")
	nivel_5.disabled=global.cinco_5
	var nivel_6=get_node("/root/Niveles/Node2D/VSlider/VBoxContainer/HBoxContainer2/Button6")
	nivel_6.disabled=global.seis_6
	var nivel_7=get_node("/root/Niveles/Node2D/VSlider/VBoxContainer/HBoxContainer3/Button7")
	nivel_7.disabled=global.siete_7
	var nivel_8=get_node("/root/Niveles/Node2D/VSlider/VBoxContainer/HBoxContainer3/Button8")
	nivel_8.disabled=global.ocho_8
	var nivel_9=get_node("/root/Niveles/Node2D/VSlider/VBoxContainer/HBoxContainer3/Button9")
	nivel_9.disabled=global.nueve_9
	var nivel_10=get_node("/root/Niveles/Node2D/VSlider/VBoxContainer/HBoxContainer4/Button10")
	nivel_10.disabled=global.diez_10
	var nivel_11=get_node("/root/Niveles/Node2D/VSlider/VBoxContainer/HBoxContainer4/Button11")
	nivel_11.disabled=global.once_11
	var nivel_12=get_node("/root/Niveles/Node2D/VSlider/VBoxContainer/HBoxContainer4/Button12")
	nivel_12.disabled=global.doce_12
	var nivel_13=get_node("/root/Niveles/Node2D/VSlider/VBoxContainer/HBoxContainer5/Button13")
	nivel_13.disabled=global.trece_13
	var nivel_14=get_node("/root/Niveles/Node2D/VSlider/VBoxContainer/HBoxContainer5/Button14")
	nivel_14.disabled=global.catorce_14
	var nivel_15=get_node("/root/Niveles/Node2D/VSlider/VBoxContainer/HBoxContainer5/Button15")
	nivel_15.disabled=global.quince_15
	var nivel_16=get_node("/root/Niveles/Node2D/VSlider/VBoxContainer/HBoxContainer6/Button16")
	nivel_16.disabled=global.dieciseis_16
	var nivel_17=get_node("/root/Niveles/Node2D/VSlider/VBoxContainer/HBoxContainer6/Button17")
	nivel_17.disabled=global.diecisiete_17
	var nivel_18=get_node("/root/Niveles/Node2D/VSlider/VBoxContainer/HBoxContainer6/Button18")
	nivel_18.disabled=global.diesiocho_18
	var nivel_19=get_node("/root/Niveles/Node2D/VSlider/VBoxContainer/HBoxContainer7/TextureButton19")
	nivel_19.disabled=global.diecinueve_19
	var nivel_20=get_node("/root/Niveles/Node2D/VSlider/VBoxContainer/HBoxContainer7/TextureButton20")
	nivel_20.disabled=global.veinte_20
	var nivel_21=get_node("/root/Niveles/Node2D/VSlider/VBoxContainer/HBoxContainer7/TextureButton21")
	nivel_21.disabled=global.veintiuno_21
	var nivel_22=get_node("/root/Niveles/Node2D/VSlider/VBoxContainer/HBoxContainer8/TextureButton22")
	nivel_22.disabled=global.veintidos_22
	var nivel_23=get_node("/root/Niveles/Node2D/VSlider/VBoxContainer/HBoxContainer8/TextureButton23")
	nivel_23.disabled=global.veintitres_23
	var nivel_24=get_node("/root/Niveles/Node2D/VSlider/VBoxContainer/HBoxContainer8/TextureButton24")
	nivel_24.disabled=global.veinticuatro_24
# +++++++++++ FIN PARA LOS NIVELES CANDADOS+++++++++++++++++++
func _on_Button_button_up():
#	get_tree().change_scene("res://escenas/Principal.tscn")
	global.radio = 70
	global.escala = 0.25
	global.nro_anillos = 3
	global.nro_virus_a_eliminar = 1
	global.velocidad_virus = 5
	global.nivel = 1
	global.nivel_actual=1
	global.cambia_escenita("res://escenas/Principal.tscn")
	pass # Replace with function body.


func _on_Button2_button_up():
	global.radio = 70
	global.escala = 0.25
	global.nro_anillos = 3
	global.nro_virus_a_eliminar = 1
	global.velocidad_virus = 5
	global.nivel_actual=2
	global.cambia_escenita("res://escenas/Principal.tscn")
	pass # Replace with function body.


func _on_Button3_button_up():
	global.radio = 70
	global.escala = 0.25
	global.nro_anillos = 3
	global.nro_virus_a_eliminar = 2
	global.velocidad_virus = 4
	global.nivel_actual=3
	global.cambia_escenita("res://escenas/Principal.tscn")
	
	pass # Replace with function body.


func _on_Button4_button_up():
	global.radio = 70
	global.escala = 0.25
	global.nro_anillos = 3
	global.nro_virus_a_eliminar = 2
	global.velocidad_virus = 4
	global.nivel_actual=4
	global.cambia_escenita("res://escenas/Principal.tscn")
	
	pass # Replace with function body.


func _on_Button5_button_up():
	global.radio = 70
	global.escala = 0.25
	global.nro_anillos = 3
	global.nro_virus_a_eliminar = 3
	global.velocidad_virus = 4
	global.nivel_actual=5
	global.cambia_escenita("res://escenas/Principal.tscn")
	pass # Replace with function body.


func _on_Button6_button_up():
	global.radio = 70
	global.escala = 0.25
	global.nro_anillos = 3
	global.nro_virus_a_eliminar = 3
	global.velocidad_virus = 4
	global.nivel_actual=6
	global.cambia_escenita("res://escenas/Principal.tscn")
	pass # Replace with function body.

# 4 anillos
func _on_Button7_button_up():
	global.radio = 54
	global.escala = 0.2
	global.nro_anillos = 4
	global.nro_virus_a_eliminar = 4
	global.velocidad_virus = 4
	global.nivel_actual=7  
	global.cambia_escenita("res://escenas/Principal.tscn")
	
	pass # Replace with function body.


func _on_Button8_button_up():
	global.radio = 54
	global.escala = 0.2
	global.nro_anillos = 4
	global.nro_virus_a_eliminar = 5
	global.velocidad_virus = 4
	global.nivel_actual=8
	global.cambia_escenita("res://escenas/Principal.tscn")
	pass # Replace with function body.


func _on_Button9_button_up():
	global.radio = 54
	global.escala = 0.2
	global.nro_anillos = 4
	global.nro_virus_a_eliminar = 6
	global.velocidad_virus = 4
	global.nivel_actual=9
	global.cambia_escenita("res://escenas/Principal.tscn")
	pass # Replace with function body.


func _on_Button10_button_up():
	global.radio = 54
	global.escala = 0.2
	global.nro_anillos = 4
	global.nro_virus_a_eliminar = 6
	global.velocidad_virus = 4
	global.nivel_actual=10
	global.cambia_escenita("res://escenas/Principal.tscn")
	pass # Replace with function body.


func _on_Button11_button_up():
	global.radio = 54
	global.escala = 0.2
	global.nro_anillos = 4
	global.nro_virus_a_eliminar = 6
	global.velocidad_virus = 4
	global.nivel_actual=11
	global.cambia_escenita("res://escenas/Principal.tscn")
	pass # Replace with function body.


func _on_Button12_button_up():
	global.radio = 54
	global.escala = 0.2
	global.nro_anillos = 4
	global.nro_virus_a_eliminar = 6
	global.velocidad_virus = 4
	global.nivel_actual=12
	global.cambia_escenita("res://escenas/Principal.tscn")
	pass # Replace with function body.

# 5 anillos
func _on_Button13_button_up():
	global.radio = 43
	global.escala = 0.16
	global.nro_anillos = 5
	global.nro_virus_a_eliminar = 8
	global.velocidad_virus = 3
	global.nivel_actual=13
	global.cambia_escenita("res://escenas/Principal.tscn")
	pass # Replace with function body.


func _on_Button14_button_up():
	global.radio = 43
	global.escala = 0.16
	global.nro_anillos = 5
	global.nro_virus_a_eliminar = 8
	global.velocidad_virus = 3
	global.nivel_actual=14
	global.cambia_escenita("res://escenas/Principal.tscn")
	pass # Replace with function body.


func _on_Button15_button_up():
	global.radio = 43
	global.escala = 0.16
	global.nro_anillos = 5
	global.nro_virus_a_eliminar = 8
	global.velocidad_virus = 3
	global.nivel_actual=15
	global.cambia_escenita("res://escenas/Principal.tscn")
	pass # Replace with function body.


func _on_Button16_button_up():
	global.radio = 43
	global.escala = 0.16
	global.nro_anillos = 5
	global.nro_virus_a_eliminar = 8
	global.velocidad_virus = 3
	global.nivel_actual=16
	global.cambia_escenita("res://escenas/Principal.tscn")
	pass # Replace with function body.


func _on_Button17_button_up():
	global.radio = 43
	global.escala = 0.16
	global.nro_anillos = 5
	global.nro_virus_a_eliminar = 8
	global.velocidad_virus = 3
	global.nivel_actual=17
	global.cambia_escenita("res://escenas/Principal.tscn")
	pass # Replace with function body.


func _on_Button18_button_up():
	global.radio = 43
	global.escala = 0.16
	global.nro_anillos = 5
	global.nro_virus_a_eliminar = 8
	global.velocidad_virus = 3
	global.nivel_actual=18
	global.cambia_escenita("res://escenas/Principal.tscn")
	pass # Replace with function body.

# 6 anillos
func _on_TextureButton19_button_up():
	global.radio = 37
	global.escala = 0.14
	global.nro_anillos = 6
	global.nro_virus_a_eliminar = 9
	global.velocidad_virus = 2
	global.nivel_actual=19
	global.cambia_escenita("res://escenas/Principal.tscn")
	pass # Replace with function body.


func _on_TextureButton20_button_up():
	global.radio = 37
	global.escala = 0.14
	global.nro_anillos = 6
	global.nro_virus_a_eliminar = 9
	global.velocidad_virus = 2
	global.nivel_actual=20
	global.cambia_escenita("res://escenas/Principal.tscn")
	pass # Replace with function body.


func _on_TextureButton21_button_up():
	global.radio = 37
	global.escala = 0.14
	global.nro_anillos = 6
	global.nro_virus_a_eliminar = 9
	global.velocidad_virus = 2
	global.nivel_actual=21
	global.cambia_escenita("res://escenas/Principal.tscn")
	pass # Replace with function body.


func _on_TextureButton22_button_up():
	global.radio = 37
	global.escala = 0.14
	global.nro_anillos = 6
	global.nro_virus_a_eliminar = 9
	global.velocidad_virus = 2
	global.nivel_actual=22
	global.cambia_escenita("res://escenas/Principal.tscn")
	pass # Replace with function body.


func _on_TextureButton23_button_up():
	global.radio = 37
	global.escala = 0.14
	global.nro_anillos = 6
	global.nro_virus_a_eliminar = 9
	global.velocidad_virus = 1
	global.nivel_actual=23
	global.cambia_escenita("res://escenas/Principal.tscn")
	pass # Replace with function body.


func _on_TextureButton24_button_up():
	global.radio = 37
	global.escala = 0.14
	global.nro_anillos = 6
	global.nro_virus_a_eliminar = 9
	global.velocidad_virus = 1
	global.nivel = 24
	global.nivel_actual=24
	global.cambia_escenita("res://escenas/Principal.tscn")
