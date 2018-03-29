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

-- shouldn't we let people know how awesome we are
function NotifyStorageUpgraded(self)
    ModLog(tostring(GameTime()) .. " >NOTIFICATION_UPGRADE= " .. tostring(self.display_name))
    AddCustomOnScreenNotification("BuildingUpgraded", T{917892953978, "Building Upgraded"}, T{917892953977, "<building>"}, GetModLocation() .. "UI/Icons/Notifications/building_upgraded.tga", false, {building = self.display_name, expiration = 50000, priority = "Normal",})
end
-- custom icons for level 2 and 3 upgrades

function NotifyStorageDowngraded(self)
    ModLog(tostring(GameTime()) .. " >NOTIFICATION_UPGRADE= " .. tostring(self.display_name))
    AddCustomOnScreenNotification("BuildingDowngraded", T{917892953980, "Building Downgraded"}, T{917892953979, "<building>"}, GetModLocation() .. "UI/Icons/Notifications/building_upgraded_2.tga", false, {building = self.display_name, expiration = 150000, priority = "Important",})
end

function FillStorageDepot(self, amount, max)
    ModLog(tostring(GameTime()) .. " >FillStorageDepot_amount= " .. tostring(amount))
    ModLog(tostring(GameTime()) .. " >FillStorageDepot_max= " .. tostring(max))

    self:CheatEmpty()

    local resource = self.resource[1]
    ModLog(tostring(GameTime()) .. " >FillStorageDepot_resource= " .. tostring(resource))
    
    -- test for max amount (cheat_fill)
    local _sup = amount -- 180
    ModLog(tostring(GameTime()) .. " >FillStorageDepot_supply= " .. tostring(_sup))
    local _dem = max - amount -- 180 - 180 = 0
    ModLog(tostring(GameTime()) .. " >FillStorageDepot_demand= " .. tostring(_dem))

    
    if self.class == "WasteRockDumpSite" then
        ModLog(tostring(GameTime()) .. " >FillStorageDepot:Class:DumpSite= " .. tostring(self.class))
        
        ToggleUpgradeWasteRockDumpingSite(self, new_state)
    else
        FillStorageDepot(self, resource, _sup, _dem)
    end

end

function FillWasteRockDumpingSite(self, amount)
    ModLog(tostring(GameTime()) .. " >FillWasteRockDumpingSite_amount= " .. tostring(amount))

    self:CheatEmpty()
    
    local _max = self.max_amount_WasteRock -- 180
    ModLog(tostring(GameTime()) .. " >FillWasteRockDumpingSite_max= " .. tostring(_max))

    -- test for max amount (cheat_fill)
    local _sup = amount -- 180
    ModLog(tostring(GameTime()) .. " >FillWasteRockDumpingSite_supply&count= " .. tostring(_sup))
    local _dem = max - amount -- 180 - 180 = 0
    ModLog(tostring(GameTime()) .. " >FillWasteRockDumpingSite_demand= " .. tostring(_dem))

    self.demand.WasteRock:SetAmount(_dem)
    if self.supply.Concrete then
        self.supply.Concrete:SetAmount(_sup / Max(1, g_Consts.WasteRockToConcreteRatio))
    end
    self:SetCount(_sup)
end

function FillStorageDepot(self, resource, _sup, _dem)
    --ModLog(tostring(GameTime()) .. " >FillStorageDepot_IFSupply= " .. tostring(self.supply[resource]))
    if self.supply[resource] then
        self.supply[resource]:SetAmount(_sup)
        self.demand[resource]:SetAmount(_dem)
    end

    --ModLog(tostring(GameTime()) .. " >FillStorageDepot_supplyAmount= " .. tostring(self.supply[resource]:GetActualAmount()))
    self:SetCount(self.supply[resource]:GetActualAmount())
end

function FillWasteRockDumpingSite(self, _sup, _dem)
    self.demand.WasteRock:SetAmount(_dem)
    if self.supply.Concrete then
        self.supply.Concrete:SetAmount(_sup / Max(1, g_Consts.WasteRockToConcreteRatio))
    end
    self:SetCount(_sup)
end

function UpgradeWasteRockDumpingSite(self)
    local upgrade_id = "WasteRockDumpSite_ExtraStorage"

    UpgradeStorageDepot(self, upgrade_id)

    FillWasteRockDumpingSite(self, oldValue)
    
end

function ToggleUpgradeWasteRockDumpingSite(self, new_state)
    local upgrade_id = "WasteRockDumpSite_ExtraStorage"
    ModLog(tostring(GameTime()) .. " >ToggleUpgradeStorageDepot_INIT= " .. tostring(self.display_name) .. " > " .. tostring(upgrade_id) .. " > " .. tostring(new_state))

    ToggleUpgradeStorageDepot(self, upgrade_id, new_state)
