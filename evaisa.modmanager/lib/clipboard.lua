local ffi = require("ffi")

ffi.cdef([[

int SDL_SetClipboardText(const char *text);
char * SDL_GetClipboardText();
void SDL_free(void *mem);
]])

local sdl = ffi.load("SDL2.dll")


function get_clipboard()
    local text_ptr = sdl.SDL_GetClipboardText()
    local text = ffi.string(text_ptr)
    sdl.SDL_free(text_ptr)
    return text
end

function set_clipboard(text)
    sdl.SDL_SetClipboardText(text)
end

return {
    get = get_clipboard,
    set = set_clipboard,
}