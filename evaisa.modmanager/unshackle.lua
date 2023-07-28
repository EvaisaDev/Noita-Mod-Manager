--EZMouse = dofile_once("mods/evaisa.modmanager/lib/EZMouse/EZMouse.lua")("mods/evaisa.modmanager/lib/EZMouse/")

gui = gui or GuiCreate();

widgets = {}
presets = {}

function DefineWidget(data)
    table.insert(widgets, data)
end

--[[if(ModIsEnabled("evaisa.unshackle"))then
    api = dofile("mods/evaisa.unshackle/functions.lua")
end]]

api = dofile("mods/evaisa.modmanager/modmanager_api.lua")

json = dofile("mods/evaisa.modmanager/lib/json.lua")
local nxml = dofile("mods/evaisa.modmanager/lib/nxml.lua")
local pretty = dofile("mods/evaisa.modmanager/lib/pretty.lua")

get_content = ModTextFileGetContent


function ReadModList()

end


function RefreshMods()
    --ModSettingRemove("ModMan.ModData")
    widgets = {}
    local modData = api.GetModData()

    for i = #modData, 1, -1 do
        local v = modData[i]
        
        DefineWidget(v)
    end
end

function RefreshPresets()
    --ModSettingRemove("ModMan.Presets")
    presets = api.RefreshPresets()
end


function OnMagicNumbersAndWorldSeedInitialized() 
    --ModSettingSet("unshackle_imgui.imgui_build_type", "debug")
    if(ModIsEnabled("evaisa.unshackle"))then
        RefreshMods()
        RefreshPresets()
    end
end


menuOpen = menuOpen or false
allowOpen = false

function OnPausedChanged(is_paused, is_inventory_pause)
    if(not is_paused)then
        menuOpen = false
        allowOpen = false
    else
        if(not is_inventory_pause)then
            allowOpen = true
        end
    end
end


function OnPausePreUpdate()
    if(ModIsEnabled("evaisa.unshackle"))then
        --dofile("mods/evaisa.modmanager/files/gui2.lua")
        dofile("mods/evaisa.modmanager/files/gui.lua")
    else
        dofile("mods/evaisa.modmanager/files/shackledgui.lua")
    end
end