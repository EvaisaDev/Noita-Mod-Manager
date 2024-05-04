local json = dofile("mods/evaisa.modmanager/lib/json.lua")
local nxml = dofile("mods/evaisa.modmanager/lib/nxml.lua")

local api = {}

api.GetModData = function()
    local save_folder
    if not DebugGetIsDevBuild() then
        save_folder = os.getenv('APPDATA'):gsub("\\Roaming", "").."\\LocalLow\\Nolla_Games_Noita\\save00\\mod_config.xml"
    else
        save_folder = "save00/mod_config.xml"
    end

    local file,err = io.open(save_folder,'rb')
    if file then
        local content = file:read("*all")

        local data = {}

        local parsedModData = nxml.parse(content)
        for elem in parsedModData:each_child() do
            if(elem.name == "Mod")then
                local modID = elem.attr.name
                local steamID = elem.attr.workshop_item_id
    
                local infoFile = "mods/"..modID.."/mod.xml"
                if(steamID ~= "0")then
                    infoFile = "../../workshop/content/881100/"..steamID.."/mod.xml"
                end

                local file2,err = io.open(infoFile,'rb')
                if file2 then
                    local content2 = file2:read("*all")
                    local parsedModInfo = nxml.parse(content2)
                    table.insert(data, {workshop_item_id = steamID, id = modID, name = parsedModInfo.attr.name, description = parsedModInfo.attr.description, settings_fold_open = (elem.attr.settings_fold_open == "1" and true or false), enabled = (elem.attr.enabled == "1" and true or false)})
                
                end
            end
        end

        --ModSettingSet("ModMan.ModData", json.stringify(data))

        file:close()

        return data
    end
end

api.SaveModData = function(data)
    local json = dofile("mods/evaisa.modmanager/lib/json.lua")
    local nxml = dofile("mods/evaisa.modmanager/lib/nxml.lua")
    local pretty = dofile("mods/evaisa.modmanager/lib/pretty.lua")

    local save_folder
    if not DebugGetIsDevBuild() then
        save_folder = os.getenv('APPDATA'):gsub("\\Roaming", "").."\\LocalLow\\Nolla_Games_Noita\\save00\\mod_config.xml"
    else
        save_folder = "save00/mod_config.xml"
    end

    local file,err = io.open(save_folder,'w')
    if file then
        local content = "<Mods>\n\n";
        for i = #data, 1, -1 do
            local v = data[i]
            content = content .. [[<Mod enabled="]]..(v.enabled and "1" or "0")..[[" name="]]..v.id..[[" settings_fold_open="]]..(v.settings_fold_open and "1" or "0")..[[" workshop_item_id="]]..(v.workshop_item_id or "0")..[[" ></Mod>]].."\n\n"
        end
        content = content .. "</Mods>"

        file:write(content)
        file:close()
    end
end

api.SavePreset = function(name, data, settings)
    local preset = {
        name = name,
        data = {},
        settings = settings,
    }
    for i = #data, 1, -1 do
        local v = data[i]
        table.insert(preset.data, {id = v.id, enabled = v.enabled, workshop_item_id = v.workshop_item_id})
    end
    local presetFolder = "presets"
    lfs.mkdir(presetFolder)
    --os.execute("mkdir -p " .. presetFolder)
    local presetFile = presetFolder.."/"..name..".json"
    local json = dofile("mods/evaisa.modmanager/lib/json.lua")
    local file,err = io.open(presetFile,'w')
    if file then
        file:write(json.stringify(preset))
        file:close()
    end
    local presetInfo = {}
    for file in lfs.dir(presetFolder) do
        if file ~= "." and file ~= ".." then
            local f = presetFolder.."/"..file
            local attr = lfs.attributes (f)
            if attr.mode == "file" then
                local name = string.sub(file, 1, string.len(file) - 5)
                local isJson = string.sub(file, string.len(file) - 4, string.len(file)) == ".json"
                if(isJson)then
                    table.insert(presetInfo, name)
                end
            end
        end
    end

    --ModSettingSet("ModMan.Presets", json.stringify(presetInfo))

end

api.SavePresetWithSettings = function(preset_name, data)
    local settingCount = ModSettingGetCount()
    local settings = {}
    for i = 1, settingCount do
        local name, value, value_next = ModSettingGetAtIndex(i)
        table.insert(settings, {key = name, value = value, value_next = value_next})
    end
    api.SavePreset(preset_name, data, settings)
end

api.ApplySettings = function(settings)
    local json = dofile("mods/evaisa.modmanager/lib/json.lua")
    print(json.stringify(settings))
    for k, v in ipairs(settings)do
        if(v.key ~= nil)then
           -- print(tostring(v.key), tostring(v.value), tostring(v.value_next))
            ModSettingSet(v.key, v.value)
            if(v.value_next)then
                ModSettingSetNextValue(v.key, v.value_next, false) 
            end
        end
    end
end

