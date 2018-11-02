
local _G = GLOBAL
local GetWorld
local TheCamera
local ThePlayer
local TheInput = _G.TheInput
local IsPaused = _G.IsPaused
local GetTime = _G.GetTime
local CONTROL = {
    FORCE_INSPECT = _G.CONTROL_FORCE_INSPECT,
    ZOOM_IN = _G.CONTROL_ZOOM_IN,
    ZOOM_OUT = _G.CONTROL_ZOOM_OUT,
    ROTATE_LEFT = _G.CONTROL_ROTATE_LEFT,
    ROTATE_RIGHT = _G.CONTROL_ROTATE_RIGHT,
}
local MOUSEBUTTON = {
    MIDDLE = _G.MOUSEBUTTON_MIDDLE,
    SCROLLDOWN = _G.MOUSEBUTTON_SCROLLDOWN,
    SCROLLUP = _G.MOUSEBUTTON_SCROLLUP,
}
local DST = _G.TheSim:GetGameID() == "DST"

local MAX_VIEW_DIST = GetModConfigData("Max View Distance")
local DEFAULT_VIEW_DIST = GetModConfigData("Default View Distance")
local USE_VARIABLE_PITCH = GetModConfigData("Pitch Angle Method")
local MAX_PITCH_ANGLE = GetModConfigData("Pitch Angle")
local ZOOM_STEP_AMOUNT = GetModConfigData("Zoom Step Amount")
local OVERHEAD_OPTIONS = GetModConfigData("Overhead Toggle Options")
local OVERHEAD_KEY = GetModConfigData("Overhead Toggle Key")
local PARTIAL_ROTATE = GetModConfigData("Enable Partial Rotation")
local ZOOM_GAIN = 3

local smooth_zoom = TheInput:GetControlIsMouseWheel(CONTROL.ZOOM_IN) and TheInput:GetControlIsMouseWheel(CONTROL.ZOOM_OUT)
local lastzoomtime
local lastrotatetime
local toggle_overhead = false

local function FollowCameraPostInit(self)
    local FollowCameraSetDefault = self.SetDefault
    self.SetDefault = function(self)
        FollowCameraSetDefault(self)
        self.distancetarget = DEFAULT_VIEW_DIST
        self.zoomstep = ZOOM_STEP_AMOUNT
        self.distancegain = ZOOM_GAIN
    end
    self.ZoomOut = function(self)
        self.distancetarget = math.min(MAX_VIEW_DIST, self.distancetarget + self.zoomstep)
        self.time_since_zoom = 0
    end
    self.ToggleOverheadView = function(self)
        toggle_overhead = not toggle_overhead
        if OVERHEAD_OPTIONS > 1 then
            local dist = toggle_overhead and MAX_VIEW_DIST or DEFAULT_VIEW_DIST
            self.distancetarget = dist
            self.distance = dist
        end
    end
    local FollowCameraApply = self.Apply
    self.Apply = function(self)
        if toggle_overhead and OVERHEAD_OPTIONS % 2 ~= 0 then
            self.pitch = 89
        elseif not USE_VARIABLE_PITCH or self.pitch > MAX_PITCH_ANGLE then
            self.pitch = MAX_PITCH_ANGLE
        end
        FollowCameraApply(self)
    end
    if DST then
        self.SetOffset = function(self, offset) --[[disabled]] end
    end
end
AddClassPostConstruct("cameras/followcamera", FollowCameraPostInit)

local function PlayerHudPostInit(self)
    self.UpdateClouds = function(self, camera) --[[disabled]] end
end
AddClassPostConstruct("screens/playerhud", PlayerHudPostInit)

local function GetRotationAmount()
    if PARTIAL_ROTATE and TheInput:IsControlPressed(CONTROL.FORCE_INSPECT) then
        return 22.5
    else
        return 45
    end
end

local function IsMapOpen()
    if DST then
        return ThePlayer.HUD:IsMapScreenOpen()
    else
        return GetWorld().minimap.MiniMap:IsVisible()
    end
