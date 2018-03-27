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
    
    ModLog(tostring(GameTime()) .. " >FillStorageDepot_IFSupply= " .. tostring(self.supply[resource]))
    if self.supply[resource] then

        --local max_name = "max_amount_" .. resource
        --local _max = max -- self[max_name] or max -- 180

        -- test for max amount (cheat_fill)
        local _sup = amount -- 180
        ModLog(tostring(GameTime()) .. " >FillStorageDepot_supply= " .. tostring(_sup))
        local _dem = max - amount -- 180 - 180 = 0
        ModLog(tostring(GameTime()) .. " >FillStorageDepot_demand= " .. tostring(_dem))

        self.supply[resource]:SetAmount(_sup)
        self.demand[resource]:SetAmount(_dem)

    end

    ModLog(tostring(GameTime()) .. " >FillStorageDepot_supplyAmount= " .. tostring(self.supply[resource]:GetActualAmount()))
    self:SetCount(self.supply[resource]:GetActualAmount())
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

function UpgradeWasteRockDumpingSite(self)
    -- take is_applied from upgrade definition so we know if it's applied to our building
    local active = self.upgrade_modifiers.WasteRockDumpSite_ExtraStorage[1].is_applied
    ModLog(tostring(GameTime()) .. " >UpgradeWasteRockDumpingSite_active= " .. tostring(active))

    -- omg, it is alive
    if active then
        -- save old max value
        local oldMax = self.max_amount_WasteRock
        ModLog(tostring(GameTime()) .. " >UpgradeWasteRockDumpingSite_oldMax= " .. tostring(oldMax))
        local oldValue = self:GetStored_WasteRock()
        ModLog(tostring(GameTime()) .. " >UpgradeWasteRockDumpingSite_oldValue= " .. tostring(oldValue))

        -- take amount from upgrade definition
        local delta = self.upgrade_modifiers.WasteRockDumpSite_ExtraStorage[1].amount
        ModLog(tostring(GameTime()) .. " >UpgradeWasteRockDumpingSite_delta= " .. tostring(delta))

        self.max_amount_WasteRock = oldMax + delta
        ModLog(tostring(GameTime()) .. " >UpgradeWasteRockDumpingSite_selfMax= " .. tostring(self.max_amount_WasteRock))

        FillWasteRockDumpingSite(self, oldValue)
        
        NotifyStorageUpgraded(self)
    end
end

function UpgradeStorageDepot(self, upgrade_id)
    local resource = self.resource[1]
    -- 62203 >UpgradeStorageDepot_INIT= table: 0000029102A90030 > nil > table: 0000029102DB6288
    ModLog(tostring(GameTime()) .. " >UpgradeStorageDepot_INIT= " .. tostring(self.display_name) .. " > " .. tostring(upgrade_id) .. " > " .. tostring(resource))

    local active = self.upgrade_modifiers[upgrade_id][1].is_applied
    ModLog(tostring(GameTime()) .. " >UpgradeStorageDepot_active= " .. tostring(active))

    if active then
        local oldMax = self.max_storage_per_resource
        ModLog(tostring(GameTime()) .. " >UpgradeStorageDepot_oldMax= " .. tostring(oldMax))
        local oldValue = self.supply[resource]:GetActualAmount() -- GetStoredAmount(self)
        ModLog(tostring(GameTime()) .. " >UpgradeStorageDepot_oldValue= " .. tostring(oldValue))

        local property = self.upgrade_modifiers[upgrade_id][1].prop -- property = max storage capacity
        ModLog(tostring(GameTime()) .. " >UpgradeStorageDepot_property= " .. tostring(property))
        local delta = self.upgrade_modifiers[upgrade_id][1].amount -- amount = X
        ModLog(tostring(GameTime()) .. " >UpgradeStorageDepot_delta= " .. tostring(delta))

        local newMax = oldMax + delta
        ModLog(tostring(GameTime()) .. " >UpgradeStorageDepot_newMax= " .. tostring(newMax))
        self[property] = newMax
        ModLog(tostring(GameTime()) .. " >UpgradeStorageDepot_storageMax= " .. tostring(self[property]))

        FillStorageDepot(self, oldValue, newMax)

        NotifyStorageUpgraded(self)

    end
end

function ToggleUpgradeStorageDepot(self, upgrade_id, new_state)
    local active = self.upgrade_modifiers[upgrade_id][1].is_applied

    local oldMax = self.max_storage_per_resource

    local resource = self.resource[1]
    local oldValue = self.supply[resource]:GetActualAmount() -- GetStoredAmount(self)

    local property = self.upgrade_modifiers[upgrade_id][1].prop -- property = max storage capacity
    local delta = self.upgrade_modifiers[upgrade_id][1].amount -- amount = X

    local newMax = oldMax
    if active or new_state then
        newMax = newMax + delta
    else
        newMax = newMax - delta
    end

    self[property] = newMax -- set max value

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
    if upgrade_id ~= "WasteRockDumpSite_ExtraStorage" then
        return -- where does this leave us?
    end

    -- wait, is this the right building?
    if self.max_amount_WasteRock ~= nil then
        -- 
        local this_mod_dir = GetModLocation()

        -- save old max value
        local oldMax = self.max_amount_WasteRock
        --local.oldStored = self.max_amount_WasteRock - (self.demand and self.demand.WasteRock:GetActualAmount() or 0)
        local oldValue = self:GetStored_WasteRock()
        
        -- take amount from upgrade definition
        local delta = self.upgrade_modifiers.WasteRockDumpSite_ExtraStorage[1].amount
        local active = self.upgrade_modifiers.WasteRockDumpSite_ExtraStorage[1].is_applied

        if new_state or active then -- true
            -- upgrade: initial state (false), new state (true) -- we have to upgrade building
            self.max_amount_WasteRock = oldMax + delta
            self:CheatEmpty()
            self:AddDepotResource("WasteRock", oldValue)
            --ModLog(tostring(GameTime()) .. " >= " .. tostring(self.max_amount_WasteRock))
            
            NotifyStorageUpgraded(self)
            --self:SetCount(oldStored)
        else -- false
            if(oldMax - delta) > 0 then
                -- downgrade: initial state (true), new state (false) -- we have to downgrade building
                self.max_amount_WasteRock = 70000-- oldMax - delta
                self:CheatEmpty()
                self:AddDepotResource("WasteRock", oldValue)
                --ModLog(tostring(GameTime()) .. " >= " .. tostring(self.max_amount_WasteRock))

                NotifyStorageDowngraded(self)
            end

        end

    end

    --old_BuildingOnUpgradeToggled(self)
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
