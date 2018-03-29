----------------------------------------------------------------------------------------------------------------------------------------------------
-------------- UPGRADE DEFINITIONS
----------------------------------------------------------------------------------------------------------------------------------------------------
StorageTech = 
{
    {
        "StorageExpansion", 
    }, 
    {
        "StorageStackingMethods", 
    }, 
    {
        "StorageSphericalContainers", 
    }, 
}

-- Check if upgrade is storage upgrade
function IsStorageTech(tech)
    for _, lvl in pairs(StorageTech) do
        for _, t in pairs(lvl) do
            if t == tech then
                return true
            end
        end
    end

    return false
end
function IsStorageTech_Level(tech, level)
    return StorageTech[level] and StorageTech[level][tech] ~= nil
end

StorageUpgrades = 
{
    {
        "WasteRockDumpSite_ExtraStorage", 
        "StorageMetals_ExtraStorage", 
        "StorageConcrete_ExtraStorage", 
        "StorageFood_ExtraStorage", 
        "StorageRareMetals_ExtraStorage", 
        "StoragePolymers_ExtraStorage", 
        "StorageElectronics_ExtraStorage", 
        "StorageMachineParts_ExtraStorage", 
        "StorageFuel_ExtraStorage", 
    }, 
    {
        "StorageMetals_ExtraStorage_2", 
        "StorageConcrete_ExtraStorage_2", 
        "StorageFood_ExtraStorage_2", 
        "StorageRareMetals_ExtraStorage_2", 
        "StoragePolymers_ExtraStorage_2", 
        "StorageElectronics_ExtraStorage_2", 
        "StorageMachineParts_ExtraStorage_2", 
        "StorageFuel_ExtraStorage_2", 
    }, 
    {
        "StorageMetals_ExtraStorage_3", 
        "StorageConcrete_ExtraStorage_3", 
        "StorageFood_ExtraStorage_3", 
        "StorageRareMetals_ExtraStorage_3", 
        "StoragePolymers_ExtraStorage_3", 
        "StorageElectronics_ExtraStorage_3", 
        "StorageMachineParts_ExtraStorage_3", 
        "StorageFuel_ExtraStorage_3", 
    }, 
}

-- Check if upgrade is storage upgrade
function IsStorageUpgrade(upgrade)
    for _, lvl in pairs(StorageUpgrades) do
        for _, up in pairs(lvl) do
            if up == upgrade then
                return true
            end
        end
    end

    return false
end
function IsStorageUpgrade_Level(upgrade, level)
    return StorageUpgrades[level] and StorageUpgrades[level][upgrade] ~= nil
end


----------------------------------------------------------------------------------------------------------------------------------------------------
-------------- UNLOCK UPGRADE METHODS
----------------------------------------------------------------------------------------------------------------------------------------------------


-- Unlock upgrades we use for storage space
function UnlockStorageUpgrades()
    -- UICity.unlocked_upgrades.WasteRockDumpSite_ExtraStorage = true
    -- OR
    -- UICity.unlocked_upgrades["WasteRockDumpSite_ExtraStorage"] = true
    for _, lvl in pairs(StorageUpgrades) do
        for _, upgrade in pairs(lvl) do
            UICity.unlocked_upgrades[upgrade] = true
            ModLog(tostring(GameTime()) .. " >UNLOCKED_UPGRADE= " .. tostring(upgrade))
        end
    end
end
function UnlockStorageUpgrades_Level(level)
    if StorageUpgrades[level] then
        local lvl = StorageUpgrades[level]
        for _, upgrade in pairs(lvl) do
            UICity.unlocked_upgrades[upgrade] = true
            ModLog(tostring(GameTime()) .. " >UNLOCKED_UPGRADE= " .. tostring(upgrade))
        end
    end
end


----------------------------------------------------------------------------------------------------------------------------------------------------
-------------- NOTIFICATIONS
----------------------------------------------------------------------------------------------------------------------------------------------------


-- shouldn't we let people know how awesome we are
function NotifyStorageUpgraded(self)
    ModLog(tostring(GameTime()) .. " >NOTIFICATION_UPGRADE= " .. tostring(self.display_name))
    AddCustomOnScreenNotification("BuildingUpgraded", T{917892953978, "Building Upgraded"}, T{917892953977, "<building>"}, GetModLocation() .. "UI/Icons/Notifications/building_upgraded.tga", false, {building = self.display_name, expiration = 50000, priority = "Normal",})
end
-- TODO: custom icons for level 2 and 3 upgrades

