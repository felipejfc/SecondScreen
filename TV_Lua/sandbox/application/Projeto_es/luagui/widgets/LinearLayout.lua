--- Class modeling a Linear Layout.
require(SB_REQUIRE_LUAGUI .. "widgets.Layout")
require(SB_REQUIRE_LUAGUI .. "widgets.Orientation")

LinearLayout = inheritsFrom(Layout)

--- Orientation of the LinearLayout.
--Default: Orientation.HORIZONTAL
--@see Orientation
LinearLayout._orientation = Orientation.HORIZONTAL

--- Table containing functions to draw on Orientation.HORIZONTAL and
--Orientation.VERTICAL modes.
--@see Orientation.
LinearLayout._draw = {}

--- Linear Layout metatable.
local LinearLayoutMt = { __index = LinearLayout }

--- Instantiates a new LinearLayout.
--@param drawable Drawable object to configure the new LinearLayout.
--@return LinearLayout object.
function LinearLayout:new(drawable)
    local newLayout = {}


    local src = LinearLayout

    for k, v in pairs(src) do
        if type(v) == 'table' and nil ~= v.isAn and v:isAn(Object) then
            local vClass = v:class()
            newLayout[k] = vClass:new(v)
        else
            newLayout[k] = src[k]
        end
    end

    setmetatable(newLayout, LinearLayoutMt)

    if nil ~= drawable and drawable.isA and drawable:isA(Drawable) then
        newLayout:x(drawable:x())
            :y(drawable:y())
            :width(drawable:width())
            :height(drawable:height())
    end

    newLayout._children = {}

    return newLayout
end


-- Method to draw on the Horizontal orientation.
--@param lcanvas Target canvas to draw onto.
--@name LinearLayout._draw[Orientation.HORIZONTAL]
LinearLayout._draw[Orientation.HORIZONTAL] = function(self, lcanvas)
    local layoutCanvas = self:contentsCanvas()

    local curPos = 0

    for k, v in pairs(self:children()) do
       v._x = (curPos)
       v._y = (0)
       v:draw(layoutCanvas)
       curPos = curPos + v:width()
   end

   lcanvas:compose(self:x(), self:y(), layoutCanvas)
end

-- Method to draw on the Vertical orientation.
--@param lcanvas Target canvas to draw onto.
--@name LinearLayout._draw[Orientation.VERTICAL]
LinearLayout["_draw"][Orientation.VERTICAL] = function(self, lcanvas)
    local layoutCanvas = self:contentsCanvas()

    local curPos = 0

    local childCount = #(self:children())
    local childHeight = self:height() / childCount
    for k, v in pairs(self:children()) do
        v._x = (0)
        v._y = (curPos)
        v:draw(layoutCanvas)
        curPos = curPos + v:height()

    end

    lcanvas:compose(self:x(), self:y(), layoutCanvas)
end

--- Getter and setter fo the orientation.
--@param value Orientation to be set.
--@return Self or the current orientation.
--@name LinearLayout:orientation()
LinearLayout.orientation = accessorFor("_orientation" ,
function(value)
    return (
    value == Orientation.VERTICAL
    or value == Orientation.HORIZONTAL
    )
end
)

--- Method to draw the LinearLayout.
--@param lcanvas Canvas to draw onto.
function LinearLayout:draw(lcanvas)
    local lcanvas = lcanvas or canvas

    self._draw[self:orientation()](self, lcanvas)
end

