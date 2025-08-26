---@generic T
---@class Array<T>: Class
---@field [integer] T 数组元素
---@field length integer 数组长度
---@field protected _data T[] 数组数据
---@field protected _length integer 数组长度
---@field new fun(self: Array): Array<T>
local Array = Class("Array")

function Array:__custom_index(key)
    return self._data[key]
end

function Array:__custom_new_index(key, value)
    self._data[key] = value
    self._length = #self._data
end


function Array:init()
    self._data = {}
    self._length = 0
end

---@param callback fun(e: T)
function Array:forEach(callback)
    for i = 1, self._length do
        callback(self._data[i])
    end
end

function Array:append(value)
    self._length = self._length + 1
    self._data[self._length] = value
end

function Array:pop()
    local value = self._data[self._length]
    self._data[self._length] = nil
    self._length = self._length - 1
    return value
end

function Array:__get_length()
    return self._length
end

function Array:__set_length(value)
    error("Array length is read-only")
end

return Array