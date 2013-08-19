--- Class representing a Button widget.
require (SB_REQUIRE_LUAGUI .. "widgets.ButtonStyle")
require (SB_REQUIRE_LUAGUI .. "widgets.Widget")
require (SB_REQUIRE_LUAGUI .. "widgets.ImageView")

Button = inheritsFrom(Widget)

--- Caption of the button.
--Default: (blank).
Button._caption = ""

--- Width of the button.
---Default: 100.
--- @see Drawable._width
Button._width = 100

--- Height of the button.
---Default: 50
--- @see Drawable._height
Button._height = 50

--- Auto size option. The button will auto size if it is true.
---Default: false
Button._autoSize = false

--- Padding from top.
---Default: 3
--- @see Drawable._paddingTop
Button._paddingTop = 3

--- Padding from bottom.
---Default: 3
--- @see Drawable._paddingBottom
Button._paddingBottom = 3

--- Padding from left.
---Default: 5
--- @see Drawable._paddingLeft
Button._paddingLeft = 5

--- Padding from right.
---Default: 5
--@see Drawable._paddingRight
Button._paddingRight = 5

--- Button status
---Default: (blank).
Button._status = ''

--- Button metatable.
local ButtonMt = {
    __index = Button
}

--- Instantiates a new Button or clones other one.
--
--@param b Button to clone
function Button:new(caption)
    local newButton = {}

    local src = b or Button

    for k, v in pairs(src) do
        if type(v) == 'table' and nil ~= v.isAn and v:isAn(Object) then
            local vClass = v:class()
            newButton[k] = vClass:new(v)
        else
            newButton[k] = src[k]
        end
    end
    setmetatable(newButton, ButtonMt)

    if caption then
        newButton:caption(caption)
    end

    newButton:style(ButtonStyle:new())
    return newButton
end

--- Gets or sets the caption.
--
--@param newCaption String for the new caption.
--@return self or the current caption.
--@name Button:caption()
Button.caption = accessorFor("_caption",
    function(value)
        return (type(value) == 'string'
            or (nil ~= value and value.isAn and value:isAn(Image)))
    end
)

--- Gets or sets auto size option.
--
--@param value true or false to either set or unset autosize.
--@return the current autosize option.
--@name Button:autoSize()
Button.autoSize = accessorFor("_autoSize")

--- Gets or sets the button status.
--
--@param status String representing the new status. It can be 'pressed',
--'foccused' and 'default'.
--@return the current button status.
--@name Button:status()
Button.status = accessorFor("_status")

Button.style = accessorFor("_style")

--- Draws the Button on the given canvas.
--
--@param lcanvas Target canvas to draw on.
function Button:draw(lcanvas)
    if not self:visible() then return end

   local st = self:style()

   local face, size, style = lcanvas:attrFont()
   local r, g, b, a = lcanvas:attrColor()

   lcanvas:attrFont(st:fontFace(), st:fontSize(), style)
   local locals = {}

   if type(self:caption()) == 'string' then
        locals.bWidth, locals.bHeight = lcanvas:measureText(self:caption())
    else
        self:caption():loadImage()
        locals.bWidth, locals.bHeight = self:caption():lcanvas():attrSize()
    end

    if self:autoSize() then
        self:width(locals.bWidth + self:marginRight() + self:marginLeft()
                        + self:paddingLeft() + self:paddingRight())
   :height(locals.bHeight  + self:marginTop() + self:marginBottom()
                          + self:paddingTop() + self:paddingBottom())
    end

    local res = ''
    if self:status() == 'pressed' then
        res = self:style():pressedImage()
    elseif self:status() == 'foccused' then
        res = self:style():foccusedImage()
    elseif self:status() == 'default' then
        res = self:style():defaultImage()
    else
        res = self:style():backgroundImage()
    end
    local iv = ImageView:new(res)

    iv:path(res)
    iv:x(self:x() + self:marginLeft() + self:marginRight())
       :y(self:y() + self:marginTop())

    iv:width(self:width() + self:paddingLeft() + self:paddingRight())
      :height(self:height() + self:paddingTop() + self:paddingBottom())

    local frameColor = self:style():frameColor()
    local bgColor = self:style():backgroundColor()

    if self:status() == 'foccused' then
        self:style():frameColor(self:style():foccusColor())
    elseif self:status() == 'pressed' then
        self:style():backgroundColor(self:style():foccusColor())
    end

    self:_drawBackground(lcanvas)

    self:style():frameColor(frameColor)
    self:style():backgroundColor(bgColor)

    local width = self:contentsRegion().width

    local height = self:contentsRegion().height

    local buttonCanvas = self:contentsCanvas()
    local dx = (width - locals.bWidth)/2
    local dy = (height - locals.bHeight)/2

    iv:draw(lcanvas)

    local fc = self:style():frameColor()
    buttonCanvas:attrColor(fc:r(), fc:g(), fc:b(), fc:a())

    if type(self:caption()) == 'string' then
        local fc = self:style():fontColor()
        buttonCanvas:attrColor(fc:r(), fc:g(), fc:b(), fc:a())
        buttonCanvas:drawText(dx, dy, self:caption())
    else
        buttonCanvas:compose(dx, dy,
                             self:caption():lcanvas())
    end

    buttonCanvas:attrFont(face, size, style)
    buttonCanvas:attrColor(r, g, b, a)
    lcanvas:compose(self:x() + self:paddingLeft() + self:marginLeft(),
                    self:y() + self:paddingTop() + self:marginTop(),
                    buttonCanvas)
end