end

local function Rotate(time)
    if lastrotatetime and time - lastrotatetime < 0.2 then return end
    local rotateamount = 0
    if TheInput:IsControlPressed(CONTROL.ROTATE_LEFT) then
        rotateamount = -GetRotationAmount()
    elseif TheInput:IsControlPressed(CONTROL.ROTATE_RIGHT) then
        rotateamount = GetRotationAmount()
    end
    if rotateamount == 0 then return end
    if not IsPaused() then
        TheCamera:SetHeadingTarget(TheCamera:GetHeadingTarget() + rotateamount)
        lastrotatetime = time
    elseif IsMapOpen() then
        TheCamera:SetHeadingTarget(TheCamera:GetHeadingTarget() + rotateamount)
        TheCamera:Snap()
        lastrotatetime = time
    end
end

local function NormalZoom(time)
    if lastzoomtime and time - lastzoomtime < 0.1 then return end
    if TheInput:IsControlPressed(CONTROL.ZOOM_IN) then
        TheCamera:ZoomIn()
        lastzoomtime = time
    elseif TheInput:IsControlPressed(CONTROL.ZOOM_OUT) then
        TheCamera:ZoomOut()
        lastzoomtime = time
    end
end

local function PlayerControllerPostInit(self)
    TheCamera = _G.TheCamera
    GetWorld = _G.GetWorld
    ThePlayer = self.inst
    self.DoCameraControl = function(self)
        if not TheCamera:CanControl() or not ThePlayer.HUD then return end
        local time = GetTime()
        Rotate(time)
        if smooth_zoom or ThePlayer.HUD:IsCraftingOpen() then return end
        NormalZoom(time)
    end
end
AddComponentPostInit("playercontroller", PlayerControllerPostInit)

local function CanControl()
    if not TheCamera or not ThePlayer then return false end
    local can_control = TheCamera:CanControl() and ThePlayer.HUD and not ThePlayer.HUD:IsCraftingOpen()
    if DST then
        return can_control and not ThePlayer.HUD:HasInputFocus()
    else
        return can_control and not IsPaused()
    end
end

local overhead_is_mouse = OVERHEAD_KEY and OVERHEAD_KEY == MOUSEBUTTON.MIDDLE
if DST then
    local function MouseHandler(button, down, x, y)
        if not down then return end
        if button == MOUSEBUTTON.SCROLLUP and smooth_zoom and CanControl() then
            TheCamera:ZoomIn()
        elseif button == MOUSEBUTTON.SCROLLDOWN and smooth_zoom and CanControl() then
            TheCamera:ZoomOut()
        elseif button == MOUSEBUTTON.MIDDLE and overhead_is_mouse and CanControl() then
            TheCamera:ToggleOverheadView()
        end
    end
    TheInput:AddMouseButtonHandler(MouseHandler)
else
    local function OnMouseWheelUp(down)
        if down and smooth_zoom and CanControl() then
            TheCamera:ZoomIn()
        end
    end
    TheInput:AddControlHandler(CONTROL.ZOOM_IN, OnMouseWheelUp)

    local function OnMouseWheelDown(down)
        if down and smooth_zoom and CanControl() then
            TheCamera:ZoomOut()
        end
    end
    TheInput:AddControlHandler(CONTROL.ZOOM_OUT, OnMouseWheelDown)
end

if not overhead_is_mouse then
    local function OnOverHeadKey()
        if CanControl() then
            TheCamera:ToggleOverheadView()
        end
    end
    TheInput:AddKeyUpHandler(OVERHEAD_KEY, OnOverHeadKey)
end

local function ControlMappingHandler(deviceId, controlId, inputId, hasChanged)
    smooth_zoom = TheInput:GetControlIsMouseWheel(CONTROL.ZOOM_IN) and TheInput:GetControlIsMouseWheel(CONTROL.ZOOM_OUT)
end
TheInput:AddControlMappingHandler(ControlMappingHandler)
