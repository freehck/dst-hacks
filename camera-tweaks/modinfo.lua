
name = "[Hack] Camera Tweaks"
description = ""
author = "exige"
version = "1.9"
forumthread = ""
api_version = 6
api_version_dst = 10

icon_atlas = "modicon.xml"
icon = "modicon.tex"

dont_starve_compatible = true
reign_of_giants_compatible = true
shipwrecked_compatible = true
dst_compatible = true
all_clients_require_mod = false
client_only_mod = true

local function BuildNumConfig(startNum, endNum, step)
    local numTable = {}
    local iterator = 1
    for i = startNum, endNum, step do
        numTable[iterator] = {description = i, data = i}
        iterator = iterator + 1
    end
    return numTable
end
local keylist = {}
local string = ""
for i = 1, 26 do
    local key = 96 + i
    keylist[i] = {description = string.char(key), data = key}
end
keylist[#keylist + 1] = {description = "MiddleMouse", data = 1002}
keylist[#keylist + 1] = {description = "Disabled", data = false}

configuration_options = {
    {
        name = "Max View Distance",
        hover = "Camera default is 50",
        options = BuildNumConfig(50, 200, 10),
        default = 100,
    },
    {
        name = "Default View Distance",
        hover = "Camera default is 30",
        options = BuildNumConfig(15, 75, 5),
        default = 40,
    },
    {
        name = "Pitch Angle Method",
        hover = "Camera default is variable",
        options = {
            {description = "Static", data = false},
            {description = "Variable", data = true},
        },
        default = false,
    },
    {
        name = "Pitch Angle",
        hover = "Static pitch angle or max variable pitch angle",
        options = BuildNumConfig(20, 60, 2),
        default = 40,
    },
    {
        name = "Zoom Step Amount",
        hover = "Camera default is 4",
        options = BuildNumConfig(1, 10, 1),
        default = 5,
    },
    {
        name = "Overhead Toggle Options",
        options = {
            {description = "90 Pitch", data = 1},
            {description = "Max Distance", data = 2},
            {description = "Both", data = 3},
        },
        default = 1,
    },
    {
        name = "Overhead Toggle Key",
        options = keylist,
        default = 1002,
    },
    {
        name = "Enable Partial Rotation",
        hover = "ALT + Q or E to rotate by 22.5 when enabled",
        options = {
            {description = "Yes", data = true},
            {description = "No", data = false},
        },
        default = true,
    },
}
