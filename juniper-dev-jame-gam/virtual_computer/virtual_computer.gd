extends Control

@onready var office_page: Control = $OfficePage
@onready var casino_page: Control = $CasinoPage
@onready var office_tab: TextureRect = $Tabs/HBoxContainer/OfficeTab
@onready var casino_tab: TextureRect = $Tabs/HBoxContainer/CasinoTab
@onready var wheel: Wheel = $CasinoPage/VBoxContainer/HBoxContainer/WheelHome/Wheel
@onready var money_label: Label = $CasinoPage/VBoxContainer/HBoxContainer/WheelInfo/VBoxContainer/HBoxContainer/PanelContainer2/VBoxContainer/MoneyLabel
@onready var name_label: Label = $CasinoPage/VBoxContainer/HBoxContainer/WheelInfo/VBoxContainer/PanelContainer/VBoxContainer/NameLabel
@onready var office_url: Label = $Tabs/HBoxContainer/OfficeTab/OfficeLabel/OfficeURL
@onready var casino_url: Label = $Tabs/HBoxContainer/CasinoTab/CasinoLabel/CasinoUrl
@onready var boss_bar: ProgressBar = $OfficePage/BossBar
@onready var word_count_label: Label = $OfficePage/WordCountLabel
@onready var typing_box: TextEdit = $OfficePage/TextBox/TypingBox
@onready var time_label: Label = $Tabs/SearchBar/AppBar/TimeLabel
@onready var phone_audio: AudioStreamPlayer2D = $CasinoPage/PhoneAudio
@onready var clicky_clacky: AudioStreamPlayer2D = $CasinoPage/ClickyClacky
@onready var casino_music: AudioStreamPlayer2D = $CasinoPage/CasinoMusic
@onready var office_sounds: AudioStreamPlayer2D = $CasinoPage/OfficeSounds
@onready var eek_: AudioStreamPlayer2D = $"EEK!"

@onready var detail_panels : Array[DetailPanel] = [
	$CasinoPage/VBoxContainer/HBoxContainer/WheelInfo/VBoxContainer/PanelContainer/VBoxContainer/DetailsPanel,
	$CasinoPage/VBoxContainer/HBoxContainer/WheelInfo/VBoxContainer/PanelContainer/VBoxContainer/DetailsPanel2,
	$CasinoPage/VBoxContainer/HBoxContainer/WheelInfo/VBoxContainer/PanelContainer/VBoxContainer/DetailsPanel3,
	$CasinoPage/VBoxContainer/HBoxContainer/WheelInfo/VBoxContainer/PanelContainer/VBoxContainer/DetailsPanel4,
]

var og_manager_value : float = .25
var manager_value : float = .25

var char_count : int = 0
var needed_char_count : int = 25

var current_time : int = 9
var optional_0 : String = "0"
var time_string : String = "AM"

func _ready() -> void:
	set_check_in_timer()
	swap_to_office()
	SignalBus.wheel_changed.connect(change_wheel)
	SignalBus.wheel_spun.connect(caught_gambling)
	change_wheel(load("res://wheel/wheel_resources/chump_wheel.tres"))

func _physics_process(delta: float) -> void:
	money_label.text = "$" + str(InfoManager.current_money)
	boss_bar.value += manager_value
	if ringing:
		phone_icon.modulate = Color("ee3400")
		if manager_value <= 5:
			manager_value += .05
	else: 
		manager_value = og_manager_value
		phone_icon.modulate = Color("ffffffff")
		phone_audio.stop()
	
	if looking:
		eye_icon.visible = true
	else:
		eye_icon.visible = false
	
	if current_quota >= quota_count:
		quota_met = true
		clock_icon.modulate = Color("36ff2eff")
	else:
		clock_icon.modulate = Color("ffffffff")
		quota_met = false
	
	if int(current_time / 12) >= 1:
		time_string = "PM"
	else:
		time_string = "AM"
	
	if check_in_timer.time_left > 50:
		optional_0 = "0"
	else:
		optional_0 = ""
	
	word_count_label.text = str(char_count) + "/" + str(needed_char_count)
	clock_label.text = str(int(check_in_timer.time_left / 60)) + ":" + str(int(check_in_timer.time_left) - int(check_in_timer.time_left / 60)*60 )
	quota_label.text = str(current_quota) + "/" + str(quota_count)
	time_label.text = str(current_time) + ":" + optional_0 + str(int(60 - check_in_timer.time_left))+ " " + time_string
	
	if Input.is_action_pressed("Ctrl") and Input.is_action_just_pressed("1"):
		swap_to_office()
	if Input.is_action_pressed("Ctrl") and Input.is_action_just_pressed("2"):
		swap_to_casino()
	if Input.is_action_pressed("Ctrl") and Input.is_action_just_pressed("Tab"):
		if casino_page.visible:
			swap_to_office()
		elif office_page.visible:
			swap_to_casino()
	if Input.is_action_just_pressed("Enter"):
		turn_in_work()
	
	if boss_bar.value >= boss_bar.max_value:
		lose()
	if InfoManager.current_money >= 100000:
		win()
	
	if char_count > needed_char_count:
		word_count_label.modulate = Color("36ff2eff")
	else:
		word_count_label.modulate = Color("ffffffff")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("CharTyped") and typing_box.has_focus() and office_page.visible:
		char_count += 1
		play_key()

