-- 消除画面黑白
if GetModConfigData("color") then
    AddPrefabPostInit("forest", function(inst)
        inst:RemoveComponent("colourcube")
        inst:AddComponent("colourcube2")
    end)
    AddPrefabPostInit("cave", function(inst)
        inst:RemoveComponent("colourcube")
        inst:AddComponent("colourcube2")
    end)
end

-- 消除画面周边
if GetModConfigData("ghost") then
    local PlayerHud = GLOBAL.require("screens/playerhud")
    function PlayerHud:GoInsane()
        self:GoSane()
    end
end

-- 消除脑残声音
if GetModConfigData("sound") then
    AddPrefabPostInit("forest", function(inst)
        inst:RemoveComponent("ambientsound")
        inst:AddComponent("ambientsound2")
    end)
    AddPrefabPostInit("cave", function(inst)
        inst:RemoveComponent("ambientsound")
        inst:AddComponent("ambientsound2")
    end)
end