api.SaveToCode = function(name, data, settings)
    local json = dofile("mods/evaisa.modmanager/lib/json.lua")
    local base = dofile("mods/evaisa.modmanager/lib/base.lua")
    local libdeflate = dofile("mods/evaisa.modmanager/lib/libdeflate.lua")
    local clipboard = dofile("mods/evaisa.modmanager/lib/clipboard.lua")
    local preset = {
        name = name,
        data = {},
        settings = settings,
    }
    for i = #data, 1, -1 do
        local v = data[i]
        if(v.enabled)then
            local input = v.id
            if(v.workshop_item_id ~= "0")then
                input = v.workshop_item_id
            end
            table.insert(preset.data, input)
        end
    end
    local presetJson = json.stringify(preset.data)

    -- remove first and last character
    presetJson = string.sub(presetJson, 2, string.len(presetJson) - 1)
    -- replace ", " with "/"
    presetJson = string.gsub(presetJson, ', ', '/')
    -- remove quotes
    presetJson = string.gsub(presetJson, '"', '')

    local encoded = base.to_z85(libdeflate:CompressDeflate(presetJson))

    clipboard.set(preset.name.."|"..encoded)
end

api.SaveToCodeWithSettings = function(name, data)
    local settingCount = ModSettingGetCount()
    local settings = {}
    for i = 1, settingCount do
        local name, value, value_next = ModSettingGetAtIndex(i)
        table.insert(settings, {key = name, value = value, value_next = value_next})
    end
    api.SaveToCode(name, data, settings)
end

api.LoadFromClipboard = function(data)
    local json = dofile("mods/evaisa.modmanager/lib/json.lua")
    local base = dofile("mods/evaisa.modmanager/lib/base.lua")
    local libdeflate = dofile("mods/evaisa.modmanager/lib/libdeflate.lua")
    local clipboard = dofile("mods/evaisa.modmanager/lib/clipboard.lua")
    local clipboardData = clipboard.get()

    local name, encoded = string.match(clipboardData, "(.-)|(.*)")
    local decoded = base.from_z85(encoded)
    local decompressed = libdeflate:DecompressDeflate(decoded)
    -- split by "/"
    local split = {}
    for str in string.gmatch(decompressed, "([^/]+)") do
        table.insert(split, str)
    end
    
    local preset = {name = name, data = {}, settings = {}}

    for k, v in ipairs(split)do
        for i = #data, 1, -1 do
            local elem = data[i]
            if((elem.id == v and elem.workshop_item_id == "0") or elem.workshop_item_id == v)then
                table.insert(preset.data, {id = elem.id, enabled = true, workshop_item_id = elem.workshop_item_id})
            end
        end
    end

    return preset
end

api.OpenSteamWorkshopPage = function(mod_id)
    os.execute("start steam://openurl/https://steamcommunity.com/sharedfiles/filedetails/?id="..mod_id)
end

api.RefreshPresets = function()
    local presetFolder = "presets"
    lfs.mkdir(presetFolder)
    --os.execute("mkdir -p " .. presetFolder)
    local presetInfo = {}
    for file in lfs.dir(presetFolder) do
        if file ~= "." and file ~= ".." then
            local f = presetFolder.."/"..file
            local attr = lfs.attributes (f)
            if attr.mode == "file" then
                local name = string.sub(file, 1, string.len(file) - 5)
                local isJson = string.sub(file, string.len(file) - 4, string.len(file)) == ".json"
                if(isJson)then
                    table.insert(presetInfo, name)
                end
            end
        end
    end

    return presetInfo
    --ModSettingSet("ModMan.Presets", json.stringify(presetInfo))
end

api.LoadPreset = function(name)
    local presetFolder = "presets"
    local presetFile = presetFolder.."/"..name..".json"
    local json = dofile("mods/evaisa.modmanager/lib/json.lua")
    local file,err = io.open(presetFile,'rb')
    if file then
        local content = file:read("*all")
        local preset = json.parse(content)
        file:close()
        --ModSettingSet("ModMan.Preset", json.stringify(preset))
        return preset
    end
end

api.OpenPresetsFolder = function()
    local preset_folder_name = lfs.currentdir().."\\presets"

    print(preset_folder_name)

    os.execute("start explorer \"" .. preset_folder_name .. "\"")
end

api.RemovePreset = function(name)
    local json = dofile("mods/evaisa.modmanager/lib/json.lua")
    local presetFolder = "presets"
    local presetFile = presetFolder.."/"..name..".json"
    os.remove(presetFile)
    local presetInfo = {}
    for file in lfs.dir(presetFolder) do
        if file ~= "." and file ~= ".." then
            local f = presetFolder.."/"..file
            local attr = lfs.attributes (f)
            if attr.mode == "file" then
                local name = string.sub(file, 1, string.len(file) - 5)
                local isJson = string.sub(file, string.len(file) - 4, string.len(file)) == ".json"
                if(isJson)then
                    table.insert(presetInfo, name)
                end
            end
        end
    end
end

return api