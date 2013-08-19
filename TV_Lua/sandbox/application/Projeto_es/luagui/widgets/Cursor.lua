--A cursor with a position (line, column)

require(SB_REQUIRE_LUAGUI .. "widgets.Object")

Cursor = inheritsFrom(Object)

Cursor["_line"] = 0
Cursor["_column"] = 0
Cursor["_visible"] = true

local CursorMt = { __index = Cursor }

local function isANumber(value) return type(value) == 'number' end

--- Instantiates a new cursor with the given initial position.
--@param line The line (default = 0)
--@param column The column (default = 0)
--@return The new cursor.
function Cursor:new(line, column)
    local newCursor = {}

    setmetatable(newCursor, CursorMt)

    newCursor:line(line or Cursor.line)
    newCursor:column(column or Cursor.column)

    return newCursor
end

--- Reads or sets the <code>column</code> of this
-- <code>Cursor</code>
--
-- @name Cursor:column()
-- @param value The new value of <code>column</code>
-- @return The current value of <code>column</code> if <code>value ==
-- nil</code>, or self otherwise
Cursor.column = accessorFor("_column", isANumber)

--- Reads or sets the <code>line</code> of this
-- <code>Cursor</code>
--
-- @name Cursor:line()
-- @param value The new value of <code>line</code>
-- @return The current value of <code>line</code> if <code>value ==
-- nil</code>, or self otherwise
Cursor.line = accessorFor("_line", isANumber)

--- Reads or sets the <code>visible</code> of this
-- <code>Cursor</code>
--
-- @name Cursor:visible()
-- @param value The new value of <code>visible</code>
-- @return The current value of <code>visible</code> if <code>value ==
-- nil</code>, or self otherwise
Cursor.visible = accessorFor(
    "_visible",
    function(value) return type(value) == 'boolean' end
    )

