extends Node

const MOD_NAME = "otDan-ItemExplorer"

var dir = ""
var ext_dir = ""

func _init(mod_loader = ModLoader):
	ModLoaderUtils.log_info("Init", MOD_NAME)

	dir = mod_loader.UNPACKED_DIR + MOD_NAME + "/"
	ext_dir = dir + "extensions/"

	mod_loader.add_translation_from_resource(dir + "itemexplorer_translation.en.translation")

	_add_child_class()
	_install_script_extensions(mod_loader)


func _ready():
	ModLoaderUtils.log_info("Readying", MOD_NAME)
	ModLoaderUtils.log_success("Loaded", MOD_NAME)


func _install_script_extensions(mod_loader):
	mod_loader.install_script_extension(ext_dir + "ui/menus/title_screen/title_screen_menus.gd")
	mod_loader.install_script_extension(ext_dir + "ui/menus/pages/menu_choose_options.gd")
	mod_loader.install_script_extension(ext_dir + "ui/menus/run/character_selection.gd")

func _add_child_class():
	var ItemExplorer = load(dir + "item_explorer.gd").new()
	ItemExplorer.name = "ItemExplorer"
	add_child(ItemExplorer)
