StorageUpgrades = {
    "WasteRockDumpSite_ExtraStorage", 
    "StorageMetals_ExtraStorage", 
    "StorageConcrete_ExtraStorage", 
    "StorageFood_ExtraStorage", 
    "StorageRareMetals_ExtraStorage", 
    "StoragePolymers_ExtraStorage", 
    "StorageElectronics_ExtraStorage", 
    "StorageMachineParts_ExtraStorage", 
    "StorageFuel_ExtraStorage", 
}

-- Check if upgrade is storage upgrade
function IsStorageUpgrade(upgrade)
    return StorageUpgrades[upgrade] ~= nil
end

-- Unlock upgrades we use for storage space
function UnlockUpgrades()
    -- UICity.unlocked_upgrades.WasteRockDumpSite_ExtraStorage = true
    -- OR
    -- UICity.unlocked_upgrades["WasteRockDumpSite_ExtraStorage"] = true
    for _, upgrade in pairs(StorageUpgrades) do
        UICity.unlocked_upgrades[upgrade] = true
    end
end

-- shouldn't we let people know how awesome we are
function NotifyUpgraded(self)
    AddCustomOnScreenNotification("BuildingUpgraded", T{917892953978, "Building Upgraded"}, T{917892953977, "<building>"}, GetModLocation() .. "UI/Icons/Notifications/building_upgraded.tga", false, {building = self.display_name, expiration = 50000, priority = "Normal",})
end

function NotifyDowngraded(self)
    AddCustomOnScreenNotification("BuildingDowngraded", T{917892953980, "Building Downgraded"}, T{917892953979, "<building>"}, GetModLocation() .. "UI/Icons/Notifications/building_upgraded_2.tga", false, {building = self.display_name, expiration = 150000, priority = "Important",})
end

function FillStorageDepot(self, amount, max)
    local resource = self.resource

    if self.supply[resource] then

        --local max_name = "max_amount_" .. resource
        --local _max = max -- self[max_name] or max -- 180

        -- test for max amount (cheat_fill)
        local _sup = amount -- 180
        local _dem = max - amount -- 180 - 180 = 0

        self.supply[resource]:SetAmount(_sup) 
        self.demand[resource]:SetAmount(_dem)

    end

    self:SetCount(self.supply[resource]:GetActualAmount())
end

function FillWasteRockDumpingSite(self, amount)
    local _max = self.max_amount_WasteRock -- 180

    -- test for max amount (cheat_fill)
    local _sup = amount -- 180
    local _dem = _max - amount -- 180 - 180 = 0

    self.demand.WasteRock:SetAmount(_dem)
    if self.supply.Concrete then
        self.supply.Concrete:SetAmount(_sup / Max(1, g_Consts.WasteRockToConcreteRatio))
    end
    self:SetCount(_sup)
end

function UpgradeStorageDepot(self)
    local oldMax = self.max_storage_per_resource

    local resource = self.storable_resources[1] -- we know we store only one resource -- what about universal
    local oldValue = GetStored(self, resource)

    local active = self.upgrade_modifiers[id][1].is_applied
    
    if active then

        local property = self.upgrade_modifiers[id][1].prop -- property = max storage capacity
        local delta = self.upgrade_modifiers[id][1].amount -- amount = X

        local newMax = oldMax + delta
        self[property] = newMax

        FillStorageDepot(self, oldValue, newMax)

        NotifyUpgraded(self)
    end
end

local function GetModLocation()
    return ModElement.GetModRootPath() --or debug.getinfo(1, "S").source:sub(2, -35)
end
-- /Code/PostBuildingUpgradeScript.lua = 35
-- ModLog(tostring(GameTime()) .. " >PATH= " .. tostring(ModElement:GetModRootPath()))

local function GetStored(self, resource)
    return self.supply[resource]:GetActualAmount() --oldValue-- storage:GetStored_
end

-- Add upgrade-amount to max_amount_wasterock
function OnMsg.BuildingUpgraded(self, id)
    -- these are not the droids we are looking for
    if not IsStorageUpgrade(id) then
        return -- where does this leave us?
    end
    
    -- wait, is this the right building?
    if self.max_storage_per_resource ~= nil then -- and not self.max_amount_WasteRock ~= nil then -- it's storage, but not waste rock, since that's special
        -- save old max value
        local oldMax = self.max_storage_per_resource

        -- dynamically creating and executing function to get old stored_value for specific (dynamic) resource
        local resource = self.storable_resources[1] -- we know we store only one resource
        local oldValue = GetStored(self, resource)

        if self.upgrade_modifiers[id] ~= nil then
            local delta = self.upgrade_modifiers[id][1].amount
            local active = self.upgrade_modifiers[id][1].is_applied
            local property = self.upgrade_modifiers[id][1].prop

            if active then
                -- self.max_storage_per_resource = oldMax + delta
                -- DOCUMENTATION:
                -- local property = self.upgrade_modifiers[id][1].prop //= max_storage_per_resource
                -- self[property] //= self.max_storage_per_resource
                self[property] = oldMax + delta

                self:CheatEmpty()
                self:AddDepotResource(resource, oldValue)

                NotifyUpgraded(self)
            end
        end
    end
    


    -- wait, is this the right building?
    if self.max_amount_WasteRock ~= nil then

        -- save old max value
        local oldMax = self.max_amount_WasteRock
        local oldValue = self:GetStored_WasteRock()

        -- is the building actually upgraded - because building_upgraded event is not evidence enough
        if self.upgrade_modifiers.WasteRockDumpSite_ExtraStorage ~= nil then
            -- take amount from upgrade definition
            local delta = self.upgrade_modifiers.WasteRockDumpSite_ExtraStorage[1].amount
            -- take is_applied from upgrade definition so we know if it's applied to our building
            local active = self.upgrade_modifiers.WasteRockDumpSite_ExtraStorage[1].is_applied

            -- omg, it is alive
            if active then
                -- we should probably raise this once
                -- TODO: raise this only once

                self.max_amount_WasteRock = oldMax + delta
                self:CheatEmpty()
                self:AddDepotResource("WasteRock", oldValue)
                -- 
                
                NotifyUpgraded(self)
            end
        end
    end
end

local old_BuildingOnUpgradeToggled = Building.OnUpgradeToggled or function() end
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
            
            NotifyUpgraded(self)
            --self:SetCount(oldStored)
        else -- false
            if(oldMax - delta) > 0 then
                -- downgrade: initial state (true), new state (false) -- we have to downgrade building
                self.max_amount_WasteRock = 70000-- oldMax - delta
                self:CheatEmpty()
                self:AddDepotResource("WasteRock", oldValue)
                --ModLog(tostring(GameTime()) .. " >= " .. tostring(self.max_amount_WasteRock))

                NotifyDowngraded(self)
            end

        end

    end

    old_BuildingOnUpgradeToggled(self)
end

--[[function WasteRockDumpSite:CheatEmpty()
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

    UnlockUpgrades()
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




