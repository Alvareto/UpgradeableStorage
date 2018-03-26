return {
PlaceObj('ModItemBuildingTemplate', {
	'name', "StorageConcreteSmall",
	'template_class', "UniversalStorageDepot",
	'pin_rollover_hint', T{652031557782, --[[ModItemBuildingTemplate StorageConcreteSmall pin_rollover_hint]] "<image UI/Infopanel/left_click.tga 1400> Select"},
	'pin_rollover_hint_xbox', T{555828323351, --[[ModItemBuildingTemplate StorageConcreteSmall pin_rollover_hint_xbox]] "<image UI/PS4/Cross.tga> View"},
	'build_points', 0,
	'instant_build', true,
	'dome_forbidden', true,
	'upgrade1_id', "StorageConcrete_ExtraStorage",
	'upgrade1_display_name', T{773703751239, --[[ModItemBuildingTemplate StorageConcreteSmall upgrade1_display_name]] "Extra Storage"},
	'upgrade1_description', T{162309256812, --[[ModItemBuildingTemplate StorageConcreteSmall upgrade1_description]] "+<upgrade1_add_value_1> Storage Space."},
	'upgrade1_icon', "UI/Icons/Upgrades/service_bots_01.tga",
	'upgrade1_upgrade_cost_Concrete', 10000,
	'upgrade1_upgrade_time', 60000,
	'upgrade1_mod_label_1', "StorageConcrete",
	'upgrade1_mod_prop_id_1', "max_storage_per_resource",
	'upgrade1_add_value_1', 180,
	'display_name', T{806209022008, --[[ModItemBuildingTemplate StorageConcreteSmall display_name]] "Upgradeable Concrete Depot"},
	'display_name_pl', T{434373388403, --[[ModItemBuildingTemplate StorageConcreteSmall display_name_pl]] "Upgradeable Concrete Depots"},
	'description', T{756993657160, --[[ModItemBuildingTemplate StorageConcreteSmall description]] "Stores <concrete(max_storage_per_resource)>. Excess resources will be delivered automatically to other depots within Drone range."},
	'build_category', "Storages",
	'display_icon', "UI/Icons/Buildings/concrete_storage.tga",
	'build_pos', 3,
	'entity', "StorageDepotSmall_03",
	'encyclopedia_image', "UI/Encyclopedia/ConcreteDepot.tga",
	'on_off_button', false,
	'demolish_sinking', range(15, 30),
	'demolish_tilt_angle', range(300, 600),
	'max_storage_per_resource', 180000,
	'max_x', 12,
	'storable_resources', {
		"Concrete",
	},
}),
PlaceObj('ModItemBuildingTemplate', {
	'name', "StorageFoodSmall",
	'template_class', "UniversalStorageDepot",
	'pin_rollover_hint', T{590189655090, --[[ModItemBuildingTemplate StorageFoodSmall pin_rollover_hint]] "<image UI/Infopanel/left_click.tga 1400> Select"},
	'pin_rollover_hint_xbox', T{229899625194, --[[ModItemBuildingTemplate StorageFoodSmall pin_rollover_hint_xbox]] "<image UI/PS4/Cross.tga> View"},
	'build_points', 0,
	'instant_build', true,
	'dome_forbidden', true,
	'upgrade1_id', "StorageFood_ExtraStorage",
	'upgrade1_display_name', T{350165656564, --[[ModItemBuildingTemplate StorageFoodSmall upgrade1_display_name]] "Extra Storage"},
	'upgrade1_description', T{935851595680, --[[ModItemBuildingTemplate StorageFoodSmall upgrade1_description]] "+<upgrade1_add_value_1> Storage Space."},
	'upgrade1_icon', "UI/Icons/Upgrades/service_bots_01.tga",
	'upgrade1_upgrade_cost_Concrete', 10000,
	'upgrade1_mod_label_1', "StorageFood",
	'upgrade1_mod_prop_id_1', "max_storage_per_resource",
	'upgrade1_add_value_1', 180,
	'display_name', T{354163898645, --[[ModItemBuildingTemplate StorageFoodSmall display_name]] "Upgradeable Food Depot"},
	'display_name_pl', T{468769072438, --[[ModItemBuildingTemplate StorageFoodSmall display_name_pl]] "Upgradeable Food Depots"},
	'description', T{639459637449, --[[ModItemBuildingTemplate StorageFoodSmall description]] "Stores <food(max_storage_per_resource)>. Excess resources will be delivered automatically to other depots within Drone range."},
	'build_category', "Storages",
	'display_icon', "UI/Icons/Buildings/food_storage.tga",
	'build_pos', 4,
	'entity', "StorageDepotSmall_04",
	'encyclopedia_image', "UI/Encyclopedia/FoodDepot.tga",
	'on_off_button', false,
	'prio_button', false,
	'demolish_sinking', range(15, 30),
	'demolish_tilt_angle', range(300, 600),
	'max_storage_per_resource', 180000,
	'max_x', 12,
	'storable_resources', {
		"Food",
	},
}),
PlaceObj('ModItemBuildingTemplate', {
	'name', "StorageMetalsSmall",
	'template_class', "UniversalStorageDepot",
	'pin_rollover_hint', T{951045883695, --[[ModItemBuildingTemplate StorageMetalsSmall pin_rollover_hint]] "<image UI/Infopanel/left_click.tga 1400> Select"},
	'pin_rollover_hint_xbox', T{148389195761, --[[ModItemBuildingTemplate StorageMetalsSmall pin_rollover_hint_xbox]] "<image UI/PS4/Cross.tga> View"},
	'build_points', 0,
	'instant_build', true,
	'dome_forbidden', true,
	'upgrade1_id', "StorageMetals_ExtraStorage",
	'upgrade1_display_name', T{659728619699, --[[ModItemBuildingTemplate StorageMetalsSmall upgrade1_display_name]] "Extra Storage"},
	'upgrade1_description', T{674078438930, --[[ModItemBuildingTemplate StorageMetalsSmall upgrade1_description]] "+<upgrade1_add_value_1> Storage Space."},
	'upgrade1_icon', "UI/Icons/Upgrades/service_bots_01.tga",
	'upgrade1_upgrade_cost_Concrete', 10000,
	'upgrade1_upgrade_time', 60000,
	'upgrade1_mod_label_1', "StorageMetals",
	'upgrade1_mod_prop_id_1', "max_storage_per_resource",
	'upgrade1_add_value_1', 180,
	'display_name', T{806955136803, --[[ModItemBuildingTemplate StorageMetalsSmall display_name]] "Upgradeable Metals Depot"},
	'display_name_pl', T{779895985173, --[[ModItemBuildingTemplate StorageMetalsSmall display_name_pl]] "Upgradeable Metals Depots"},
	'description', T{863549667881, --[[ModItemBuildingTemplate StorageMetalsSmall description]] "Stores <metals(max_storage_per_resource)>. Excess resources will be delivered automatically to other depots within Drone range."},
	'build_category', "Storages",
	'display_icon', "UI/Icons/Buildings/metal_storage.tga",
	'build_pos', 2,
	'entity', "StorageDepotSmall_02",
	'encyclopedia_image', "UI/Encyclopedia/MetalsDepot.tga",
	'on_off_button', false,
	'demolish_sinking', range(15, 30),
	'demolish_tilt_angle', range(300, 600),
	'max_storage_per_resource', 180000,
	'max_x', 12,
	'storable_resources', {
		"Metals",
	},
}),
PlaceObj('ModItemBuildingTemplate', {
	'name', "StorageRareMetalsSmall",
	'template_class', "UniversalStorageDepot",
	'pin_rollover_hint', T{772949791068, --[[ModItemBuildingTemplate StorageRareMetalsSmall pin_rollover_hint]] "<image UI/Infopanel/left_click.tga 1400> Select"},
	'pin_rollover_hint_xbox', T{884549026443, --[[ModItemBuildingTemplate StorageRareMetalsSmall pin_rollover_hint_xbox]] "<image UI/PS4/Cross.tga> View"},
	'build_points', 0,
	'instant_build', true,
	'dome_forbidden', true,
	'upgrade1_id', "StorageRareMetals_ExtraStorage",
	'upgrade1_display_name', T{964726289799, --[[ModItemBuildingTemplate StorageRareMetalsSmall upgrade1_display_name]] "Extra Storage"},
	'upgrade1_description', T{834540050795, --[[ModItemBuildingTemplate StorageRareMetalsSmall upgrade1_description]] "+<upgrade1_add_value_1> Storage Space."},
	'upgrade1_icon', "UI/Icons/Upgrades/service_bots_01.tga",
	'upgrade1_upgrade_cost_Concrete', 10000,
	'upgrade1_mod_label_1', "StorageRareMetals",
	'upgrade1_mod_prop_id_1', "max_storage_per_resource",
	'upgrade1_add_value_1', 180,
	'display_name', T{793588514451, --[[ModItemBuildingTemplate StorageRareMetalsSmall display_name]] "Upgradeable Rare Metals Depot"},
	'display_name_pl', T{217851185374, --[[ModItemBuildingTemplate StorageRareMetalsSmall display_name_pl]] "Upgradeable Rare Metals Depots"},
	'description', T{909738725237, --[[ModItemBuildingTemplate StorageRareMetalsSmall description]] "Stores <rare_metals(max_storage_per_resource)>. Excess resources will be delivered automatically to other depots within Drone range."},
	'build_category', "Storages",
	'display_icon', "UI/Icons/Buildings/rare_metals_storage.tga",
	'build_pos', 5,
	'entity', "StorageDepotSmall_07",
	'encyclopedia_image', "UI/Encyclopedia/RareMetalsDepot.tga",
	'on_off_button', false,
	'prio_button', false,
	'demolish_sinking', range(15, 30),
	'demolish_tilt_angle', range(300, 600),
	'max_storage_per_resource', 180000,
	'max_x', 12,
	'storable_resources', {
		"PreciousMetals",
	},
}),
PlaceObj('ModItemBuildingTemplate', {
	'name', "WasteRockDumpSmall",
	'template_class', "WasteRockDumpSite",
	'pin_rollover_hint', T{253430560110, --[[ModItemBuildingTemplate WasteRockDumpSmall pin_rollover_hint]] "<image UI/Infopanel/left_click.tga 1400> Select"},
	'pin_rollover_hint_xbox', T{978590171635, --[[ModItemBuildingTemplate WasteRockDumpSmall pin_rollover_hint_xbox]] "<image UI/PS4/Cross.tga> View"},
	'build_points', 0,
	'instant_build', true,
	'dome_forbidden', true,
	'upgrade1_id', "WasteRockDumpSite_ExtraStorage",
	'upgrade1_display_name', T{503751464115, --[[ModItemBuildingTemplate WasteRockDumpSmall upgrade1_display_name]] "Extra Storage"},
	'upgrade1_description', T{932023317152, --[[ModItemBuildingTemplate WasteRockDumpSmall upgrade1_description]] "+<upgrade1_add_value_1> Storage Space."},
	'upgrade1_icon', "UI/Icons/Upgrades/service_bots_01.tga",
	'upgrade1_upgrade_cost_Concrete', 10000,
	'upgrade1_upgrade_time', 60000,
	'upgrade1_mod_label_1', "WasteRockDumpSite",
	'upgrade1_mod_prop_id_1', "max_amount_WasteRock",
	'upgrade1_add_value_1', 70,
	'display_name', T{759038059070, --[[ModItemBuildingTemplate WasteRockDumpSmall display_name]] "Upgradeable Dump Site"},
	'display_name_pl', T{324736921511, --[[ModItemBuildingTemplate WasteRockDumpSmall display_name_pl]] "Upgradeable Dumping Sites"},
	'description', T{563281929874, --[[ModItemBuildingTemplate WasteRockDumpSmall description]] "Stores <wasterock(max_amount_WasteRock)>. Waste Rock is produced as side product of different mining activities."},
	'build_category', "Storages",
	'display_icon', "UI/Icons/Buildings/dumping_site.tga",
	'build_pos', 10,
	'entity', "WasteRockDepotBig",
	'encyclopedia_image', "UI/Encyclopedia/DumpingSite.tga",
	'on_off_button', false,
	'prio_button', false,
	'color_modifier', RGBA(122, 85, 8, 255),
	'demolish_sinking', range(15, 30),
	'demolish_tilt_angle', range(300, 600),
	'exclude_from_lr_transportation', true,
	'max_amount_WasteRock', 70000,
}),
PlaceObj('ModItemCode', {
	'name', "PostBuildingUpgradeScript",
	'FileName', "Code/PostBuildingUpgradeScript.lua",
}),
PlaceObj('ModItemCode', {
	'name', "customWasteRockDumpSmall",
	'FileName', "Code/customWasteRockDumpSmall.lua",
}),
}