end

function UpgradeStorageDepot(self, upgrade_id)
    
    local resource = self.resource[1]
    -- 62203 >UpgradeStorageDepot_INIT= table: 0000029102A90030 > nil > table: 0000029102DB6288
    ModLog(tostring(GameTime()) .. " >UpgradeStorageDepot_INIT= " .. tostring(self.display_name) .. " > " .. tostring(upgrade_id) .. " > " .. tostring(resource))

    local active = self.upgrade_modifiers[upgrade_id][1].is_applied
    ModLog(tostring(GameTime()) .. " >UpgradeStorageDepot_active= " .. tostring(active))

    if active then
        local property = self.upgrade_modifiers[upgrade_id][1].prop -- property = max storage capacity
        ModLog(tostring(GameTime()) .. " >UpgradeStorageDepot_property= " .. tostring(property))
        local delta = self.upgrade_modifiers[upgrade_id][1].amount -- amount = X
        ModLog(tostring(GameTime()) .. " >UpgradeStorageDepot_delta= " .. tostring(delta))

        -- with this change we become independend of storage type
        local oldMax = self[property] -- self.max_storage_per_resource
        ModLog(tostring(GameTime()) .. " >UpgradeStorageDepot_oldMax= " .. tostring(oldMax))
        local oldValue = self.supply[resource]:GetActualAmount() -- GetStoredAmount(self)
        ModLog(tostring(GameTime()) .. " >UpgradeStorageDepot_oldValue= " .. tostring(oldValue))
        

        local newMax = oldMax + delta
        ModLog(tostring(GameTime()) .. " >UpgradeStorageDepot_newMax= " .. tostring(newMax))
        self[property] = newMax
        ModLog(tostring(GameTime()) .. " >UpgradeStorageDepot_storageMax= " .. tostring(self[property]))

        -- this handles both storage depots and waste rock dumping sites
        FillStorageDepot(self, oldValue, newMax)

        NotifyStorageUpgraded(self)

    end
end

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
    local oldValue = self.supply[resource]:GetActualAmount() -- GetStoredAmount(self)
    ModLog(tostring(GameTime()) .. " >ToggleUpgradeStorageDepot_oldValue= " .. tostring(oldValue))

    local newMax = oldMax
    if active or new_state then
        newMax = newMax + delta
    else
        newMax = newMax - delta
    end
    ModLog(tostring(GameTime()) .. " >ToggleUpgradeStorageDepot_newMax= " .. tostring(newMax))
    
    self[property] = newMax -- set max value
    ModLog(tostring(GameTime()) .. " >ToggleUpgradeStorageDepot_storageMax= " .. tostring(self[property]))

    FillStorageDepot(self, oldValue, newMax) -- set current value (stored)

    if active or new_state then
        NotifyStorageUpgraded(self)
    else
        NotifyStorageDowngraded(self)
    end

end

function DowngradeStorageDepot(self, upgrade_id)
    local active = self.upgrade_modifiers[upgrade_id][1].is_applied
    
    if not active then --
        local oldMax = self.max_storage_per_resource

        local resource = self.resource[1]
        local oldValue = self.supply[resource]:GetActualAmount() -- GetStoredAmount(self)

        local property = self.upgrade_modifiers[upgrade_id][1].prop -- property = max storage capacity
        local delta = self.upgrade_modifiers[upgrade_id][1].amount -- amount = X

        local newMax = oldMax - delta --
        self[property] = newMax

        FillStorageDepot(self, oldValue, newMax)

        NotifyStorageDowngraded(self) -- 

    end
end

-- /Code/PostBuildingUpgradeScript.lua = 35
-- ModLog(tostring(GameTime()) .. " >PATH= " .. tostring(ModElement:GetModRootPath()))
local function GetModLocation()
    return ModElement.GetModRootPath() --or debug.getinfo(1, "S").source:sub(2, -35)
end

local function GetStored(self, resource)
    return self.supply[resource]:GetActualAmount() --oldValue-- storage:GetStored_
end

