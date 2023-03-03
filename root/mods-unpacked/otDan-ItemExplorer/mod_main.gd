extends Node

const MOD_NAME = "otDan-ItemExplorer"

var dir = ""

func _init(modLoader = ModLoader):
	ModLoaderUtils.log_info("Init", MOD_NAME)

	modLoader.install_script_extension("res://mods-unpacked/otDan-ItemExplorer/extensions/ui/menus/title_screen/title_screen_menus.gd")
	modLoader.install_script_extension("res://mods-unpacked/otDan-ItemExplorer/extensions/ui/menus/pages/menu_choose_options.gd")

	dir = modLoader.UNPACKED_DIR + MOD_NAME + "/"
	modLoader.add_translation_from_resource(dir + "itemexplorer_translation.en.translation")

func _ready():
	ModLoaderUtils.log_info("Readying", MOD_NAME)
	ModLoaderUtils.log_success("Loaded", MOD_NAME)
