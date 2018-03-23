function OnMsg.ClassesBuilt()
    XTemplates.customWasteRockDumpSmall = PlaceObj("XTemplate", {
        group = "Infopanel Sections", 
        id = "customWasteRockDumpBig", 
        PlaceObj("XTemplateTemplate", {
            "__context_of_kind", 
            "WasteRockDumpSite", 
            "__template", 
            "InfopanelSection", 
            "RolloverText", 
            T({
                490, 
                "Amount Waste Rock stored."
            }), 
            "Title", 
            T({
                489, 
                "Available resources"
            }), 
            "Icon", 
            "UI/Icons/Sections/WasteRock_4.tga"
            }, {
            PlaceObj("XTemplateTemplate", {
                "__template", 
                "InfopanelText", 
                "Text", 
                T({
                    491, 
                    "<resource('WasteRock')><right><wasterock(Stored_WasteRock, MaxAmount_WasteRock)>"
                })})})})

            end 

            

            

           