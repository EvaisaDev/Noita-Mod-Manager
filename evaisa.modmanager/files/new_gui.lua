gui = gui or GuiCreate();

timesDragged = timesDragged or 0

active_preset = active_preset or nil
last_preset = last_preset or nil

local current_id = 200
local function new_id()
    current_id = current_id + 1
    return current_id
end

local function new_draggable_id()
    current_id = current_id + 1
    return current_id + 20000 + timesDragged
end

GuiStartFrame(gui)
GuiOptionsAdd(gui, 6)
if (GameGetIsGamepadConnected()) then
    GuiOptionsAdd(gui, 2)
end
if(allowOpen)then
    if(GuiImageButton(gui, new_id(), 1, 1, "", "mods/evaisa.modmanager/files/mods.png"))then
        menuOpen = not menuOpen
    end
end

PresetName = PresetName or GameTextGetTranslatedOrNot("$modmanager_default_preset_name")


if(active_preset ~= nil)then
    local preset = active_preset
    PresetName = preset.name
    local data = preset.data
    local newWidgets = {}
    for j = #widgets, 1, -1 do
        local wasFound = false
        for i = #data, 1, -1 do
            local v = data[i]
            
            local w = widgets[j]
            if(w.id == v.id and w.workshop_item_id == v.workshop_item_id)then
                wasFound = true
                widgets[j].enabled = v.enabled
                break
            end
        end
        if(not wasFound)then
            widgets[j].enabled = false;
            table.insert(newWidgets, widgets[j])
        end
    end
    for i = #data, 1, -1 do
        for j = #widgets, 1, -1 do
            local v = data[i]
            
            local w = widgets[j]
            if(w.id == v.id and w.workshop_item_id == v.workshop_item_id)then
                table.insert(newWidgets, w)
            end
        end
    end
    widgets = newWidgets

    active_preset = nil
    --ModSettingRemove("ModMan.Preset")
end