function NotifyStorageDowngraded(self)
    ModLog(tostring(GameTime()) .. " >NOTIFICATION_UPGRADE= " .. tostring(self.display_name))
    AddCustomOnScreenNotification("BuildingDowngraded", T{917892953980, "Building Downgraded"}, T{917892953979, "<building>"}, GetModLocation() .. "UI/Icons/Notifications/building_upgraded_2.tga", false, {building = self.display_name, expiration = 150000, priority = "Important",})
end


----------------------------------------------------------------------------------------------------------------------------------------------------
-------------- FILL STORAGE METHODS
----------------------------------------------------------------------------------------------------------------------------------------------------


function FillStorageDepot(self, amount, max)
    ModLog(tostring(GameTime()) .. " >FillStorageDepot_amount= " .. tostring(amount))
    ModLog(tostring(GameTime()) .. " >FillStorageDepot_max= " .. tostring(max))

    --self:CheatEmpty()

    local resource = self.resource[1]
    ModLog(tostring(GameTime()) .. " >FillStorageDepot_resource= " .. tostring(resource))
    
    -- test for max amount (cheat_fill)
    local _sup = amount -- 180
    ModLog(tostring(GameTime()) .. " >FillStorageDepot_supply= " .. tostring(_sup))
    local _dem = max - amount -- 180 - 180 = 0
    ModLog(tostring(GameTime()) .. " >FillStorageDepot_demand= " .. tostring(_dem))


    if self.class == "WasteRockDumpSite" then
        ModLog(tostring(GameTime()) .. " >MsgBuildingUpgraded:FILL:DumpSite= " .. tostring(self.class))
        Fill_WasteRockDumpingSite(self, _sup, _dem)
    elseif self.class == "UniversalStorageDepot" then
        ModLog(tostring(GameTime()) .. " >MsgBuildingUpgraded:FILL:Storage= " .. tostring(self.class))
        Fill_StorageDepot(self, _sup, _dem, resource)
    else
        ModLog(tostring(GameTime()) .. " >MsgBuildingUpgraded:Class:OTHER= " .. tostring(self.class))
    end
end

function Fill_StorageDepot(self, _sup, _dem, resource)
    if self.supply[resource] then
        self.supply[resource]:SetAmount(_sup)
        self.demand[resource]:SetAmount(_dem)
    end

    --self:SetCount(self.supply[resource]:GetActualAmount())
    self:SetCount(_sup)
end

function Fill_WasteRockDumpingSite(self, _sup, _dem)
    self.demand.WasteRock:SetAmount(_dem)
    if self.supply.Concrete then
        self.supply.Concrete:SetAmount(_sup / Max(1, g_Consts.WasteRockToConcreteRatio))
    end
    self:SetCount(_sup)
end


----------------------------------------------------------------------------------------------------------------------------------------------------
-------------- UPGRADE METHODS
----------------------------------------------------------------------------------------------------------------------------------------------------


function ToggleUpgradeStorageDepot(self, upgrade_id, new_state)
    ModLog(tostring(GameTime()) .. " >ToggleUpgradeStorageDepot_INIT= " .. tostring(self.display_name) .. " > " .. tostring(upgrade_id) .. " > " .. tostring(new_state))

    local active = self.upgrade_modifiers[upgrade_id][1].is_applied
    ModLog(tostring(GameTime()) .. " >ToggleUpgradeStorageDepot_active= " .. tostring(active))

    local property = self.upgrade_modifiers[upgrade_id][1].prop -- property = max storage capacity
    ModLog(tostring(GameTime()) .. " >ToggleUpgradeStorageDepot_property= " .. tostring(property))
    local delta = self.upgrade_modifiers[upgrade_id][1].amount -- amount = X
    ModLog(tostring(GameTime()) .. " >ToggleUpgradeStorageDepot_delta= " .. tostring(delta))

    local oldMax = self[property] -- self.max_storage_per_resource
    ModLog(tostring(GameTime()) .. " >ToggleUpgradeStorageDepot_oldMax= " .. tostring(oldMax))
    local resource = self.resource[1]
    ModLog(tostring(GameTime()) .. " >ToggleUpgradeStorageDepot_resource= " .. tostring(resource))
    
    local oldValue
    if self.class == "WasteRockDumpSite" then
        oldValue = self:GetStored_WasteRock()
    elseif self.class == "UniversalStorageDepot" then
        oldValue = self.supply[resource]:GetActualAmount()
    else
        ModLog(tostring(GameTime()) .. " >ToggleUpgradeStorageDepot:Class:OTHER= " .. tostring(self.class))
    end
    
    ModLog(tostring(GameTime()) .. " >ToggleUpgradeStorageDepot_oldValue= " .. tostring(oldValue))

    local newMax = oldMax
    if active or new_state then
        newMax = newMax + delta
    else
        newMax = newMax - delta
    end
    ModLog(tostring(GameTime()) .. " >ToggleUpgradeStorageDepot_newMax= " .. tostring(newMax))
    
    self[property] = newMax -- set max value
    ModLog(tostring(GameTime()) .. " >ToggleUpgradeStorageDepot_SET_storageMax= " .. tostring(self[property]))

    ModLog(tostring(GameTime()) .. " >ToggleUpgradeStorageDepot_CALL_FillStorageDepot= OLDVALUE:" .. tostring(oldValue) .. " -- NEWMAX:" .. tostring(newMax))
    FillStorageDepot(self, oldValue, newMax) -- set current value (stored)
    ModLog(tostring(GameTime()) .. " >ToggleUpgradeStorageDepot_END_FillStorageDepot=")

    if active or new_state then
        NotifyStorageUpgraded(self)
    else
        NotifyStorageDowngraded(self)
    end
