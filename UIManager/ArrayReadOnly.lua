---@generic T
---@class ArrayReadOnly<T>: Array<T>
---@field length integer 数组长度
---@field protected _sequence Array<T> 数组数据
---@field protected _length integer 数组长度
---@field new fun(self: ArrayReadOnly, _array: Array<T>): ArrayReadOnly<T>
local ArrayReadOnly = Class("UIManager.ArrayReadOnly", UIManager.Array)

function ArrayReadOnly:__custom_index(key)
    return self._sequence[key]
end

function ArrayReadOnly:__custom_new_index(key, value)
    error("This Array is read-only")
end

---@param _sequence Array<T>
function ArrayReadOnly:init(_sequence)
    self._sequence = _sequence
end

function ArrayReadOnly:__get_length()
    return self._sequence._length
end

function ArrayReadOnly:append(value)
    error("This Array is read-only")
end

function ArrayReadOnly:pop()
    error("This Array is read-only")
end

return ArrayReadOnly