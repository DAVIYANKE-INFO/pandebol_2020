extends CanvasLayer

var nro_anillos
var radio
var escala
var nro_virus_a_eliminar
var nivel = 0
var velocidad_virus

#//////////////////////////////////////////////////////////////////////////////////////
var nivel_actual=1

var uno_1=true
var dos_2=true
var tres_3=true
var cuatro_4=true
var cinco_5=true
var seis_6=true
var siete_7=true
var ocho_8=true
var nueve_9=true

var diez_10=true
var once_11=true
var doce_12=true
var trece_13=true
var catorce_14=true
var quince_15=true
var dieciseis_16=true
var diecisiete_17=true
var diesiocho_18=true

var diecinueve_19=true
var veinte_20=true
var veintiuno_21=true
var veintidos_22=true
var veintitres_23=true
var veinticuatro_24=true
var veinticinco_25=true
var veintiseis_26=true
var veintisiete_27=true

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
	diecinueve=false,
	veinte=false,
	veintiuno=false,
	veintidos=false,
	veintitres=false,
	veinticuatro=false,
	veinticinco=false,
	veintiseis=false,
	veintisiete=false
	}
#//////////////////////////////////////////////////////////////////////////////////////


func cambia_escenita(scene):
	self.scale = Vector2(1,1)
	$anim.play("fade_in")
	yield($anim,"animation_finished")
	get_tree().change_scene(scene)
	$anim.play("fade_out")
	yield($anim,"animation_finished")
	self.scale = Vector2(0,0)
	
func _ready():
	self.scale = Vector2(0,0)
	#//////////////////////////////////////////////////////////////////////////////////////
	var path =Directory.new()
	if(!path.dir_exists("user://")):
		path.open("user://")
		path.make_dir("user://")
	var inicio = File.new()
	if(!inicio.file_exists("user://database.json")):
		var saves=File.new()
		saves.open("user://database.json",File.WRITE)
		var datos_guardar=datos_partida
		datos_guardar.nivel=1
		datos_guardar.uno=uno_1
		datos_guardar.dos=dos_2
		datos_guardar.tres=tres_3
		datos_guardar.cuatro=cuatro_4
		datos_guardar.cinco=cinco_5
		datos_guardar.seis=seis_6
		datos_guardar.siete=siete_7
		datos_guardar.ocho=ocho_8
		datos_guardar.nueve=nueve_9
		
		datos_guardar.diez=diez_10
		datos_guardar.once=once_11
		datos_guardar.doce=doce_12
		datos_guardar.trece=trece_13
		datos_guardar.catorce=catorce_14
		datos_guardar.quince=quince_15
		datos_guardar.dieciseis=dieciseis_16
		datos_guardar.diecisiete=diecisiete_17
		datos_guardar.dieciocho=diesiocho_18
		
		datos_guardar.diecinueve=diecinueve_19
		datos_guardar.veinte=veinte_20
		datos_guardar.veintiuno=veintiuno_21
		datos_guardar.veintidos=veintidos_22
		datos_guardar.veintitres=veintitres_23
		datos_guardar.veinticuatro=veinticuatro_24
		datos_guardar.veinticinco=veinticinco_25
		datos_guardar.veintiseis=veintiseis_26
		datos_guardar.veintisiete=veintisiete_27
	
		saves.store_line(to_json(datos_guardar))
		saves.close()
#//////////////////////////////////////////////////////////////////////////////////////