if(menuOpen)then
    local containerSize = {w = 200, h = 170}
    local containerPos = {x = 50, y = 30}

    GuiZSetForNextWidget(gui, -1930)
    GuiBeginScrollContainer(gui, 3, containerPos.x, containerPos.y, containerSize.w + 8, 10)
    GuiLayoutBeginHorizontal(gui, 0, 0)
    GuiZSetForNextWidget(gui, -1960)
    GuiText(gui, 0, 0, "$modmanager_preset_name_is")
    GuiZSetForNextWidget(gui, -1960)
    PresetName = GuiTextInput(gui, 4, 0, -0.5, PresetName, 100, 20)
    GuiLayoutEnd(gui)
    GuiEndScrollContainer(gui)
    GuiZSetForNextWidget(gui, -1930)
    GuiBeginScrollContainer(gui, 5, containerPos.x, containerPos.y + 19, containerSize.w, containerSize.h - 19)
    
    GuiLayoutBeginVertical(gui, 0, 0, true, 0, 2)
    GuiZSetForNextWidget(gui, -1931)
    GuiText(gui, 0, 0, "---------------"..GameTextGetTranslatedOrNot("$modmanager_mods").."--------------")
    local _, _, _, anchor_x, anchor_y = GuiGetPreviousWidgetInfo(gui)

    local scroll_offset_y = anchor_y - containerPos.y - 2

    local toMove = {}

    dragCount = dragCount or 0
    DraggedElements = DraggedElements or {}
    LastDragPos = LastDragPos or {x = 0, y = 0}

    closestOtherElementIndex = closestOtherElementIndex or nil
    otherElementPos = otherElementPos or nil
    ClosestElement = ClosestElement or nil
    
    -- loop through widgets backwards
    for k = #widgets, 1, -1 do
        local v = widgets[k]

        GuiOptionsAddForNextWidget(gui, 51)
        GuiOptionsAddForNextWidget(gui, 21)
        
        GuiZSetForNextWidget(gui, -2000)
        
        local button = nil
        

        if(v.workshop_item_id ~= "0")then
            button = GuiImageButton(gui, new_draggable_id(), 15, 0, "", "mods/evaisa.modmanager/files/overlayredshort.png")
        else
            button = GuiImageButton(gui, new_draggable_id(), 0, 0, "", "mods/evaisa.modmanager/files/overlayred.png")
        end


        if(button)then
            widgets[k].enabled = not v.enabled
        end

        local _, _, hovered, x, y, w, h, draw_x, draw_y = GuiGetPreviousWidgetInfo(gui)
        


        local start_y = (containerPos.y + 2 + (h * (#widgets - (k - 1))) + scroll_offset_y) - 9

        local text_width, text_height = GuiGetTextDimensions( gui, v.name)
        local steam_width, steam_height = GuiGetTextDimensions( gui, "mods/evaisa.modmanager/files/steam.png")

        if(v.workshop_item_id ~= "0")then
           

            GuiZSetForNextWidget(gui, -2100)
            GuiImage(gui, new_id(), 2, -(h / 2) - (steam_height / 2), "mods/evaisa.modmanager/files/steam.png", 1, 1, 1)
            local ws_c, ws_c2, ws_hovered, ws_x, ws_y = GuiGetPreviousWidgetInfo(gui)

            
            if(ws_c)then
                api.OpenSteamWorkshopPage(v.workshop_item_id)
            end
        end

        --[[if(DraggedElements[k])then
            if(not v.enabled)then
                GuiOptionsAddForNextWidget(gui, 21)
                GuiZSetForNextWidget(gui, -1999)
                GuiImageButton(gui, new_id(), anchor_x, draw_y, "", "mods/evaisa.modmanager/files/overlaydisabled.png")
            end

            GuiZSetForNextWidget(gui, -1960)
            if(v.workshop_item_id ~= "0")then
                GuiText(gui, anchor_x + 18, draw_y + ((h / 2) - (text_height / 2)), v.name)
            else
                GuiText(gui, anchor_x + 4, draw_y + ((h / 2) - (text_height / 2)), v.name)
            end
            GuiOptionsAddForNextWidget(gui, 21)
            GuiOptionsAddForNextWidget(gui, 6)
            GuiZSetForNextWidget(gui, -1959)
            GuiImageButton(gui, new_id(), anchor_x, draw_y, "", "mods/evaisa.modmanager/files/item.png")     

        else]]
            --[[if(not v.enabled)then
                GuiOptionsAddForNextWidget(gui, 21)
                GuiZSetForNextWidget(gui, -1941)
                GuiImageButton(gui, new_id(), 0, -h, "", "mods/evaisa.modmanager/files/overlaydisabled.png")
            end

            local offset = 0

            GuiZSetForNextWidget(gui, -1940)
            if(v.workshop_item_id ~= "0")then
                offset = 8
                GuiText(gui, 18, -((h / 2) + (text_height / 2)), v.name)
            else
                GuiText(gui, 4, -((h / 2) + (text_height / 2)), v.name)
            end

            _, _, _, text_x, text_y = GuiGetPreviousWidgetInfo(gui)]]


            local offset_y = -h - 2
            local offset_x = 2

            if(v.workshop_item_id ~= "0")then
                offset_y = -(h / 2) - (steam_height / 2)
                offset_x = steam_width
            end

            GuiZSetForNextWidget(gui, -1940)
            GuiText(gui, offset_x, offset_y + (h / 2) - (text_height / 2), v.name)

            


            GuiOptionsAddForNextWidget(gui, 21)
            GuiOptionsAddForNextWidget(gui, 6)
            GuiZSetForNextWidget(gui, -1939)
            GuiImageButton(gui, new_id(), 0, -(h - 2), "", "mods/evaisa.modmanager/files/item.png")  
            
            -- -(steam_width / 2) - 2
        --end

        --[[
        if(DraggedElements[k])then
            
            GuiLayoutBeginLayer( gui )

            if(not v.enabled)then
                GuiOptionsAddForNextWidget(gui, 21)
                GuiZSetForNextWidget(gui, -1999)
                GuiImageButton(gui, new_id(), anchor_x, draw_y, "", "mods/evaisa.modmanager/files/overlaydisabled.png")
            end

            GuiZSetForNextWidget(gui, -1960)
            if(v.workshop_item_id ~= "0")then
                GuiText(gui, anchor_x + 18, draw_y + ((h / 2) - (text_height / 2)), v.name)
            else
                GuiText(gui, anchor_x + 4, draw_y + ((h / 2) - (text_height / 2)), v.name)
            end
            GuiOptionsAddForNextWidget(gui, 21)
            GuiOptionsAddForNextWidget(gui, 6)
            GuiZSetForNextWidget(gui, -1959)
            GuiImageButton(gui, new_id(), anchor_x, draw_y, "", "mods/evaisa.modmanager/files/item.png")     

            GuiLayoutEndLayer( gui )
        else
            if(not v.enabled)then
                GuiOptionsAddForNextWidget(gui, 21)
                GuiZSetForNextWidget(gui, -1941)
                GuiImageButton(gui, new_id(), 0, -h, "", "mods/evaisa.modmanager/files/overlaydisabled.png")
            end
            
            local offset = 0

            GuiZSetForNextWidget(gui, -1940)
            if(v.workshop_item_id ~= "0")then
                offset = 8
                GuiText(gui, 18, -((h / 2) + (text_height / 2)), v.name)
            else
                GuiText(gui, 4, -((h / 2) + (text_height / 2)), v.name)
            end

            _, _, _, text_x, text_y = GuiGetPreviousWidgetInfo(gui)

            GuiOptionsAddForNextWidget(gui, 21)
            GuiOptionsAddForNextWidget(gui, 6)
            GuiZSetForNextWidget(gui, 1)
            GuiZSetForNextWidget(gui, -1939)
            GuiImageButton(gui, new_id(), 0, -((text_height/2) + (h / 2)), "", "mods/evaisa.modmanager/files/item.png")  
            
            if(hovered)then
                GuiLayoutBeginLayer( gui )
                GuiBeginAutoBox(gui)
                GuiLayoutBeginVertical(gui, 0, 0, true)
                
                GuiZSetForNextWidget(gui, -2002)
                GuiText(gui, containerPos.x + offset + w / 2, start_y + (text_height / 2), v.name .. " - " .. v.id)

                -- split v.description by \n and by ". "
                local description = v.description
                description = description:gsub("\\([nt])", {n="\n", t="\t"})
                local index = 0
                for s in description:gmatch("[^\n]+") do
                    
                    if(s ~= "")then
                        GuiZSetForNextWidget(gui, -2002)
                        GuiText(gui, containerPos.x + offset + w / 2, 0, s)

                        index = index + 1
                    end
                    
                end
                

                
                

                GuiLayoutEnd(gui)
                GuiZSetForNextWidget(gui, -2001)
                GuiEndAutoBoxNinePiece(gui)
                GuiLayoutEndLayer( gui )
            end
            
        end
        ]]


        if(math.floor(start_y) ~= math.floor(y) and math.floor(y) ~= 0 and last_scroll_offset ~= nil) then

            if(math.abs(scroll_offset_y - last_scroll_offset) == 0)then
                    
                

                if(DraggedElements[k] == false)then
                    dragCount = dragCount + 1
                end

                DraggedElements[k] = true

                LastDragPos = {x = x, y = y}

                local closestOtherElementDistance = 10000
                for i = 1, #widgets do
                    if(i ~= k) then
                        local otherWidgetY = (containerPos.y + 2 + (h * (#widgets - (i - 1))) + scroll_offset_y) - 9
                        local distance = math.abs(otherWidgetY - LastDragPos.y)
                        if(distance < closestOtherElementDistance) then
                            closestOtherElementDistance = distance
                            closestOtherElementIndex = i
                            otherElementPos = otherWidgetY
                            ClosestElement = widgets[i]
                        end
                    end
                end
            end
        else
            if(dragCount > 1)then
                DraggedElements = {}
                toMove = {}
                dragCount = 0
            end
            if(DraggedElements[k]) then
                DraggedElements[k] = nil
                dragCount = 0
                timesDragged = timesDragged + 1
                if(otherElementPos ~= nil)then
                    --GamePrint("Closest element: "..ClosestElement.text)
                    
                    toMove[k] = closestOtherElementIndex
                end
            end
        end
    end
    local count = 0
    for k, v in pairs(toMove) do
        count = count + 1
    end

    if(count == 1)then
        for k, v in pairs(toMove) do
            local element = widgets[k]
            if(v > k) then
                table.remove(widgets, k)
                table.insert(widgets, v, element)
            else
                table.remove(widgets, k)
                table.insert(widgets, v + 1, element)
            end
        end
    end

    GuiLayoutEnd(gui)

    GuiEndScrollContainer(gui)

    last_scroll_offset = scroll_offset_y
    GuiZSetForNextWidget(gui, -1930)
    GuiZSet(gui, -1940)
    GuiBeginScrollContainer(gui, 6, containerPos.x - 29, containerPos.y, 20, (containerSize.h + 9 + (containerSize.h - 50)) - 129)
    GuiLayoutBeginVertical(gui, 0, 0, true)


    local reload = GuiImageButton(gui, new_id(), 0, 0, "", "mods/evaisa.modmanager/files/reload.png")
    GuiTooltip(gui, "$modmanager_refresh_mods", "")
    local sortAZ = GuiImageButton(gui, new_id(), 0, 0, "", "mods/evaisa.modmanager/files/sortAZ.png")
    GuiTooltip(gui, "$modmanager_sort_a_to_z", "")
    local sortZA = GuiImageButton(gui, new_id(), 0, 0, "", "mods/evaisa.modmanager/files/sortZA.png")
    GuiTooltip(gui, "$modmanager_sort_z_to_a", "")
    local apply = GuiImageButton(gui, new_id(), 0, 0, "", "mods/evaisa.modmanager/files/check.png")
    GuiTooltip(gui, "$modmanager_apply_mod_order", "")
    GuiLayoutEnd(gui)
    GuiEndScrollContainer(gui)
    if(apply)then
        api.SaveModData(widgets)
        if(last_preset ~= nil and last_preset.settings ~= nil)then
            api.ApplySettings(last_preset.settings)
        end
    end
    if(reload)then
        RefreshMods()
    end
    if(sortAZ)then
        table.sort(widgets, function(a, b)
            return a.name > b.name
        end)
    end
    if(sortZA)then
        table.sort(widgets, function(a, b)
            return a.name < b.name
        end)
    end

    GuiZSetForNextWidget(gui, -1930)
    GuiBeginScrollContainer(gui, 7, containerPos.x - 29, (containerSize.h - 9 + (containerSize.h - 50)) - 72, 20, 120)
    GuiLayoutBeginVertical(gui, 0, 0, true)
    local save = GuiImageButton(gui, new_id(), 0, 0, "", "mods/evaisa.modmanager/files/save.png")
    GuiTooltip(gui, "$modmanager_save_preset", "")
    local save_with_settings = GuiImageButton(gui, new_id(), 0, 0, "", "mods/evaisa.modmanager/files/savesettings.png")
    GuiTooltip(gui, "$modmanager_save_preset_with_mod_settings", "")
    local codesave = GuiImageButton(gui, new_id(), 0, 0, "", "mods/evaisa.modmanager/files/copy.png")
    GuiTooltip(gui, "$modmanager_copy_preset_code", "$modmanager_copy_preset_code_note")
    --[[local codesave_with_settings = GuiImageButton(gui, new_id(), 0, 0, "", "mods/evaisa.modmanager/files/copysettings.png")
    GuiTooltip(gui, "$modmanager_copy_preset_code_with_mod_settings", "")]]
    local paste = GuiImageButton(gui, new_id(), 0, 0, "", "mods/evaisa.modmanager/files/paste.png")
    GuiTooltip(gui, "$modmanager_load_preset_code", "")
    local reload = GuiImageButton(gui, new_id(), 0, 0, "", "mods/evaisa.modmanager/files/reloadpresets.png")
    GuiTooltip(gui, "$modmanager_refresh_presets", "")
    local open_folder = GuiImageButton(gui, new_id(), 0, 0, "", "mods/evaisa.modmanager/files/folder.png")
    GuiTooltip(gui, "$modmanager_open_preset_folder", "")
    GuiLayoutEnd(gui)
    GuiEndScrollContainer(gui)

    local force_refresh = false

    if(save)then
        local name = PresetName
        if(name ~= "")then
            api.SavePreset(name, widgets)
            force_refresh = true
        end
    end

    if(save_with_settings)then
        local name = PresetName
        if(name ~= "")then
            api.SavePresetWithSettings(name, widgets)
            force_refresh = true
        end
    end

    if(codesave)then
        local name = PresetName
        if(name ~= "")then
            api.SaveToCode(name, widgets)
        end
    end

    --[[
    if(codesave_with_settings)then
        local name = PresetName
        if(name ~= "")then
            api.SaveToCodeWithSettings(name, widgets)
        end
    end
    ]]

    if(paste)then
        api.LoadFromClipboard(widgets)
    end

    if(reload)then
        RefreshPresets()
    end

    if(open_folder)then
        api.OpenPresetsFolder()
    end

    GuiZSetForNextWidget(gui, -1930)
    GuiBeginScrollContainer(gui, 8, containerPos.x, containerPos.y + containerSize.h + 9, containerSize.w, containerSize.h - 50)
    GuiLayoutBeginVertical(gui, 0, 0, true)
    GuiZSetForNextWidget(gui, -1931)
    GuiText(gui, 0, 0, "---------------"..GameTextGetTranslatedOrNot("$modmanager_presets").."--------------")
    for k, v in ipairs(presets)do
        GuiLayoutBeginHorizontal(gui, 0, 0, true)
        if(GuiButton(gui, new_id(), 0, 0, "$modmanager_preset_remove"))then
            api.RemovePreset(v)
            force_refresh = true
        end
        if(GuiButton(gui, new_id(), 0, 0, " "..v))then
            active_preset = api.LoadPreset(v)
            last_preset = active_preset
        end
        GuiLayoutEnd(gui)
    end
    for i = 1, math.max(0, 20 - #presets) do
        GuiText(gui, 0, 0, " ")
    end
    if(force_refresh)then
        RefreshPresets()
    end
    GuiLayoutEnd(gui)
    GuiEndScrollContainer(gui)

end