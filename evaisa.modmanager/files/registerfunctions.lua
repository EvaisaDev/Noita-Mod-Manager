--[[
RegisterFunction("ReadFileData", function(filePath, storageName)
    local file,err = io.open(filePath,'rb')
    if file then
        local content = file:read("*all")
        ModSettingSet(storageName, content)
        print(content)
        file:close()
    else
        print("error:", err) -- not so hard?
    end
end)
]]

RegisterFunction("GetModData", function()
    local json = dofile("mods/evaisa.modmanager/lib/json.lua")
    local nxml = dofile("mods/evaisa.modmanager/lib/nxml.lua")
    local save_folder = os.getenv('APPDATA'):gsub("\\Roaming", "").."\\LocalLow\\Nolla_Games_Noita\\save00\\mod_config.xml"

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

        ModSettingSet("ModMan.ModData", json.stringify(data))

        file:close()
    end

end)

RegisterFunction("SaveModData", function(data)
    local json = dofile("mods/evaisa.modmanager/lib/json.lua")
    local nxml = dofile("mods/evaisa.modmanager/lib/nxml.lua")
    local pretty = dofile("mods/evaisa.modmanager/lib/pretty.lua")

    local save_folder = os.getenv('APPDATA'):gsub("\\Roaming", "").."\\LocalLow\\Nolla_Games_Noita\\save00\\mod_config.xml"

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
end)

RegisterFunction("SavePreset", function(name, data)
    local preset = {
        name = name,
        data = {},
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
    --[[local presetInfoFile = presetFolder.."/storedpresets.json"
    local file2,err = io.open(presetInfoFile,'r')
    local presetInfo = {}
    if file2 then
        local content = file2:read("*all")
        file2:close()
        
        presetInfo = json.parse(content)
        -- if presetInfo does not contain name then add it
        local found = false
        for i = #presetInfo, 1, -1 do
            local v = presetInfo[i]
            if(v == name)then
                found = true
                break
            end
        end
        if(not found)then
            table.insert(presetInfo, name)
        end

        local file3,err = io.open(presetInfoFile,'w')
        if file3 then
            file3:write(json.stringify(presetInfo))
            file3:close()
        end
        
    else
        local file3,err = io.open(presetInfoFile,'w')
        if file3 then
            table.insert(presetInfo, name)
            file3:write(json.stringify(presetInfo))
            file3:close()
        end
    end]]
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

    ModSettingSet("ModMan.Presets", json.stringify(presetInfo))
end)

RegisterFunction("OpenSteamWorkshopPage", function(mod_id)
    os.execute("start steam://openurl/https://steamcommunity.com/sharedfiles/filedetails/?id="..mod_id)
end)

RegisterFunction("RefreshPresets", function()
    local json = dofile("mods/evaisa.modmanager/lib/json.lua")
    local presetFolder = "presets"
    lfs.mkdir(presetFolder)
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
    --[[
    local presetInfoFile = presetFolder.."/storedpresets.json"
    local json = dofile("mods/evaisa.modmanager/lib/json.lua")
    local file2,err = io.open(presetInfoFile,'rb')
    local presetInfo = {}
    if file2 then
        local content = file2:read("*all")
        presetInfo = json.parse(content)
        file2:close()
    end
    ]]
    ModSettingSet("ModMan.Presets", json.stringify(presetInfo))
end)

RegisterFunction("LoadPreset", function(name)
    local presetFolder = "presets"
    local presetFile = presetFolder.."/"..name..".json"
    local json = dofile("mods/evaisa.modmanager/lib/json.lua")
    local file,err = io.open(presetFile,'rb')
    if file then
        local content = file:read("*all")
        local preset = json.parse(content)
        file:close()
        ModSettingSet("ModMan.Preset", json.stringify(preset))
    end
end)

RegisterFunction("RemovePreset", function(name)
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
    ModSettingSet("ModMan.Presets", json.stringify(presetInfo))
end)