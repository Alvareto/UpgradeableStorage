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


local function GetModLocation()
    -- /Code/PostBuildingUpgradeScript.lua = 35
    -- ModLog(tostring(GameTime()) .. " >PATH= " .. tostring(ModElement:GetModRootPath()))
    return debug.getinfo(1, "S").source:sub(2, -35)
end

-- Dynamically creating and executing function to get old stored_value for specific (dynamic) resource
function GetStored(storage, resource)
    --local resource = self.storable_resources[1] -- we know we store only one resource
    local funcString = "storage:GetStored_" .. resource .. "()" -- Stored_PreciousMetals
    --
    local fun, err = load(funcString, nil, nil, _G)
    local oldValue = fun()


    return oldValue-- storage:GetStored_
end

-- Add upgrade-amount to max_amount_wasterock
function OnMsg.BuildingUpgraded(self, id)
    -- these are not the droids we are looking for
    --if id ~= "WasteRockDumpSite_ExtraStorage" then

    if not IsStorageUpgrade(id) then
        return -- where does this leave us?
    end
    
    -- 
    local this_mod_dir = GetModLocation()

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

                AddCustomOnScreenNotification("BuildingUpgraded", T{917892953978, "Building Upgraded"}, T{917892953977, "<building>"}, this_mod_dir .. "UI/Icons/Notifications/building_upgraded.tga", false, 
                {building = self.display_name, expiration = 50000, priority = "Normal",})
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
                --UI/Icons/Notifications/research_2.tga
                -- shouldn't we let people know how awesome we are
                --AddCustomOnScreenNotification("BuildingUpgraded", "Upgrade", self.display_name[2] .. " upgraded to store " .. self.max_amount_WasteRock .. " waste rock.") -- display_name is translated string - second element in array holds actual display name
                AddCustomOnScreenNotification("BuildingUpgraded", T{917892953978, "Building Upgraded"}, T{917892953977, "<building>"}, this_mod_dir .. "UI/Icons/Notifications/building_upgraded.tga", false, 
                {building = self.display_name, expiration = 50000, priority = "Normal",})
                
            end
        end
    end
end

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
            AddCustomOnScreenNotification("BuildingUpgradeToggled", T{917892953979, "Building Upgraded"}, T{917892953978, "<building>"}, this_mod_dir .. "UI/Icons/Notifications/building_upgraded.tga", false, {building = self.display_name, expiration = 150000, priority = "Normal",})
            --self:SetCount(oldStored)
        else -- false
            if(oldMax - delta) > 0 then
                -- downgrade: initial state (true), new state (false) -- we have to downgrade building
                self.max_amount_WasteRock = 70000-- oldMax - delta
                self:CheatEmpty()
                self:AddDepotResource("WasteRock", oldValue)
                --ModLog(tostring(GameTime()) .. " >= " .. tostring(self.max_amount_WasteRock))

                AddCustomOnScreenNotification("BuildingUpgradeToggled", T{917892953980, "Building Downgraded"}, T{917892953979, "<building>"}, this_mod_dir .. "UI/Icons/Notifications/building_upgraded_2.tga", false, {building = self.display_name, expiration = 150000, priority = "Important",})
            end

        end

    end
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




