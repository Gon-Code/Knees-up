extends GutTest

## Variables globables
## 
## Corresponden a la escena del menu principal y el double de la escena
var scene 
var menu_double

## Creacion de Doubles 
func before_all():
	scene = load("res://Scenes/UI/main_menu.tscn")
	menu_double = double(scene).instantiate()
	
	# Añade la escena
	add_child(menu_double)
	gut.p("Creacion de Escena: main_menu.tscn")

func test_exit_button() -> void:
	
	# Stub del método que será llamado internamente
	self.stub(menu_double, "_on_exit_pressed").to_call_super()

	# Llamar al método (real o stub)
	menu_double._on_exit_pressed()

	# Verificar que quit() fue llamado
	self.assert_called(menu_double, "_on_exit_pressed")
