gui = gui or GuiCreate();

GuiStartFrame(gui)
GuiOptionsAdd(gui, 6)
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
    GuiText(gui, 0, 0, "Please install Unshackle.")
    GuiZSetForNextWidget(gui, -1931)
    GuiText(gui, 0, 0, "There is a link to the mod in the workshop description.")
    GuiZSetForNextWidget(gui, -1931)
    GuiText(gui, 0, 0, "This mod manager will not function without it.")

    GuiLayoutEnd(gui)
    GuiEndScrollContainer(gui)
 
end