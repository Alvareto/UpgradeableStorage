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

                -- shouldn't we let people know how awesome we are
                AddCustomOnScreenNotification("BuildingUpgraded", "Upgrade", self.display_name[2] .. " upgraded to store " .. self.max_amount_WasteRock .. " waste rock.") -- display_name is translated string - second element in array holds actual display name
            end
        end
    end
end

--[[
    for _, upgrade in ipairs(self.upgrade_modifiers) do
        if upgrade.WasteRockDumpSite_ExtraStorage ~= nil then-- .upgrade_id
            AddCustomOnScreenNotification("BuildingUpgraded", "Upgrade", "info ID(" .. id .. "): " .. upgrade)
        end
        -- 
    end



if RSBTechMap[tech_id] ~= nil then 
    local RSBTech = TechDef[tech_id]
    local tech = RollTech(tech_id)
    local functionName = (string.gsub)(tech_id, "RSBBreakthrough", "RSBGrant")
    if IsTechDiscovered(tech) then
        _, err = pcall(_G[functionName], city, RSBTech)
        --AddCustomOnScreenNotification("LOG", "ERROR", "ERR: " .. err)
    else
        AddCustomOnScreenNotification("Discovery", "Breakthrough", "Discovered " .. tech)
        DiscoverTech(tech)
    end
end


for _, workplace in ipairs(UICity.labels.Workplace) do
    if workplace.auto_performance ~= nil then
        if workplace.default_auto_performance == nil then
            workplace.default_auto_performance = workplace.auto_performance
        end
        workplace.auto_performance = workplace.default_auto_performance + g_Consts.RSBRoboticsPerformanceBonus
        workplace.UpdatePerformance()
    end
end
]]






















