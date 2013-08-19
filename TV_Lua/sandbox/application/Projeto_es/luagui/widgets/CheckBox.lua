--- A checkable box with a label ;)

require(SB_REQUIRE_LUAGUI .. "widgets.Button")

CheckBox = inheritsFrom(Button)

CheckBox["_checked"] = false
CheckBox["_caption"] = "CheckBox"
CheckBox["_paddingTop"] = 3
CheckBox["_paddingBottom"] = 3
CheckBox["_paddingLeft"] = 5
CheckBox["_paddingRight"] = 5
CheckBox["_style"] = Style:new():backgroundColor(Color:new(0, 0, 0, 0))

--- CheckBox metatable
local CheckBoxMt = {
    __index = CheckBox
}

--- Instantiates a new CheckBox object
--
-- @param c CheckBox to be cloned
function CheckBox:new(c)
    newcheckbox = {}

    local src = c or CheckBox

    for k,v in pairs(src) do
        if type(v) == 'table' and nil ~= v.isAn and v:isAn(Object) then
            local vClass = v:class()
            newcheckbox[k] = vClass:new(v)
        else
            newcheckbox[k] = src[k]
        end
    end

    return setmetatable(newcheckbox, CheckBoxMt)
end

--- Reads the <code>boxSize</code> of this <code>CheckBox</code>
--
-- @name CheckBox:boxSize()
-- @param value The new value of <code>boxSize</code>
-- @return The value of <code>boxSize</code> for the current fontSize()
function CheckBox:boxSize()
    return 3 * self:style():fontSize() / 5
end

--- Reads or sets the <code>checked</code> coordinate of this
-- <code>CheckBox</code>
--
-- @name CheckBox:checked()
-- @param value The new value of <code>checked</code>
-- @return The current value of <code>checked</code> if <code>value ==
-- nil</code>, or self otherwise
function CheckBox:checked(value)
    if value then
        self._checked = value
        return self
    else
        return self._checked
    end
end

--- Method to draw the CheckBox on the given canvas
--
--@param lcanvas Target canvas to draw on
function CheckBox:draw(lcanvas)
    if not self:visible() then return end

    local face, size, style = lcanvas:attrFont()
    local r, g, b, a = lcanvas:attrColor()

    local st = self:style()
    local fc = self:style():fontColor()

    local d = self:boxSize() / 3

    lcanvas:attrColor(fc:r(), fc:g(), fc:b(), fc:a())
    lcanvas:attrFont(st:fontFace(), st:fontSize(), style)

    local bWidth, bHeight = lcanvas:measureText(self:caption())
    bWidth = bWidth + d + self:boxSize()

    self:height(bHeight + self:marginBottom() + self:marginTop()
                        + self:paddingBottom() + self:paddingTop())

    self:width(bWidth + self:marginLeft() + self:marginRight()
                      + self:paddingLeft() + self:paddingRight())

    local foccusColor = self:style():foccusColor()
    local frameColor = self:style():frameColor()
    if self:foccused() then
        self:style():frameColor(foccusColor)
    end

    self:_drawBackground(lcanvas)
    self:style():frameColor(frameColor)

    local width = self:width() - self:marginLeft() - self:marginRight()
        - self:paddingLeft() - self:paddingRight()


    local height = self:height() - self:marginTop() - self:marginBottom()
        - self:paddingTop() - self:paddingBottom()

    local rectX = 0
    local rectY = math.ceil(height - self:boxSize())/2


    local textY = 3 * (height - bHeight) / 4
    local textX = d + self:boxSize()

    local checkBoxCanvas = self:contentsCanvas()

    checkBoxCanvas:attrColor(fc:r(), fc:g(), fc:b(), fc:a())
    checkBoxCanvas:attrFont(st:fontFace(), st:fontSize(), style)
    checkBoxCanvas:drawText(textX, textY, self:caption())




    checkBoxCanvas:drawRect(
        'frame',
        rectX,
        rectY,
        self:boxSize(),
        self:boxSize()
        )


    if self:status() == 'pressed' then
        checkBoxCanvas:attrColor(foccusColor:r(), foccusColor:g(),
                                 foccusColor:b(), foccusColor:a())


    elseif self:checked() then
        checkBoxCanvas:attrColor(0, 150, 0, 255)
    else
        checkBoxCanvas:attrColor(0, 0, 0, 0)
    end

    local padding = (self:boxSize() / 4)
    local checkSize = self:boxSize() / 2

    if st:fontSize() <= 25 then
        padding = 1
        checkSize = self:boxSize() - 2
    end

    checkBoxCanvas:drawRect(
                   'fill',
                   rectX + padding,
                   rectY + padding,
                   checkSize,
                   checkSize
                   )

    lcanvas:compose(self:x() + self:paddingLeft() + self:marginLeft(),
                    self:y() + self:paddingTop() + self:marginTop(),
                    checkBoxCanvas)
end