func win():
	$Win.visible
	$"Win/Oh yea".play()
	var tween = get_tree().create_tween()
	tween.tween_property($Win, "modulate:a", 1, 1.97)
	await tween.finished
	InfoManager.current_money = 0
	get_tree().change_scene_to_file("res://win_screen/win_screen.tscn")

var lost : bool = false
func lose():
	if !lost:
		InfoManager.current_money = 0
		$Camera2D.shake(100, 3)
		lost = true
		$LostGame.visible = true
		office_sounds.stop()
		eek_.play()
		return_to_menu()

func return_to_menu():
	await get_tree().create_timer(3).timeout
	var tween = get_tree().create_tween()
	tween.tween_property($LostGame/ColorRect2, "modulate:a", 1, 1.5)
	await tween.finished
	get_tree().change_scene_to_file("res://start_screen/start_screen.tscn")

func play_key():
	var rand = randi_range(0, 2)
	if rand == 0:
		clicky_clacky.stream = load("res://sprites/sounds/click1.mp3")
	if rand == 1:
		clicky_clacky.stream = load("res://sprites/sounds/click2.mp3")
	if rand == 2:
		clicky_clacky.stream = load("res://sprites/sounds/click3.mp3")
	clicky_clacky.play()

#Swapping Tabs and Stuff
#region
func swap_to_office():
	office_page.visible = true
	casino_page.visible = false
	office_tab.modulate = Color("ffffffff")
	casino_tab.modulate = Color("c9c9c9")
	casino_music.stop()
	office_sounds.play()

func swap_to_casino():
	office_page.visible = false
	casino_page.visible = true
	office_tab.modulate = Color("c9c9c9")
	casino_tab.modulate = Color("ffffffff")
	office_sounds.stop()
	casino_music.play()

func _on_office_button_pressed() -> void:
	swap_to_office()

func _on_casino_button_pressed() -> void:
	swap_to_casino() 
	print("yep")
#endregion

#Wheels and Stuff
#region
func change_wheel(wheel_resource : WheelResource):
	if !wheel.spinning:
		print("hhahahah")
		wheel.result_resource = wheel_resource
		wheel.change_wheel()
		name_label.text = wheel_resource.wheel_name
		for detail_panel in detail_panels:
			detail_panel.wheel_resource = wheel_resource
			detail_panel.set_resource()
#endregion

#Typing Minigame Stuff
#region
func turn_in_work():
	if char_count > needed_char_count:
		current_quota += 1
		char_count = 0
		needed_char_count = randi_range(15, 50)
		boss_bar.value -= 750
		typing_box.text = ""
		if looking:
			looking = false
			set_coworker_timer()

#endregion

#Events and Micromanaging
#region
@onready var phone_icon: TextureRect = $OfficePage/PhoneIcon
@onready var phone_timer: Timer = $OfficePage/PhoneIcon/PhoneTimer
@onready var clock_icon: TextureRect = $OfficePage/ClockIcon
@onready var check_in_timer: Timer = $OfficePage/ClockIcon/CheckInTimer
@onready var coworker_icon: TextureRect = $OfficePage/CoworkerIcon
@onready var eye_icon: TextureRect = $OfficePage/CoworkerIcon/EyeIcon
@onready var grace_period_timer: Timer = $OfficePage/GracePeriodTimer
@onready var coworker_timer: Timer = $OfficePage/CoworkerIcon/CoworkerTimer
@onready var clock_label: Label = $OfficePage/ClockIcon/ClockLabel
@onready var quota_label: Label = $OfficePage/ClockIcon/ClockLabel/QuotaLabel

var ringing : bool = false
var looking : bool = false
var quota_met : bool = false
var current_quota : int = 0
var quota_count : int = 5

func set_phone_timer():
	phone_timer.wait_time = randf_range(15.0, 100.0)
	phone_timer.start()

func set_coworker_timer():
	coworker_timer.wait_time = randf_range(60.0, 150.0)
	coworker_timer.start()

func set_check_in_timer():
	check_in_timer.wait_time = 60
	current_quota = 0
	quota_count = randi_range(3, 5)
	check_in_timer.start()

func _on_phone_timer_timeout() -> void:
	ringing = true
	phone_audio.play()

func _on_coworker_timer_timeout() -> void:
	looking = true

func _on_check_in_timer_timeout() -> void:
	if !quota_met:
		boss_bar.value += 3000
	current_time += 1
	set_check_in_timer()

func _on_phone_button_pressed() -> void:
	if ringing:
		set_phone_timer()
		ringing = false

func _on_grace_period_timer_timeout() -> void:
	set_phone_timer()
	set_coworker_timer()

func caught_gambling():
	if looking: 
		boss_bar.value += 1000

#endregion
