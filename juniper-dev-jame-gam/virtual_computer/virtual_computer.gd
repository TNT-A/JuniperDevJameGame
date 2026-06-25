extends Node2D

@onready var office_page: Control = $OfficePage
@onready var casino_page: Control = $CasinoPage
@onready var office_tab: TextureRect = $Tabs/HBoxContainer/OfficeTab
@onready var casino_tab: TextureRect = $Tabs/HBoxContainer/CasinoTab
@onready var wheel: Wheel = $CasinoPage/VBoxContainer/HBoxContainer/WheelHome/Wheel

func _ready() -> void:
	swap_to_office()
	SignalBus.wheel_changed.connect(change_wheel)

func swap_to_office():
	office_page.visible = true
	casino_page.visible = false
	office_tab.modulate = Color("ffffffff")
	casino_tab.modulate = Color("c9c9c9")

func swap_to_casino():
	office_page.visible = false
	casino_page.visible = true
	office_tab.modulate = Color("c9c9c9")
	casino_tab.modulate = Color("ffffffff")

func _on_office_button_pressed() -> void:
	swap_to_office()

func _on_casino_button_pressed() -> void:
	swap_to_casino() 

func change_wheel(wheel_resource : Resource):
	wheel.result_resource = wheel_resource
	wheel.change_wheel()
