--- Abstract class <code>Drawable</code>
--
--@class Drawable
--@name Drawable

require(SB_REQUIRE_LUAGUI .. "widgets.Object")
require(SB_REQUIRE_LUAGUI .. "widgets.Style")
require(SB_REQUIRE_LUAGUI .. "widgets.LString")

Drawable = inheritsFrom(Object)

Drawable._x = 0
Drawable._y = 0
Drawable._width = 100
Drawable._height = 100
Drawable._style = Style:new()
Drawable._marginBottom = 0
Drawable._marginLeft = 0
Drawable._marginRight = 0
Drawable._marginTop = 0
Drawable._paddingBottom = 0
Drawable._paddingLeft = 0
Drawable._paddingRight = 0
Drawable._paddingTop = 0
Drawable._visible = true
Drawable._contentsCanvas = nil

--- Tests if a given object is a number
--
-- @param value The object to test
-- @return true, if the given object is a number, or false
local function isANumber(value) return type(value) == 'number' end

-- Tests if a given number is non-negative
--
-- @param value The number to test
-- @return true, if value is a number and is non-negative, or false
local function isANonNegativeNumber(value)
    return (isANumber(value)) and (value > 0)
end

--- Sets the drawing color of the given canvas
--
-- @param lcanvas The canvas for which the drawing color should be set
-- @param color The drawing color to set
-- @return nil
local function setDrawingColor(lcanvas, color)
  lcanvas:attrColor(color:r(), color:g(), color:b(), color:a())
end

--- Reads or sets the <code>x</code> coordinate of this <code>Drawable</code>
--
-- @name Drawable:x()
-- @param value The new value of <code>x</code>
-- @return The current value of <code>x</code> if <code>value == nil</code>,
-- or <code>self</code> otherwise
Drawable.x = accessorFor("_x", isANumber)

--- Reads or sets the <code>y</code> coordinate of this <code>Drawable</code>
--
-- @name Drawable:y()
-- @param value The new value of y
-- @return The current value of y if <code>value == nil</code>,
-- or <code>self</code> otherwise
Drawable.y = accessorFor("_y", isANumber)

--- Reads or sets the width of this Drawable
--
-- @name Drawable:width()
-- @param value The new value of width
-- @return The current value of width if <code>value == nil</code>,
-- or <code>self</code> otherwise
function Drawable:width(value)
    if not value then return self._width end
    if value == self._width then return self end

    assert(isANonNegativeNumber(value))
    self._width = value

    local forceNew = true
    self:contentsCanvas(forceNew)
    return self
end

--- Reads or sets the height of this Drawable
--
-- @name Drawable:height()
-- @param value The new value of height
-- @return The current value of height if <code>value == nil</code>,
-- or <code>self</code> otherwise
function Drawable:height(value)
    if not value then return self._height end
    if value == self._height then return self end

    assert(isANonNegativeNumber(value))
    self._height = value

    local forceNew = true
    self:contentsCanvas(forceNew)
    return self
end

--- Reads or sets the bottom margin of this Drawable
--
-- @name Drawable:marginBottom()
-- @param value The new value of marginBottom
-- @return The current value of marginBottom if <code>value == nil</code>,
-- or <code>self</code> otherwise
function Drawable:marginBottom(value)
    if not value then return self._marginBottom end
    if value == self._marginBottom then return self end

    assert(isANonNegativeNumber(value))
    self._marginBottom = value

    local forceNew = true
    self:contentsCanvas(forceNew)
    return self
end

--- Reads or sets the left margin of this Drawable
--
-- @name Drawable:marginLeft()
-- @param value The new value of marginLeft
-- @return The current value of marginLeft if <code>value == nil</code>,
-- or <code>self</code> otherwise
function Drawable:marginLeft(value)
    if not value then return self._marginLeft end
    if value == self._marginLeft then return self end

    assert(isANonNegativeNumber(value))
    self._marginLeft = value

    local forceNew = true
    self:contentsCanvas(forceNew)
    return self
end

--- Reads or sets the right margin of this Drawable
--
-- @name Drawable:marginRight()
-- @param value The new value of marginRight
-- @return The current value of marginRight if <code>value == nil</code>,
-- or <code>self</code> otherwise
function Drawable:marginRight(value)
    if not value then return self._marginRight end
    if value == self._marginRight then return self end

    assert(isANonNegativeNumber(value))
    self._marginRight = value

    local forceNew = true
    self:contentsCanvas(forceNew)
    return self
end

--- Reads or sets the top margin of this Drawable
--
-- @name Drawable:marginTop()
-- @param value The new value of marginTop
-- @return The current value of marginTop if <code>value == nil</code>,
-- or <code>self</code> otherwise
function Drawable:marginTop(value)
    if not value then return self._marginTop end
    if value == self._marginTop then return self end

    assert(isANonNegativeNumber(value))
    self._marginTop = value

    local forceNew = true
    self:contentsCanvas(forceNew)
    return self
end

--- Reads or sets the bottom padding of this Drawable
--
-- @name Drawable:paddingBottom()
-- @param value The new value of paddingBottom
-- @return The current value of paddingBottom if <code>value == nil</code>,
-- or <code>self</code> otherwise
function Drawable:paddingBottom(value)
    if not value then return self._paddingBottom end
    if value == self._paddingBottom then return self end

    assert(isANonNegativeNumber(value))
    self._paddingBottom = value

    local forceNew = true
    self:contentsCanvas(forceNew)
    return self
