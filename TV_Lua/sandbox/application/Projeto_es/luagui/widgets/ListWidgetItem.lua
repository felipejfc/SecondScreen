--- Class representing a ListWidget item.
ListWidgetItem = {}

--- Instantiates a ListWidgetItem object.
--@param text Text to be held on the item.
--@param object Object held on the Item.
--@return self.
function ListWidgetItem.new(text, object)
    local item = {}
    item.text = text
    item.object = object

    return item
end

