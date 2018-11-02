name = "PVPV"
description = "Old Aerial that works in PvP"
author = "sam"
version = "1.1.2"
api_version = 10
forumthread = ""

icon_atlas = "AerialView.xml"
icon = "AerialView.tex"

dont_starve_compatible = true
reign_of_giants_compatible = true

dst_compatible = true
all_clients_require_mod = false
client_only_mod = true

local alpha = {"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"}
local KEY_A = 282
local keyslist = {}
for i = 1,#alpha do keyslist[i] = {description = alpha[i],data = i + KEY_A - 1} end

configuration_options =
{
	{
		name = "KEYBOARD_TOGGLE_HUD",
		label = "Show/Hide HUD",
		hover = "You can show or hide HUD.",
		options = keyslist,
		default = 290, 
	},
		{
		name = "KEYBOARD_TOGGLE_VIEW",
		label = "Change View",
		hover = "Turn to aerial view Or reset to default.",
		options = keyslist,
		default = 291, 
	},
}	