#//////////////////////////////////////////////////////////////////////////////////////
func guardar_partida(var numero):
	print("NIVEL --->  ",numero)
	var save=File.new()
	save.open("user://database.json",File.WRITE)
	var datos_guardar=datos_partida
	datos_guardar.nivel=numero
	
	datos_guardar.uno=uno_1
	datos_guardar.dos=dos_2
	datos_guardar.tres=tres_3
	datos_guardar.cuatro=cuatro_4
	datos_guardar.cinco=cinco_5
	datos_guardar.seis=seis_6
	datos_guardar.siete=siete_7
	datos_guardar.ocho=ocho_8
	datos_guardar.nueve=nueve_9
	
	datos_guardar.diez=diez_10
	datos_guardar.once=once_11
	datos_guardar.doce=doce_12
	datos_guardar.trece=trece_13
	datos_guardar.catorce=catorce_14
	datos_guardar.quince=quince_15
	datos_guardar.dieciseis=dieciseis_16
	datos_guardar.diecisiete=diecisiete_17
	datos_guardar.dieciocho=diesiocho_18
	
	datos_guardar.diecinueve=diecinueve_19
	datos_guardar.veinte=veinte_20
	datos_guardar.veintiuno=veintiuno_21
	datos_guardar.veintidos=veintidos_22
	datos_guardar.veintitres=veintitres_23
	datos_guardar.veinticuatro=veinticuatro_24
	datos_guardar.veinticinco=veinticinco_25
	datos_guardar.veintiseis=veintiseis_26
	datos_guardar.veintisiete=veintisiete_27
	
	
	if(numero==1):
		datos_guardar.uno=false
	if(numero==2):
		datos_guardar.dos=false
	if(numero==3):
		datos_guardar.tres=false
	if(numero==4):
		datos_guardar.cuatro=false
	if(numero==5):
		datos_guardar.cinco=false
	if(numero==6):
		datos_guardar.seis=false
	if(numero==7):
		datos_guardar.siete=false
	if(numero==8):
		datos_guardar.ocho=false
	if(numero==9):
		datos_guardar.nueve=false
		
	if(numero==10):
		datos_guardar.diez=false
	if(numero==11):
		datos_guardar.once=false
	if(numero==12):
		datos_guardar.doce=false
	if(numero==13):
		datos_guardar.trece=false
	if(numero==14):
		datos_guardar.catorce=false
	if(numero==15):
		datos_guardar.quince=false
	if(numero==16):
		datos_guardar.dieciseis=false
	if(numero==17):
		datos_guardar.diecisiete=false
	if(numero==18):
		datos_guardar.dieciocho=false
		
	if(numero==19):
		datos_guardar.diecinueve=false
	if(numero==20):
		datos_guardar.veinte=false
	if(numero==21):
		datos_guardar.veintiuno=false
	if(numero==22):
		datos_guardar.veintidos=false
	if(numero==23):
		datos_guardar.veintitres=false
	if(numero==24):
		datos_guardar.veinticuatro=false
	if(numero==25):
		datos_guardar.veinticinco=false
	if(numero==26):
		datos_guardar.veintiseis=false
	if(numero==27):
		datos_guardar.veintisiete=false
	
	save.store_line(to_json(datos_guardar))
	save.close()
#//////////////////////////////////////////////////////////////////////////////////////

#//////////////////////////////////////////////////////////////////////////////////////
func cargar_partida(var numero):
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
	nivel_actual=numero
	uno_1=datos_cargar.uno
	dos_2=datos_cargar.dos
	tres_3=datos_cargar.tres
	cuatro_4=datos_cargar.cuatro
	cinco_5=datos_cargar.cinco
	seis_6=datos_cargar.seis
	siete_7=datos_cargar.siete
	ocho_8=datos_cargar.ocho
	nueve_9=datos_cargar.nueve
	
	diez_10=datos_cargar.diez
	once_11=datos_cargar.once
	doce_12=datos_cargar.doce
	trece_13=datos_cargar.trece
	catorce_14=datos_cargar.catorce
	quince_15=datos_cargar.quince
	dieciseis_16=datos_cargar.dieciseis
	diecisiete_17=datos_cargar.diecisiete
	diesiocho_18=datos_cargar.dieciocho
	
	diecinueve_19=datos_cargar.diecinueve
	veinte_20=datos_cargar.veinte
	veintiuno_21=datos_cargar.veintiuno
	veintidos_22=datos_cargar.veintidos
	veintitres_23=datos_cargar.veintitres
	veinticuatro_24=datos_cargar.veinticuatro
	veinticinco_25=datos_cargar.veinticinco
	veintiseis_26=datos_cargar.veintiseis
	veintisiete_27=datos_cargar.veintisiete
	
	if(numero==1):
		uno_1=false
	if(numero==2):
		dos_2=false
	if(numero==3):
		tres_3=false
	if(numero==4):
		cuatro_4=false
	if(numero==5):
		cinco_5=false
	if(numero==6):
		seis_6=false
	if(numero==7):
		siete_7=false
	if(numero==8):
		ocho_8=false
	if(numero==9):
		nueve_9=false
		
	if(numero==10):
		diez_10=false
	if(numero==11):
		once_11=false
	if(numero==12):
		doce_12=false
	if(numero==13):
		trece_13=false
	if(numero==14):
		catorce_14=false
	if(numero==15):
		quince_15=false
	if(numero==16):
		dieciseis_16=false
	if(numero==17):
		diecisiete_17=false
	if(numero==18):
		diesiocho_18=false
	
	if(numero==19):
		diecinueve_19=false
	if(numero==20):
		veinte_20=false
	if(numero==21):
		veintiuno_21=false
	if(numero==22):
		veintidos_22=false
	if(numero==23):
		veintitres_23=false
	if(numero==24):
		veinticuatro_24=false
	if(numero==25):
		veinticinco_25=false
	if(numero==26):
		veintiseis_26=false
	if(numero==27):
		veintisiete_27=false

#//////////////////////////////////////////////////////////////////////////////////////


