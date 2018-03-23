-- Unlock upgrades we use for storage space
local function UnlockUpgrades()
    -- TODO: maybe do this with table.insert(UICity.unlocked_upgrades, something)
    UICity.unlocked_upgrades = {WasteRockDumpSite_ExtraStorage = true}
end

-- Add upgrade-amount to max_amount_wasterock
function OnMsg.BuildingUpgraded(self, id)
    -- these are not the droids we are looking for
    if id ~= "WasteRockDumpSite_ExtraStorage" then
        return -- where does this leave us?
    end

    -- wait, is this the right building?
    if self.max_amount_WasteRock ~= nil then
        -- save old max value
        local oldMax = self.max_amount_WasteRock

        -- is the building actually upgraded - because building_upgraded event is not evidence enough
        if self.upgrade_modifiers.WasteRockDumpSite_ExtraStorage ~= nil then
            -- take amount from upgrade definition
            local delta = self.upgrade_modifiers.WasteRockDumpSite_ExtraStorage[1].amount
            -- take is_applied from upgrade definition so we know if it's applied to our building
            local isActive = self.upgrade_modifiers.WasteRockDumpSite_ExtraStorage[1].is_applied

            -- omg, it is alive
            if isActive then
                -- we should probably raise this once
                -- TODO: raise this only once
                self.max_amount_WasteRock = oldMax + delta
                -- 
                --UI/Icons/Notifications/research_2.tga
                -- shouldn't we let people know how awesome we are
                --AddCustomOnScreenNotification("BuildingUpgraded", "Upgrade", self.display_name[2] .. " upgraded to store " .. self.max_amount_WasteRock .. " waste rock.") -- display_name is translated string - second element in array holds actual display name
                AddCustomOnScreenNotification("BuildingUpgraded", T{917892953978, "Building Upgraded"}, T{917892953977, "<building>"}, "UI/Icons/Sections/WasteRock_1.tga", false, 
                {building = self.display_name, expiration = 150000, priority = "Normal",})
                
            end
        end
    end
end

-- We will unlock upgrades after the first rocket has landed on mars
GlobalVar("g_StorageUpgradesUnlocked", false)

function OnMsg.RocketLanded(rocket)
    if g_StorageUpgradesUnlocked then
        return
    end

    g_StorageUpgradesUnlocked = true
    UnlockUpgrades()
end
