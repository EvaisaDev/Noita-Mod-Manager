gui = gui or GuiCreate();

GuiStartFrame(gui)
GuiOptionsAdd(gui, 6)
if (GameGetIsGamepadConnected()) then
    GuiOptionsAdd(gui, 2)
end
if(allowOpen)then
    if(GuiImageButton(gui, 2, 1, 1, "", "mods/evaisa.modmanager/files/mods.png"))then
        menuOpen = not menuOpen
    end
end

if(menuOpen)then
    local containerSize = {w = 210, h = 120}
    local containerPos = {x = 20, y = 10}

    GuiZSetForNextWidget(gui, -1930)
    GuiBeginScrollContainer(gui, 5, containerPos.x, containerPos.y + 19, containerSize.w, containerSize.h - 19)
    GuiLayoutBeginVertical(gui, 0, 0, true)
    GuiZSetForNextWidget(gui, -1931)
    GuiText(gui, 0, 0, "$modmanager_shackled_gui_line1")
    GuiZSetForNextWidget(gui, -1931)
    GuiText(gui, 0, 0, "$modmanager_shackled_gui_line2")
    GuiZSetForNextWidget(gui, -1931)
    GuiText(gui, 0, 0, "$modmanager_shackled_gui_line3")

    GuiLayoutEnd(gui)
    GuiEndScrollContainer(gui)
 
end