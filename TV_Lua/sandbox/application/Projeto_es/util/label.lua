-- This is a class definition (see Programming in Lua, available online)

Label = {}
function Label:new(texto)
	local instance = {}
	setmetatable(instance, self)
	self.__index = Label
	
	instance.text = texto
	
	instance.fontSize = 18
	instance.fontColor = {r = 0, g = 0, b = 255, a = 255}
	--instance.backColor = {r = 255, g = 255, b = 255, a = 255}

	instance.x = 0
	instance.y = 0
	instance.w = 150
	instance.h = 30

	return instance
end

function Label:paint()
	local oldClipX, oldClipY, oldClipW, oldClipH = canvas:attrClip() -- get the previous clip settings to restore them later
	canvas:attrColor(self.fontColor.r, self.fontColor.g, self.fontColor.b, self.fontColor.a) -- set the font color
	canvas:attrFont('Lato', self.fontSize) -- set the font
	canvas:drawText(self.x + 2, self.y + 2, self.text) -- draw the text
	--canvas:flush() -- take everything that was drawn and show on the screen

	canvas:attrClip(oldClipX, oldClipY, oldClipW, oldClipH) -- always restore the previous clip settings to avoid changing the behavior of any paint method that calls this method
end

function Label:setStyle(style)
	-- This method sets the style of the label.
	self.fontColor = style.fontColor
	--self.backColor = style.backColor
	self.fontSize = style.fontSize
end
