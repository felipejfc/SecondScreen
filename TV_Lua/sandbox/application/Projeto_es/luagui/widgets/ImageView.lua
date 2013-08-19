--- Class that represents an ImageView and extends Widget
require(SB_REQUIRE_LUAGUI .. "widgets.Widget")

ImageView = inheritsFrom(Widget)

--- ImageView metatable.
local ImageViewMt = {
    __index = ImageView
}

--- Instantiates a new ImageView object. Can be used to clone an existing
-- ImageView instance.
-- @param i nil or the ImageView to clone.
-- @param path a string containing the path to the desired image.
function ImageView:new(path)
    local newImageView = {}
    local src = ImageView

    for k, v in pairs(src) do
        newImageView[k] = src[k]
    end
    for k, v in pairs(src) do
        if type(v) == 'table' and nil ~= v.isAn and v:isAn(Object) then
            local vClass = v:class()
            newImageView[k] = vClass:new(v)
        else
            newImageView[k] = src[k]
        end
    end

    setmetatable(newImageView, ImageViewMt)
    if path then
        newImageView:path(path)
    end
    return newImageView

end

--- Reads or sets the image path.
--
--@param path A string containing the path to the image.
--@return the image path
function ImageView:path(path)
    if not path then
        return self._imagePath
    else
        _file = io.open(path, 'r')
        if _file then
            self._imagePath = path
            _file:close()
        else
            self._imagePath = ''
        end
    end
end

--- Returns the current canvas or sets another canvas to use.
--
--@param c canvas to be used.
--@return the current canvas.
function ImageView:image(c)
    if not c then
        return self._image
    else
        self._image = c
    end
end

--- Creates a canvas object using the path used on the ImageView object.
--
--@return self
function ImageView:loadImage()
    self:image(canvas:new(self:path()))
    return self
end

function ImageView:draw(lcanvas)
    local lcanvas = lcanvas or canvas
    local ivCanvas = canvas:new(self:width(), self:height())

    if self:path() ~= '' then
        self:loadImage()
        ivCanvas:compose(0, 0, self:image())
    end

    lcanvas:compose(self:x(), self:y(), ivCanvas)
end

