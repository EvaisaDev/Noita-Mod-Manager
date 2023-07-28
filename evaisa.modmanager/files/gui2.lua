local imgui
gui = gui or GuiCreate();
local current_id = 200
local function new_id()
    current_id = current_id + 1
    return current_id
end

menuOpen = menuOpen or false


if imgui == nil then
    local loader = load_unshackle_imgui or load_imgui

    imgui = loader({version="1.0.0", mod="Evaisa.ModManager"})
end

local main_window_size = {w = 800, h = 800}
local vw, vh = imgui.GetMainViewportSize()
local vx, vy = imgui.GetMainViewportWorkPos()

gui_init = gui_init or false

if(not gui_init)then
    imgui.SetNextWindowPos((vw / 2) - (main_window_size.w / 2), (vh / 2) - (main_window_size.h / 2))
    gui_init = true
end

GuiStartFrame(gui)
GuiOptionsAdd(gui, 6)
if(allowOpen)then
    if(GuiImageButton(gui, new_id(), 1, 1, "", "mods/evaisa.modmanager/files/mods.png"))then
        menuOpen = not menuOpen
    end
end



if(menuOpen)then

    imgui.PushFont(imgui.GetNoitaFont1_4x())
    imgui.PushStyleColor(imgui.Col.Button, 1, 0.4, 0.4)
    imgui.PushStyleColor(imgui.Col.ButtonHovered, 1, 0.6, 0.6)
    imgui.PushStyleColor(imgui.Col.ButtonActive, 0.8, 0.4, 0.4)
    imgui.PushStyleColor(imgui.Col.MenuBarBg, 148 / 255, 127 / 255, 100 / 255)
    imgui.PushStyleColor(imgui.Col.HeaderHovered, 148 / 255, 127 / 255, 100 / 255)
    imgui.PushStyleColor(imgui.Col.HeaderActive, 148 / 255, 127 / 255, 100 / 255)
    
    local flags = imgui.WindowFlags.NoResize + imgui.WindowFlags.NoFocusOnAppearing
    imgui.SetNextWindowSize(main_window_size.w, main_window_size.h)
    imgui.PushStyleColor(imgui.Col.ButtonHovered, 194 / 255, 169 / 255, 136 / 255)
    imgui.PushStyleColor(imgui.Col.ButtonActive, 194 / 255, 169 / 255, 136 / 255)
    if imgui.Begin("Mod Manager", nil, flags) then
        imgui.PopStyleColor(2)
        local available_width, available_height = imgui.GetContentRegionAvail()

        if imgui.BeginChild("TopLeft", 80, 400, true, flags) then

            imgui.EndChild()
        end

        imgui.SameLine()

        if imgui.BeginChild("TopRight", available_width - 88, 400, true, imgui.WindowFlags.MenuBar + flags) then

            if imgui.BeginMenuBar() then
                imgui.Text("Mods")
                imgui.EndMenuBar()
            end

            for i=1,20 do
                imgui.Text("TopRight" .. i)
            end
            imgui.EndChild()
        end

        if imgui.BeginChild("DownLeft", 80, 0, true, flags) then

            imgui.EndChild()
        end

        imgui.SameLine()

        if imgui.BeginChild("DownRight", available_width - 88, 0, true, imgui.WindowFlags.MenuBar + flags) then
            if imgui.BeginMenuBar() then
                imgui.Text("Presets")
                imgui.EndMenuBar()
            end
            imgui.Text("DownRight")
            imgui.EndChild()
        end

        imgui.End()
    end

    imgui.PopStyleColor(6)

    imgui.PopFont()

end