GLOBAL.TOGGLE_HUD = GetModConfigData("KEYBOARD_TOGGLE_HUD")
GLOBAL.TOGGLE_VIEW = GetModConfigData("KEYBOARD_TOGGLE_VIEW")

--[[
local require = GLOBAL.require
local FollowCamera=require "cameras/followcamera"
local cameradefault=FollowCamera.SetDefault
    function FollowCamera:SetDefault(...)
        cameradefault(self,...)
   --     if GetWorld() and not GetWorld():IsCave() then
        self.distancetarget = 30
        self.mindist = 15
        self.maxdist = 150
        self.mindistpitch = 30
        self.maxdistpitch = 60
     --   end
    end
--]]
local function ChangeV(mindist,maxdist,mindistpitch,maxdistpitch,distancetarget,gains,default)

	local camera = GLOBAL.TheCamera
	local TheWorld = GLOBAL.TheWorld
	mindist = (mindist and mindist) or camera.mindist
	maxdist = (maxdist and maxdist) or camera.maxdist
	mindistpitch = (mindistpitch and mindistpitch) or camera.mindistpitch
	maxdistpitch = (maxdistpitch and maxdistpitch) or camera.maxdistpitch
	
	camera.mindist = mindist
	camera.maxdist = maxdist
	camera.mindistpitch = mindistpitch
	camera.maxdistpitch = maxdistpitch
	--camera:SetDistance(math.ceil(mindist*2)-.1)
	camera.distancetarget = distancetarget
	
	if default then
		camera:SetDefault()
	end
end	

local Camera_Changed = false
local function ChangeView()
	if Camera_Changed then
		ChangeV(15,50,30,60,30,nil,default) 
		Camera_Changed	= false
		if TheWorld ~= nil and TheWorld:HasTag("cave") then
		ChangeV(15,35,25,40,25,nil,default)
		end
		--mindist,maxdist,mindistpitch,maxdistpitch,gains,default
	else 
	ChangeV(5,150,30,60,80,nil,default) 
	Camera_Changed = true
	end
end	

local SoH_Status = true
local function ShowOrHideHUD()
	if SoH_Status == true  then --hide HUD
		GLOBAL.ThePlayer.HUD:Hide()
		SoH_Status = false
	else --show HUD
		GLOBAL.ThePlayer.HUD:Show()
		SoH_Status = true
	end
end

GLOBAL.TheInput:AddKeyUpHandler(GLOBAL.TOGGLE_HUD, ShowOrHideHUD)
GLOBAL.TheInput:AddKeyUpHandler(GLOBAL.TOGGLE_VIEW, ChangeView)