end

--- Reads or sets the left padding of this Drawable
--
-- @name Drawable:paddingLeft()
-- @param value The new value of paddingLeft
-- @return The current value of paddingLeft if <code>value == nil</code>,
-- or <code>self</code> otherwise
function Drawable:paddingLeft(value)
    if not value then return self._paddingLeft end
    if value == self._paddingLeft then return self end

    assert(isANonNegativeNumber(value))
    self._paddingLeft = value

    local forceNew = true
    self:contentsCanvas(forceNew)
    return self
end

--- Reads or sets the right padding of this Drawable
--
-- @name Drawable:paddingRight()
-- @param value The new value of paddingRight
-- @return The current value of paddingRight if <code>value == nil</code>,
-- or <code>self</code> otherwise
function Drawable:paddingRight(value)
    if not value then return self._paddingRight end
    if value == self._paddingRight then return self end

    assert(isANonNegativeNumber(value))
    self._paddingRight = value

    local forceNew = true
    self:contentsCanvas(forceNew)
    return self
end

--- Reads or sets the top padding of this Drawable
--
-- @name Drawable:paddingTop()
-- @param value The new value of paddingTop
-- @return The current value of paddingTop if <code>value == nil</code>,
-- or <code>self</code> otherwise
function Drawable:paddingTop(value)
    if not value then return self._paddingTop end
    if value == self._paddingTop then return self end

    assert(isANonNegativeNumber(value))
    self._paddingTop = value

    local forceNew = true
    self:contentsCanvas(forceNew)
    return self
end

--- Reads or sets the visibility of this Drawable
--
-- @name Drawable:visible()
-- @param value The new value of visible
-- @return The current value of visible if <code>value == nil</code>,
-- or <code>self</code> otherwise
Drawable.visible = accessorFor(
    "_visible",
    function(value) return type(value) == 'boolean' end
    )

--- Reads or sets the style of this Drawable
--
-- @name Drawable:style()
-- @param value The new value of style
-- @return The current value of style if <code>value == nil</code>,
-- or <code>self</code> otherwise
Drawable.style = accessorFor(
    "_style",
    function(s) return (nil ~= s) and (s.isA) and (s:isA(Style)) end
    )

--- Abstract method, must be overridden
--
--@param lcanvas The target canvas to draw the <code>Drawable</code> into
--@return nil
function Drawable:draw(lcanvas)
    assert(false, 'Drawable.draw() is abstract')
end

--- Draws the background of the drawable in the given canvas. You shouldn't
-- use this unless you're creating a new widget or layout, dude
--
-- @param lcanvas The target canvas to draw the background into
-- @return nil
function Drawable:_drawBackground(lcanvas)
    local cSettings = {}

    cSettings.r, cSettings.g, cSettings.b, cSettings.a = lcanvas:attrColor()

    local bg = {}
    bg.width = self:width() - self:marginLeft() - self:marginRight()
    bg.height = self:height() - self:marginTop() - self:marginBottom()
    bg.x = self:x() + self:marginLeft()
    bg.y = self:y() + self:marginTop()

    local bgImage = self:style():backgroundImage()
    if type(bgImage)=='userdata' then
        local w, h = bgImage:attrSize()
        bgImage:attrCrop(0, 0, bg.width, bg.height)
        lcanvas:compose(bg.x, bg.y, self:style():backgroundImage())
        return
    elseif type(bgImage)=='string'  and  bgImage  ~= '' then
    	local w, h = bgImage:attrSize()
	    bgImage:attrCrop(0, 0, bg.width, bg.height)
        lcanvas:compose(bg.x, bg.y, lcanvas:new(self:style():backgroundImage()))
        return
    end
    setDrawingColor(lcanvas, self:style():backgroundColor())

    lcanvas:drawRect( 'fill', bg.x, bg.y, bg.width, bg.height)

    setDrawingColor(lcanvas, self:style():frameColor())

    lcanvas:drawRect('frame', bg.x, bg.y, bg.width, bg.height)

    lcanvas:attrColor(cSettings.r, cSettings.g, cSettings.b, cSettings.a)
end

--- Returns the region inside which the contents of the Drawable will be drawn.
-- @return A table determining the area of the contents, with the fields
-- <code>x</code>,
-- <code>y</code>,
-- <code>width</code> and
-- <code>height</code>.
--
function Drawable:contentsRegion()
    local contents = {}

    contents.width = self:width() - self:paddingLeft()
        - self:paddingRight() - self:marginLeft() - self:marginRight()

    contents.height = self:height() - self:paddingTop()
        - self:paddingBottom() - self:marginTop() - self:marginBottom()

    contents.x = self:x() + self:paddingLeft() + self:marginLeft()
    contents.y = self:y() + self:paddingTop() + self:marginTop()

    return contents
end

--- Returns a canvas with the size of the contentsRegion()
--
-- @param forceNew Instantiate a new canvas, instead of returning the canvas of
--        the Drawable.
function Drawable:contentsCanvas(forceNew)
    if self._contentsCanvas == nil or forceNew then
        local region = self:contentsRegion()
        self._contentsCanvas = canvas:new(region.width, region.height)
    end

    setDrawingColor(self._contentsCanvas, Color:new(0, 0, 0, 0))
    self._contentsCanvas:clear()

    return self._contentsCanvas

end

