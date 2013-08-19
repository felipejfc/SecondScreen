--- Module responsible to handle many different utility tasks.
Utils = {} or Utils

--- Returns the type of a given object.
--
--@param var object to extract the type.
--@return the type of the object.
function typeOf(var)
    local _type = type(var);
    if(_type ~= "table" and _type ~= "userdata") then
        return _type;
    end
    local _meta = getmetatable(var);
    if(_meta ~= nil and _meta._type ~= nil) then
        return _meta._type;
    else
        return _type;
    end
end

--- Function to check if a given path exists or matches the user permissions.
--
--@param path path to the file.
--@return true if exists/readable, false otherwise.
function Utils.isReadable(path)
    local file = io.open(path)
    if file then
        file:close()
        return true
    end

    return false
end

--- Splits the given string using a given separator. If no separator is used,
--  " " (a blank space) will be used.
--
--@param str The string to split.
--@param _separator pattern to be used on the splitting.
--@return a table with the split string.
function split(str, _separator) -- if no separator is used, " " is used
  words = {}
  separator = _separator or " "
  new_str = str
  while true do
    _index = string.find(new_str, separator) -- index of the separator
    workaround = true -- workaround to use continue statement

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
