local ustring = {}

ustring.split = function (str, pat)
	if str == nil then return {} end
	if(pat == '') then
		return {}
	end
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
	 table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end

ustring.trim = function (s)
  return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

local function traceback ()
	local level = 1
	local response = ""
	while true do
		local info = debug.getinfo(level, "Sl")
		if not info then break end
		if info.what == "C" then   -- is a C function?
			--print(level, "C function")
		else   -- a Lua function
			response = response .. (string.format("%s;",
			info.source))
		end
		level = level + 1
	end	
	return response
end

ustring.getPath = function()
	local trace = string.gsub(traceback(), "@", "")
	local all_path = ustring.split(trace, ";")
	local str = all_path[1]
	
	str = string.gsub(str, "//.", "")
	return str
end

ustring.getProjectPath = function()	
	local str = ustring.getPath()
	
	local token = ustring.split(str, "/")
	local n = table.getn(token)
	local response = ""	
	
	for i=1, n - 4 do		
		local path = token[i]	
		if (path ~= "." and string.find(path, "@") == nil and path ~= "") then
			response = response .. path .. "/"
		end
	end
	local backslash = string.sub(str, 1, 1)
	if (backslash == "/") then
		response = "/" .. response
	end

	return response
end 

ustring.getFileName = function(path)
	local token = ustring.split(path, "/")
	local n = table.getn(token)	
	return token[n]
end	 

ustring.getWidgetId = function(caller)
	local token = ustring.split(caller, "/")
	local n = table.getn(token)	- 1
	local main_name = tostring(token[n])
	return main_name
end

