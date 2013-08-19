--- Abstract class, represents a window.
require(SB_REQUIRE_LUAGUI .. "widgets.Widget")

Window = Widget:new({
  _title,
  _maximized = false,
})

--- Window metatable.
local WindowMt = {
  __index = Window
}

--- Instantiates a new Window object. Can be used to clone an existing
-- window instance.
--
-- @param w nil or the window to clone.
-- @param title the string to be used as the initial title.
-- @param maximized a boolean value to either maximize or not.
-- @return the new instance of Window
function Window:new(w, title, maximized)
  local newWindow = {}
  src = w or Window

  for k, v in pairs(src) do
    newWindow[k] = src[k]
  end
  if title then
    self:title(title)
  end

  if maximized then
    self:maximized(maximized)
  end

  return setmetatable(newWindow, WindowMt)
end

--- Reads or sets the title of this Window.
--
-- @param value The new title of the window.
-- @return The current title of the window.
function Window:title(value)
  if not value then
    return self._title
  else
    self._title = value
    return self
  end
end

--- Reads or set the maximized attribute of this Window.
--
--@param maximize If true, maximizes the window, if false minimizes.
--@return True if maximized, false otherwise.
function Window:maximized(value)
  if not value then
    return self._maximized
  else
    self._maximized = value
  end
end

