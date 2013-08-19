styles = {} -- a table to collect style information, in real life would probably be a class
styles.selected = { fontSize = 18, fontColor = {r = 0, g = 0, b = 255, a = 255}}
styles.normal = { fontSize = 18, fontColor = {r = 255, g = 255, b = 255, a = 255}}
styles.title = { fontSize = 18, fontColor = {r = 0, g = 0, b = 0, a = 255}}

styles.size14 = { fontSize = 14, fontColor = {r = 0, g = 0, b = 0, a = 255}}
styles.size15 = { fontSize = 15, fontColor = {r = 0, g = 0, b = 0, a = 255}}
styles.size16 = { fontSize = 16, fontColor = {r = 0, g = 0, b = 0, a = 255}}
styles.size17 = { fontSize = 17, fontColor = {r = 0, g = 0, b = 0, a = 255}}
styles.size18 = { fontSize = 18, fontColor = {r = 0, g = 0, b = 0, a = 255}}
styles.size19 = { fontSize = 19, fontColor = {r = 0, g = 0, b = 0, a = 255}}
styles.size22 = { fontSize = 22, fontColor = {r = 0, g = 0, b = 0, a = 255}}

local new_canvas = {}
new_canvas.drawLabel = function (self, x, y, text, style)
	require(SB_REQUIRE_UTIL .."label")  -- a component, usually described in its own file	
	style = style or styles.normal
	-- Now we will create 1 label
	local l1 = Label:new(text)
		
	-- Initializing the labels	
	l1.x = x
	l1.y = y
	l1.w = 120
	l1.h = 30
	
	-- initializing the screen
	l1:setStyle(style)
	l1:paint()
	return l1
end

return new_canvas