ustring.wrap = function(data, max_size, areaLimit, sizeFont)
	
	if(max_size == nil or max_size < 1)then
		return {}
	end
	local words = ustring.split(data, " ") -- faz split das palavras no espaço
	local lines = {} 
	local phrase = ""
	local line = 1
	local i = 1
	
	local sizePhrase = 0
	local sizeNewPhrase = 0 
	local sizeWord = 0
	sizeFont = sizeFont or 18
	
	canvas:attrFont("Lato", sizeFont, 'normal')
	while (#words ~= 0 ) do
		local w = words[i]
		table.remove(words, 1)
		
		if(areaLimit ~= nil)then
			sizePhrase, s = canvas:measureText(phrase)
			sizeNewPhrase, s = canvas:measureText(phrase .. w)
			sizeWord, s = canvas:measureText(w)
		end
		
		if ( (string.len(ustring.removeAccent(phrase)) + string.len(ustring.removeAccent(w)) > max_size  and areaLimit == nil) or 
		( (areaLimit ~= nil) and (sizeNewPhrase > areaLimit ) )) then
		
			if(string.len(w) > max_size and areaLimit == nil) then				
				newSize = max_size - string.len(ustring.removeAccent(phrase))

				local newWord = string.sub(w,1, newSize - 1)
				if(phrase == "")then
					phrase = newWord
				else
					phrase = phrase .. " " .. newWord
				end
				lines[line] = phrase
				line = line + 1
				phrase = ""
				table.insert(words, 1, string.sub(w,newSize, #w))
				
				
			elseif(areaLimit ~= nil and sizeWord > areaLimit) then				
				local newWord = ""
				local newSize = 1
				sizeNewWord, s = canvas:measureText(phrase .. newWord)
				while (sizeNewWord < areaLimit) do					
					newWord = string.sub(w,1, newSize)
					sizeNewWord, s = canvas:measureText(phrase .. newWord)
					newSize = newSize + 1
				end
				
				newWord = string.sub(w,1, newSize - 1)
				if(phrase == "")then
					phrase = newWord
				else
					phrase = phrase .. " " .. newWord
				end
				lines[line] = phrase
				line = line + 1
				phrase = ""
				table.insert(words, 1, string.sub(w,newSize, #w))
			else
				lines[line] = phrase
				line = line + 1
				phrase = w
			end
		else
			if(phrase == "")then
				phrase = w
			else
				phrase = phrase .. " " .. w
			end
		end
		if (#words == 0 and phrase ~= "") then
			lines[line] = phrase
		end
	end
	return lines
end

ustring.truncate = function(str, maxSizePhrase, sizeFont)
	local phrase = ""
	sizeFont = sizeFont or 18
	canvas:attrFont("Lato", sizeFont, 'bold')
	sizeString, _ = canvas:measureText(str)
	local thereTrunc = false
	if(sizeString <= maxSizePhrase) then
		phrase = str
	else
		thereTrunc = true
		local sizeLetterW, _ = canvas:measureText("W")
		local shearIndex = math.floor(maxSizePhrase/ sizeLetterW)
		phrase = string.sub(str, 1, shearIndex)
		--thereTrunc = false
		
		local sizePhrase, _ = canvas:measureText(phrase)
		local beforePhrase = phrase
		while (sizePhrase < maxSizePhrase) do
			beforePhrase = phrase
			shearIndex = shearIndex + 1
			phrase = string.sub(str, 1, shearIndex)
			sizePhrase, _ = canvas:measureText(phrase)
		end
		
		if(sizePhrase > maxSizePhrase)then
			phrase = beforePhrase
		end
	end
	return phrase, thereTrunc
end

ustring.isValidDate = function(str)
  if str == nil or #str ~= 10 then return false end
  local m, d, y = str:match("(%d+)/(%d+)/(%d+)")
  m, d, y = tonumber(m), tonumber(d), tonumber(y)
  if m == 4 or m == 6 or m == 9 or m == 11 then -- Apr, Jun, Sep, Nov can have at most 30 days
    return d <= 30
  elseif m == 2 then -- Feb
    if y % 400 == 0 or (y % 100 ~= 0 and y % 4 == 0) then -- if leap year, days can be at most 29
      return d <= 29
    else  -- else 28 days is the max
      return d <= 28
    end
  else -- all other months can have at most 31 days
    return d <= 31
  end
end

---This function replace symbols in the format unicode for a enconding accepted by the emulator
--@params message message where it will solve the encoding
ustring.resolveEnconding = function(message)
	message = message:gsub("u00e3", "ã")
	message = message:gsub("u00e1", "á")
	message = message:gsub("u00e0", "à")
	message = message:gsub("u00e9", "é")
	message = message:gsub("u00ea", "ê")
	message = message:gsub("u00ed", "í")
	message = message:gsub("u00fa", "ú")
	message = message:gsub("u00f4", "ô")
	message = message:gsub("u00f5", "õ")
	message = message:gsub("u00e7", "ç")
	message = message:gsub("u00c1", "Á")
	message = message:gsub("u00c0", "À")
	message = message:gsub("u00c3", "Ã")
	message = message:gsub("u00c9", "É")
	message = message:gsub("u00ca", "Ê")
	message = message:gsub("u00d4", "Ô")
	message = message:gsub("u00d5", "Õ")
	message = message:gsub("u00da", "Ú")
	message = message:gsub("u00c7", "Ç")
	message = message:gsub("u1ebd","ẽ")
	message = message:gsub("u0129","ĩ")
	message = message:gsub("u0169","ũ")
	message = message:gsub("u00e2","â")
	message = message:gsub("u00ee","î")
	message = message:gsub("u00fb","û")
	message = message:gsub("u00f3","ó")
	message = message:gsub("u00e8","è")
	message = message:gsub("u00ec","ì")
	message = message:gsub("u00f2","ò")
	message = message:gsub("u00f9","ù")
	message = message:gsub("u00f1","ñ")
	message = message:gsub("u00a9","©")
	message = message:gsub("u20ac","€")
	message = message:gsub("u00e6","æ")
	message = message:gsub("u00df","ß")
	message = message:gsub("u00f0","ð")
	message = message:gsub("u0111","đ")
	message = message:gsub("u014b","ŋ")
	message = message:gsub("u0127","ħ")
	message = message:gsub("u0142","ł")
	message = message:gsub("u00ba","º")
	message = message:gsub("u00aa","ª")
	message = message:gsub("u00a7","§")
	message = message:gsub("u00ab","«")
	message = message:gsub("u00b5","µ")
	message = message:gsub("u00a3","£")
	message = message:gsub("u00a2","¢")
	message = message:gsub("u00ac","¬")
	message = message:gsub("u00a0"," ")
	message = message:gsub("u2019","'")
	message = message:gsub("u00f6","ö")
	message = message:gsub("u00eb","ë")
	message = message:gsub("u0131","i")
	message = message:gsub("\\","")
	
	return message
end
ustring.removeAccent = function(message)	
	message = message:gsub("ã", "a")
	message = message:gsub("á", "a")
	message = message:gsub("à", "a")
	message = message:gsub("é", "e")
	message = message:gsub("ê", "e")
	message = message:gsub("í", "i")
	message = message:gsub("ú", "u")
	message = message:gsub("ô", "o")
	message = message:gsub("õ", "o")
	message = message:gsub("ç", "c")
	message = message:gsub("Á", "A")
	message = message:gsub("À", "A")
	message = message:gsub("Ã", "A")
	message = message:gsub("É", "E")
	message = message:gsub("Ê", "E")
	message = message:gsub("Ô", "O")
	message = message:gsub("Õ", "O")
	message = message:gsub("Ú", "U")
	message = message:gsub("Ç", "C")
	message = message:gsub("ẽ", "e")
	message = message:gsub("ĩ", "i")
	message = message:gsub("ũ", "u")
	message = message:gsub("â", "a")
	message = message:gsub("î", "i")
	message = message:gsub("û", "u")
	message = message:gsub("ó", "o")
	message = message:gsub("è", "e")
	message = message:gsub("ì", "i")
	message = message:gsub("ò", "o")
	message = message:gsub("ù", "u")
	message = message:gsub("ñ", "n")
	message = message:gsub("ö", "o")
	message = message:gsub("ë", "e")
	message = message:gsub("i", "i")
	
	return message
end

return ustring
