local translations = ModTextFileGetContent("mods/evaisa.modmanager/translations.csv")
local main = "data/translations/common.csv"
ModTextFileSetContent(main, ModTextFileGetContent(main) .. translations:gsub("^[^\n]*\n", "\n", 1))

function OnWorldPreUpdate()
    if(GameGetFrameNum() > 60 * 3)then
        if(not ModIsEnabled("evaisa.unshackle"))then
            GamePrint("[ModManager]"..GameTextGetTranslatedOrNot("$modmanager_no_unshackle"))
        elseif(not GameHasFlagRun( "unshackle2_loaded" ))then
            GamePrint("[ModManager]"..GameTextGetTranslatedOrNot("$modmanager_outdated_unshackle"))
        end
    end
end

--[[if(ModIsEnabled("evaisa.unshackle"))then
    ModLuaFileAppend("mods/evaisa.unshackle/functions.lua", "mods/evaisa.modmanager/files/registerfunctions.lua")
end
--EZMouse = dofile_once("mods/evaisa.modmanager/lib/EZMouse/EZMouse.lua")("mods/evaisa.modmanager/lib/EZMouse/")

gui = gui or GuiCreate();

widgets = {}
presets = {}

function DefineWidget(data)
    table.insert(widgets, data)
end

if(ModIsEnabled("evaisa.unshackle"))then
    api = dofile("mods/evaisa.unshackle/functions.lua")
end
json = dofile("mods/evaisa.modmanager/lib/json.lua")
local nxml = dofile("mods/evaisa.modmanager/lib/nxml.lua")
local pretty = dofile("mods/evaisa.modmanager/lib/pretty.lua")

get_content = ModTextFileGetContent

function ReadModList()
    local modData = json.parse(ModSettingGet("ModMan.ModData"))

    for i = #modData, 1, -1 do
        local v = modData[i]
        
        DefineWidget(v)
    end
end


function RefreshMods()
    ModSettingRemove("ModMan.ModData")
    widgets = {}
    api.GetModData()
end

function RefreshPresets()
    ModSettingRemove("ModMan.Presets")
    presets = {}
    api.RefreshPresets()
end


function OnMagicNumbersAndWorldSeedInitialized() 
    ModSettingSet("unshackle_imgui.imgui_build_type", "debug")
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
        if(#widgets == 0 and ModSettingGet("ModMan.ModData") ~= nil)then
            
            ReadModList()
        end

        if(ModSettingGet("ModMan.Presets") ~= nil)then
            presets = json.parse(ModSettingGet("ModMan.Presets"))
            ModSettingRemove("ModMan.Presets")
        end
        

        dofile("mods/evaisa.modmanager/files/gui2.lua")
    else
        dofile("mods/evaisa.modmanager/files/shackledgui.lua")
    end
end]]

function OnPausePreUpdate()
    if(not ModIsEnabled("evaisa.unshackle"))then
        dofile("mods/evaisa.modmanager/files/shackledgui.lua")
    end
end