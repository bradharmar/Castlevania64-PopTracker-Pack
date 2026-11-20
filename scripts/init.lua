local variant = Tracker.ActiveVariantUID

-- Items
Tracker:AddItems("items/items.json")

-- Logic
require("scripts.logic.logic_helper")
require("scripts.logic.base_logic")
require("scripts.logic.graph_logic.logic_main")

-- Maps
Tracker:AddMaps("maps/maps.json")

-- Layout
Tracker:AddLayouts("layouts/items.json")
Tracker:AddLayouts("layouts/map_groups.json")
Tracker:AddLayouts("layouts/tabs.json")
Tracker:AddLayouts("layouts/broadcast.json")
Tracker:AddLayouts("layouts/tracker.json")

-- Locations
Tracker:AddMaps("maps/maps.json")
Tracker:AddLocations("locations/overview.json")
Tracker:AddLocations("locations/castle_center.json")
Tracker:AddLocations("locations/castle_keep.json")
Tracker:AddLocations("locations/castle_wall.json")
Tracker:AddLocations("locations/clock_tower.json")
Tracker:AddLocations("locations/duel_tower.json")
Tracker:AddLocations("locations/forest_of_silence.json")
Tracker:AddLocations("locations/renons_shop.json")
Tracker:AddLocations("locations/room_of_clocks.json")
Tracker:AddLocations("locations/tower_of_execution.json")
Tracker:AddLocations("locations/tower_of_science.json")
Tracker:AddLocations("locations/tower_of_scorcery.json")
Tracker:AddLocations("locations/tunnel.json")
Tracker:AddLocations("locations/underground_waterway.json")
Tracker:AddLocations("locations/villa.json")



-- AutoTracking for PopTracker
if PopVersion and PopVersion >= "0.26.0" then
    require("scripts.autotracking")
end

function OnFrameHandler()
    ScriptHost:RemoveOnFrameHandler("load handler")
    -- stuff
    ScriptHost:AddWatchForCode("StateChanged", "*", StateChanged)
    ScriptHost:AddOnLocationSectionChangedHandler("location_section_change_handler", LocationHandler)
    CreateLuaManualStorageItem("manual_location_storage")
    ForceUpdate()
end
require("scripts.luaitems")
require("scripts.watches")
ScriptHost:AddOnFrameHandler("load handler", OnFrameHandler)