extends Node

const MOD_NAME = "otDan-ItemExplorer"

var mod_loader
var dir = ""
var translations_dir = ""
var extensions_dir = ""


func _init(_mod_loader = ModLoader):
	ModLoaderUtils.log_info("Init", MOD_NAME)
	mod_loader = _mod_loader

	dir = mod_loader.UNPACKED_DIR + MOD_NAME + "/"
	translations_dir = dir + "translations/"
	extensions_dir = dir + "extensions/"

	_install_translations()
	_install_script_extensions()
	_add_child_classes()


func _ready():
	ModLoaderUtils.log_success("Loaded", MOD_NAME)


func _install_translations()->void:
	mod_loader.add_translation_from_resource(translations_dir + "itemexplorer_translation.en.translation")


func _install_script_extensions():
	mod_loader.install_script_extension(extensions_dir + "ui/menus/title_screen/title_screen_menus.gd")
	mod_loader.install_script_extension(extensions_dir + "ui/menus/pages/menu_choose_options.gd")
	mod_loader.install_script_extension(extensions_dir + "ui/menus/run/character_selection.gd")


func _add_child_classes():
	var ItemExplorer = load(dir + "item_explorer.gd").new()
	ItemExplorer.name = "ItemExplorer"
	add_child(ItemExplorer)

	var StringComparer = load(dir + "global/string_comparer.gd").new()
	StringComparer.name = "StringComparer"
	add_child(StringComparer)