end


----------------------------------------------------------------------------------------------------------------------------------------------------
-------------- GENERIC HELPER METHODS
----------------------------------------------------------------------------------------------------------------------------------------------------


local function GetModLocation()
    return ModElement.GetModRootPath() --or debug.getinfo(1, "S").source:sub(2, -35) -- /Code/PostBuildingUpgradeScript.lua = 35
end


----------------------------------------------------------------------------------------------------------------------------------------------------
-------------- EVENT HANDLERS
----------------------------------------------------------------------------------------------------------------------------------------------------


--[[function OnMsg.ConstructionComplete(bld)
    bld:CheatEmpty()
end--]]

-- Add upgrade-amount to max_amount_wasterock
function OnMsg.BuildingUpgraded(self, id)
    ModLog(tostring(GameTime()) .. " >MsgBuildingUpgraded:upgrade_id= " .. tostring(id))

    -- these are not the droids we are looking for
    if not IsStorageUpgrade(id) then
        ModLog(tostring(GameTime()) .. " >MsgBuildingUpgraded:NOT_storage_upgrade")
        return -- where does this leave us?
    end

    ModLog(tostring(GameTime()) .. " >MsgBuildingUpgraded:CLASS:= " .. tostring(self.class) .. ":UPGRADE:=" .. tostring(id))

    -- UpgradeStorageDepot(self, id) GOD HELP US
    ToggleUpgradeStorageDepot(self, id, true)

    ModLog(tostring(GameTime()) .. " >MsgBuildingUpgraded_END= " .. tostring(id))
end

function OnMsg.TechResearched(tech_id) --, self, status) -- .researched == 1
    if not IsStorageTech(tech_id) then
        return
    end

    for level, _ in ipairs(StorageTech) do
        if IsStorageTech_Level(tech_id, level) then
            UnlockStorageUpgrades_Level(level) 
        end 
    end

    --[[for level = 1, 3 do 
        if IsStorageTech_Level(tech_id, level) then
            UnlockStorageUpgrades_Level(level) 
        end 
    end--]]
end

--local old_BuildingOnUpgradeToggled = Building.OnUpgradeToggled or function() end
function Building:OnUpgradeToggled(upgrade_id, new_state)
    -- these are not the droids we are looking for
    if not IsStorageUpgrade(upgrade_id) then
        ModLog(tostring(GameTime()) .. " >OnUpgradeToggled:NOT_storage_upgrade:" .. tostring(upgrade_id) .. ":" .. tostring(new_state))
        return -- where does this leave us?
    end

    ModLog(tostring(GameTime()) .. " >OnUpgradeToggled:CLASS:= " .. tostring(self.class) .. ":UPGRADE:=" .. tostring(upgrade_id) .. ":NEW_STATE:=" .. tostring(new_state))

    ToggleUpgradeStorageDepot(self, upgrade_id, new_state)
end

--[[
function StorageDepot:SetMaxCapacity(capacity)
    local resource = self.resource[1]
    local max_name = "max_amount_" .. resource
    self[max_name] = capacity
end
--]]


----------------------------------------------------------------------------------------------------------------------------------------------------
-------------- MOD COMPATIBILITY
----------------------------------------------------------------------------------------------------------------------------------------------------


--[[-- SurvivingHusky --]]
-- We will unlock upgrades for husky after the first rocket has landed on mars
GlobalVar("g_StorageUpgradesUnlocked", false)

function OnMsg.RocketLanded(rocket)
    -- if rawget(_G, "g_StorageUpgradesUnlocked") then
    if g_StorageUpgradesUnlocked then
        return
    end

    local sponsor = GetMissionSponsor()
    if sponsor.name == "Husky" then
        UnlockStorageUpgrades()
        g_StorageUpgradesUnlocked = true
    end
end

--[[-- CheatMenu --]]
--stop these from happening
function ChoGGi.BlockCheatEmpty()
end
