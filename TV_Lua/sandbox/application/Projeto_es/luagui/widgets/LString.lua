--- String with UTF-8 support

require(SB_REQUIRE_LUAGUI .. "widgets.Object")

local UNICODE_MASK = 195
local UNICODE_REGEX = "([%z\1-\127\194-\244][\128-\191]*)"
local ULOWER_LEFT = 161
local ULOWER_RIGHT = 190
local UUPPER_LEFT = 129
local UUPPER_RIGHT = 158
local UPPER_A = 65
local UPPER_Z = 90
local LOWER_A = 97
local LOWER_Z = 122

LString = inheritsFrom(Object)

LString._string = ""

-- Converts a character to uppercase
--
-- @param c The character to convert
-- @return c converted to uppercase
local function uppercase(c)
    local upperC = ''
    if string.byte(string.sub(c, 1)) == UNICODE_MASK then
        local secondChar = string.byte(string.sub(c, 2))
        if ULOWER_LEFT <= secondChar and secondChar <= ULOWER_RIGHT then
            upperC = string.char(UNICODE_MASK) .. string.char(secondChar - 0x20)
            return upperC
        end
    end
    return string.upper(c)
end

-- Converts a character to lowercase
--
-- @param c The character to convert
-- @return c converted to lowercase
local function lowercase(c)
    local lowerC = ''
    if string.byte(string.sub(c, 1)) == UNICODE_MASK then
        local secondChar = string.byte(string.sub(c, 2))
        if UUPPER_LEFT <= secondChar and secondChar <= UUPPER_RIGHT then
            lowerC = string.char(UNICODE_MASK) .. string.char(secondChar + 0x20)
            return lowerC
        end
    end
    return string.lower(c)
end

--- Returns true if the given character is lowercase
--
-- @param c The character to verify
-- @return true if c is lowercase
local function isLower(c)
    if string.byte(string.sub(c, 1)) == UNICODE_MASK then
        local secondChar = string.byte(string.sub(c, 2))
        if UUPPER_LEFT <= secondChar and secondChar <= UUPPER_RIGHT then
            return false
        end
    else
        if (UPPER_A <= string.byte(c)) and (string.byte(c) <= UPPER_Z) then
            return false
        end
    end

    return true
end

--- Returns true if the given character is uppercase
--
-- @param c The character to verify
-- @return true if c is uppercase
local function isUpper(c)
    if string.byte(string.sub(c, 1)) == UNICODE_MASK then
        local secondChar = string.byte(string.sub(c, 2))
        if ULOWER_LEFT <= secondChar and secondChar <= ULOWER_RIGHT then
            return false
        end
    else
        if (LOWER_A <= string.byte(c)) and (string.byte(c) <= LOWER_Z) then
            return false
        end
    end

    return true
end

--- Swaps the case of the given character
--
-- @param c The character to swap case
-- @return The character c with case switched
local function swapcase(c)
    if isUpper(c) then
        return lowercase(c)
    end

    return uppercase(c)
end

--- Metatable of LString
local LStringMt = { __index = eString }

--- Instanciates a new LString with the same text of the given stdString.
-- If <code>stdString</code> is not a lua string,
-- <code>tostring(stdString)</code> will be used instead
--
-- @param stdString A lua string containing the text to use
-- @return The instance created
function LString:new(stdString)
    local newLString = {}

    for k, v in pairs(LString) do
        if type(v) == 'table' and nil ~= v.isAn and v:isAn(Object) then
            local vClass = v:class()
            newLString[k] = vClass:new(v)
        else
            newLString[k] = LString[k]
        end
    end

    setmetatable(newLString, LStringMt)

    newLString._string = tostring(stdString) or LString._string
    return newLString
end

--- Appends <code>s</code> to the string. If s is not a string, then tostring(s)
-- will be appended
--
-- @param s The object to append
-- @return <code>self</code>
function LString:append(s)
    self._string = self._string .. tostring(s)

    return self
end

LStringMt.__add = LString.append

--- Makes the first character of the string uppercase and the following
--characters lowercase
--
-- @return <code>self</code>
function LString:capitalize()
    local head = self:substring(1, 1):uppercase()
    local tail = self:substring(2):lowercase()

    self._string = tostring(head) .. tostring(tail)

    return self
end