-- Add upgrade-amount to max_amount_wasterock
function OnMsg.BuildingUpgraded(self, id)
    ModLog(tostring(GameTime()) .. " >MsgBuildingUpgraded:upgrade_id= " .. tostring(id))

    -- these are not the droids we are looking for
    if not IsStorageUpgrade(id) then
        ModLog(tostring(GameTime()) .. " >MsgBuildingUpgraded:NOT_storage_upgrade")
        return -- where does this leave us?
    end

    -- better solution than weird attributes is to use class checking
    if self.class == "WasteRockDumpSite" then
        ModLog(tostring(GameTime()) .. " >MsgBuildingUpgraded:Class:DumpSite= " .. tostring(self.class))
        UpgradeWasteRockDumpingSite(self)
    elseif self.class == "UniversalStorageDepot" then
        ModLog(tostring(GameTime()) .. " >MsgBuildingUpgraded:Class:Storage= " .. tostring(self.class))
        UpgradeStorageDepot(self, id)
    else
        ModLog(tostring(GameTime()) .. " >MsgBuildingUpgraded:Class:OTHER= " .. tostring(self.class))
    end

    ModLog(tostring(GameTime()) .. " >MsgBuildingUpgraded_END= " .. tostring(id))
end

--local old_BuildingOnUpgradeToggled = Building.OnUpgradeToggled or function() end
function Building:OnUpgradeToggled(upgrade_id, new_state)
    -- these are not the droids we are looking for
    if not IsStorageUpgrade(id) then
        ModLog(tostring(GameTime()) .. " >BuildingUpgradeToggled:NOT_storage_upgrade:" .. tostring(upgrade_id) .. ":" .. tostring(new_state))
        return -- where does this leave us?
    end

    -- better solution than weird attributes is to use class checking
    --if self.class == "WasteRockDumpSite" then
    ModLog(tostring(GameTime()) .. " >OnUpgradeToggled:CLASS:= " .. tostring(self.class) .. ":UPGRADE:=" .. tostring(upgrade_id) .. ":NEW_STATE:=" .. tostring(new_state))
    --ToggleUpgradeWasteRockDumpingSite(self, new_state)
    --  ToggleUpgradeStorageDepot(self, upgrade_id, new_state) -- incorporate methods
    -- elseif self.class == "UniversalStorageDepot" then
    --     ModLog(tostring(GameTime()) .. " >OnUpgradeToggled:Class:Storage= " .. tostring(self.class))
    -- else
    --     ModLog(tostring(GameTime()) .. " >OnUpgradeToggled:Class:OTHER= " .. tostring(self.class))
    -- end

    ToggleUpgradeStorageDepot(self, upgrade_id, new_state)
end

--[[
function StorageDepot:SetMaxCapacity(capacity)
    local resource = self.resource[1]
    local max_name = "max_amount_" .. resource
    self[max_name] = capacity
end

'upgrade1_id', "StorageConcrete_ExtraStorage", 
'upgrade1_display_name', T{773703751239, --[[ModItemBuildingTemplate StorageConcrete upgrade1_display_name] ] "Extra Storage"}, 
'upgrade1_description', T{162309256812, --[[ModItemBuildingTemplate StorageConcrete upgrade1_description] ] "+<upgrade1_add_value_1> Storage Space."}, 
'upgrade1_icon', "UI/Icons/Upgrades/service_bots_01.tga", 
'upgrade1_upgrade_cost_Concrete', 10000, 
'upgrade1_upgrade_time', 60000, 
'upgrade1_mod_label_1', "StorageConcrete", 
'upgrade1_mod_prop_id_1', "max_storage_per_resource", 
'upgrade1_add_value_1', 180, 

 Msg("TechResearched", tech_id, self, status.researched == 1)

BuildCategories = {
    {
        id = "Infrastructure", 
        name = T({
            78, 
            "Infrastructure"
        }), 
        img = "UI/Icons/bmc_infrastructure.tga", 
        highlight_img = "UI/Icons/bmc_infrastructure_shine.tga"
    }, 

    function WasteRockDumpSite:CheatEmpty()
        self.demand.WasteRock:SetAmount(self.max_amount_WasteRock)
        if self.supply.Concrete then
            self.supply.Concrete:SetAmount(0)
        end
        self:SetCount(0)
    end--]]

-- We will unlock upgrades after the first rocket has landed on mars
GlobalVar("g_StorageUpgradesUnlocked", false)

function OnMsg.RocketLanded(rocket)
    if g_StorageUpgradesUnlocked then
        return
    end

    UnlockStorageUpgrades()
    g_StorageUpgradesUnlocked = true

    --CreateRealTimeThread(function()
    --    local choice = WaitCustomPopupNotification("Test", "Desc", {"YES", "NO"})
    --      -- choice is 1 or 2 based on button click, if they ESC to close it returns 2
    --    )
end


--[[ MOD COMPATIBILITY - CheatMenu --]]
--stop these from happening
function ChoGGi.BlockCheatEmpty()
end
