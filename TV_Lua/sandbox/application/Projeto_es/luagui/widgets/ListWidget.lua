--- Class representing a List Widget.
require(SB_REQUIRE_LUAGUI .. "widgets.Style")
require(SB_REQUIRE_LUAGUI .. "widgets.Widget")

ListWidget = inheritsFrom(Widget)

--- Items held of the ListWidget
--Default: empty
ListWidget._items = {}

--- Holds the current selected index.
--Default: 0
ListWidget._selectedIndex = 0

--- Padding from left.
--Default: 2
--@see Drawable._paddingLeft
ListWidget._paddingLeft = 2

--- Padding from right.
--Default: 2
--@see Drawable._paddingRight
ListWidget._paddingRight = 2

--- Padding from top.
--Default: 2
--@see Drawable._paddingTop
ListWidget._paddingTop = 2

--- Padding from Bottom.
--Default: 2
--@see Drawable._paddingBottom
ListWidget._paddingBottom = 2

--- ListWidget metatable.
local ListWidgetMt = { __index = ListWidget }

--- Instantiates a new ListWidget.
--@param x The x initial position of the ListWidget.
--@param y The y initial position of the ListWidget.
--@param width The width of the ListWidget.
--@param height The height of the ListWidget.
--@return self
function ListWidget:new(x, y, width, height)
    newWidget = {}

    src = ListWidget

    for k, v in pairs(src) do
        if type(v) == 'table' and nil ~= v.isAn and v:isAn(Object) then
            local vClass = v:class()
            newWidget[k] = vClass:new(v)
        else
            newWidget[k] = src[k]
        end

    end

    newWidget._items = {}

    return setmetatable(newWidget, ListWidgetMt)
end

--- Gets the number of items on the ListWidget.
--
--@return The number of items held on the ListWidget.
function ListWidget:numberOfItems()
    return #self._items
end

--- Gets or sets the selected index.
--
--@param index The new index to be used.
--@param Current index selected.
function ListWidget:selectedIndex(index)
    self._selectedIndex = index or self._selectedIndex
    return self._selectedIndex
end

--- Gets the ListWidget items.
--@return Items of ListWidget.
function  ListWidget:items()
    return self._items
end

--- Adds an item to the ListWidget.
--
--@param item Item to be added.
function ListWidget:add(item)
    self._items[#self._items + 1] = item
end

--- Gets the item at a given position.
--@return The item held on the given position.
function ListWidget:itemAt(i)
    return self._items[i]
end

--- Gets the average item height.
--@return Average of item height.
function ListWidget:itemHeight()
    local face, size, style = canvas:attrFont()
    canvas:attrFont(face, self:style():fontSize(), style)
    local textwidth, textheight = canvas:measureText('ÂÇ')
    canvas:attrFont(face, size, style)
    return self:itemPadding() + self:itemPadding() + textheight
end

--- Gets the item padding.
--@return 5
function ListWidget:itemPadding() return 5 end

--- Sets the drawning colors.
--
--@param lcanvas Target canvas to be setup.
--@param color Color to be set.
local function setDrawingColor(lcanvas, color)
    lcanvas:attrColor(color:r(), color:g(), color:b(), color:a())
end

--- Draws the ListWidget on the given canvas.
--
--@param lcanvas Target canvas to draw onto.
function ListWidget:draw(lcanvas)
    if not self:visible() then return end

    lcanvas = lcanvas or canvas --> remove this bloody nasty thing

    self:_drawBackground(lcanvas)

    -- calculate item area rect --

    local x = 0
    local y = 0

    local width = self:width() - self:marginRight() - self:marginLeft()
        - self:paddingLeft() - self:paddingRight()

    local height = self:height() - self:marginBottom() - self:marginTop()
        - self:paddingTop() - self:paddingBottom()

    local lWCanvas = canvas:new(width, height)

    local itemWidth = width
    local itemHeight = self:itemHeight()
    local itemPaddingTop = self:itemPadding() -- TODO: use the padding top of the
    local itemPaddingLeft = self:itemPadding()

    -- define font style
    local face, size, style = lcanvas:attrFont()
    lWCanvas:attrFont(face, self:style():fontSize(), style)


    -- draw items --
    local current = 1
    for k, v in pairs(self:items()) do

        local itemY = y + (current - 1) * itemHeight

        -- draw text shadow
        setDrawingColor(lWCanvas, self:style():shadowColor())

        lWCanvas:drawText(
            x + itemPaddingLeft + 1,
            itemY + itemPaddingTop,
            v.text
            )

        -- draw text
        setDrawingColor(lWCanvas, self:style():fontColor())

        lWCanvas:drawText(
            x + itemPaddingLeft,
            itemY + itemPaddingTop,
            v.text
            )
            current = current + 1

        -- draw separator

        --TODO: draw separator with the frameColor of the ListWidgetItem
        setDrawingColor(lWCanvas, Color:new(0, 0, 0, 255))

        lWCanvas:drawLine(
        x,
        itemY + itemHeight,
        width,
        itemY + itemHeight
        )
    end

    -- draw frame --

    lcanvas:compose(
        self:x() + self:marginLeft() + self:paddingLeft(),
        self:y() + self:marginTop() + self:paddingTop(),
        lWCanvas
        )

    --DEBUG
    --setDrawingColor(lcanvas, Color:new(255, 0, 255, 255))
    --lcanvas:drawRect('frame', self:x(), self:y(), self:width(), self:height())
end

