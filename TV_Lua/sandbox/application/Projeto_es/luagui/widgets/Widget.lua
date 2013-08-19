--- Abstract class, represents a widget.
require(SB_REQUIRE_LUAGUI .. "widgets.Style")
require(SB_REQUIRE_LUAGUI .. "widgets.Drawable")

Widget = inheritsFrom(Drawable)

--- Width of the widget.
---Default: 640
---@see Drawable._width
Widget._width = 640

--- Height of the widget.
---Default: 480
---@see Drawable._height
Widget._height = 480

--- Foccusable attribute. This determines if the widget can be foccused.
---Default: true
Widget._foccusable = true

--- Foccused attribute. This tells you if your widget is foccused or not.
---Default: false
Widget._foccused = false

--- Layout of the widget.
---Default: false
Widget._layout = nil

--- Widget metatable.
local WidgetMt = {
    __index = Widget,
}

--- Instantiates a new Widget object. Can be used to clone an existing Widget
-- instance.
--
-- @param nil or the widget to clone.
-- @return the new instance of Widget.
function Widget:new(w)
    local newWidget = {}

    local src = Widget or w

    for k, v in pairs(src) do
        if type(v) == 'table' and nil ~= v.isAn and v:isAn(Object) then
            local vClass = v:class()
            newWidget[k] = vClass:new(v)
        else
            newWidget[k] = src[k]
        end
    end

    return setmetatable(newWidget, WidgetMt)
end

--- Reads or sets the foccusable property of this Widget.
-- @name Widget:foccusable()
-- @param value The new value of foccusable.
-- @return The current value of foccusable if value == nil, or self otherwise.
Widget.foccusable = accessorFor("_foccusable")

--- Reads or sets the foccused attribute of this Widget.
--@name Widget:foccused()
--@param value true or false either to foccus or not.
--@return The current value of foccused or self.
Widget.foccused = accessorFor("_foccused")

--- Gets or sets the Widget layout.
--@name Widget:layout()
--@param value The new layout to be used.
--@return The current layout or self.
Widget.layout = accessorFor("_layout")

