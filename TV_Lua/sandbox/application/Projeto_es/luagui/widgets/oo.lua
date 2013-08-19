--- Module defining object orientation methods.

--- A new inheritsFrom() function
--@param baseClass Class to inherit from
--@return Class containing the inherited fields, objects and methods.
function inheritsFrom(baseClass)

    local newClass = {}
    local classMt = { __index = newClass }

    function newClass:new()
        local newInst = {}
        return setmetatable(newInst, classMt )
    end

    function newClass:equals(other)
        local theClass = self:class()

        if not other:isA(theClass) then return false end

        for k,v in pairs(self) do
            if self[k] ~= other[k] then return false end
        end

        return true
    end

    classMt.__eq = newClass.equals

    if nil ~= baseClass then
        for k, v in pairs(baseClass) do
            newClass[k] = v
        end

        newClassMt = { __index = baseClass or {} }

        newClass = setmetatable(newClass, newClassMt)
    end

    -- Implementation of additional OO properties starts here --

    -- Return the class object of the instance
    function newClass:class()
        return newClass
    end

    -- Return the super class object of the instance
    function newClass:superClass()
        return baseClass
    end

    -- Return true if the caller is an instance of theClass
    function newClass:isA(theClass)
        local bIsa = false

        local curClass = newClass

        while (nil ~= curClass) and (false == bIsa) do
            if curClass == theClass then
                bIsa = true
            else
                curClass = curClass:superClass()
            end
        end

        return bIsa
    end

    function newClass:isAn(theClass)
        return self:isA(theClass)
    end

    return newClass
end


--- Generates accessor/modifier function for a given field.
--
-- The generated method has the following prototype:
--
-- Acessor: function(self) -> field
-- Modifier: function(self, value) -> self
--
-- @param field The field for which the function should be generated
--
-- @param validator Optional a function to validate the value of the field.
--      Should return true if the value is permitted for the setter or false
--      otherwise.
--
-- @return An acessor/modifier for the given field.
--

function accessorFor(field, validator)
    return function(self, value)
        if nil == value then return self[field] end

        if nil ~= validator then assert(validator(value)) end

        self[field] = value

        return self
    end
end