--- Compares two strings for equality
--
-- @return <code>true</code> if the instances are equal, or <code>false</code>
function LString:equals(string)
    return tostring(self) == tostring(string)
end
LStringMt.__eq = LString.equals

--- Returns the length of the LString
--
-- @return The length of the LString
function LString:length()
    local len = 0
    for uchar in string.gfind(self._string, UNICODE_REGEX) do
        len = len + 1
    end

    return len
end
LStringMt.__len = LString.length

--- Converts the LString to lowercase
--
--  @return <code>self</code>
function LString:lowercase()
    local lowerString = ''

    for uchar in string.gfind(self._string, UNICODE_REGEX) do
        lowerString = lowerString .. lowercase(uchar)
    end

    self._string = lowerString
    return self
end

function LString:string()
    return self._string
end
LStringMt.__tostring = LString.string

--- Returns a LString with the characters of the LString defined
--  in the range [first, last]
--
--  @param first The first character to include
--  @param last (Optional) The last character to include. Default:
--  <code>self:length()</code>
function LString:substring(first, last)
    local s = ""
    local count = 1
    local first = math.max(1, first)

    local last = last or self:length()
    last = math.min(last, self:length())

    for uchar in string.gfind(self._string, UNICODE_REGEX) do
        if first <= count and count <= last then
            s = s .. uchar
        end
        count = count + 1
    end
    return LString:new(s)
end

--- Swaps the case of every character in the LString
--
-- @return <code>self</code>
function LString:swapCase()
    local s = ""
    local a = string.byte('a')
    local z = string.byte('z')

    for uchar in string.gfind(self._string, UNICODE_REGEX) do
        s = s .. swapcase(uchar)
    end

    self._string = s

    return self
end

--- Converts the LString to uppercase
--
-- @return <code>self</code>
function LString:uppercase()
    local upperString = ''

    for uchar in string.gfind(self._string, UNICODE_REGEX) do
        upperString = upperString .. uppercase(uchar)
    end

    self._string = upperString
    return self
end

--- Returns the character at the given index
--
-- @param index The index
-- @return The character at the given index, if any, or ""
function LString:at(index)
    if index < 0 or index > self:length() then return "" end

    return self:substring(index, index)
end

function LString:isUpper()
    for uchar in string.gfind(self._string, UNICODE_REGEX) do
        if not isUpper(uchar) then
            return false
        end
    end

    return true
end

function LString:isLower()
    for uchar in string.gfind(self._string, UNICODE_REGEX) do
        if not isLower(uchar) then
            return false
        end
    end

    return true
end

--- Returns the index of the first occurrence of the given substring after init
--
-- @param substring The substring to find
-- @param init The position to start the search from (default: 1)
function LString:indexOf(substring, init)
    subs=LString:new(substring)
	countSubs= subs:length()
	count= self:length()
	ini= init or 1
	for i=ini ,count+1  do
		if(i+countSubs>count+1)then break end
		aux = self:substring(i,i+countSubs-1):string()
		if(aux==subs:string())then
			return i,i+countSubs-1
		end
	end
	return nil
end

function LString:split(c)
    local words = {}
    local separator = _separator or " "
    local new_str = self:string()

    while true do
        local _index = string.find(new_str, separator) -- index of the separator
        local workaround = true -- workaround to use continue statement

        if _index == nil then -- end of string or no separator
            table.insert(words, string.sub(new_str, 1))
            return words;
        end

        if _index == 1 then -- separator begins the string
            table.insert(words, "")
            new_str = string.sub(new_str, 2)
            workaround = false
        end

        if workaround then -- if separator is not on the beginning of the string
            -- the program enters this
            table.insert(words, string.sub(new_str, 1, _index -1))
            new_str = string.sub(new_str, _index + 1)
        end

    end

    return words
end
function LString:generateIterator()
    local tmp = {}

    for uchar in string.gfind(self._string, UNICODE_REGEX) do
        table.insert(tmp, uchar)
    end

    self._iterable = tmp
    return self
end

function LString:iterable()
   self:generateIterator()
   return self._iterable
end
function LString:isAscii() end
function LString:isIn() end
function LString:join() end
function LString:lstrip() end
function LString:replace() end
function LString:reverse() end
function LString:rstrip() end
function LString:specialCharacters() end
function LString:strip(c) end

-- TODO: Implement the other operators. Fun fun fun.
-- __concat, __sub, __tostring, __call, __lt, __le

