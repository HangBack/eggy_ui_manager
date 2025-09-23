---@generic T, C
---@class UIManager.Promise<T>
---@field new fun(self: UIManager.Promise, value: T): UIManager.Promise
---@field protected _is_completed boolean
local Promise = Class("UIManager.Promise")

---@param value T
function Promise:init(value)
    self._value = value
    self._callbacks = {}
    self._is_completed = false
end

---@param value T
function Promise:_resolve(value)
    if self._is_completed then return end
    
    self._is_completed = true
    self._value = value
    
    -- 执行所有等待的回调
    for _, callback in ipairs(self._callbacks) do
        callback(value)
    end
    self._callbacks = {}
end

---@generic G
---@param _callback fun(e: T) : G
---@return UIManager.Promise<G>
function Promise:done_then(_callback)
    if self._is_completed then
        -- 如果已经完成，立即执行回调
        local result = _callback(self._value)
        if result ~= nil then
            -- 创建新的 Promise 并传递返回值
            local new_promise = Promise:new(result)
            new_promise:_resolve(result)
            return new_promise
        else
            return self
        end
    else
        -- 如果未完成，将回调加入队列
        table.insert(self._callbacks, _callback)
        return self
    end
end

---@param _interval integer
---@return UIManager.Promise<T>
function Promise:wait(_interval)
    if self._is_completed then
        -- 如果已经完成，创建新的 Promise 进行等待
        local new_promise = Promise:new(self._value)
        
        UIManager.set_frame_out(_interval, function()
            new_promise:_resolve(self._value)
        end)
        
        return new_promise
    else
        -- 如果未完成，创建新的 Promise 等待当前 Promise 完成后再等待指定帧数
        local new_promise = Promise:new()
        table.insert(self._callbacks, function(value)
            UIManager.set_frame_out(_interval, function()
                new_promise:_resolve(value)
            end)
        end)
        
        return new_promise
    end
end

-- 协程版本的等待（可选，便于在协程中使用）
---@async
function Promise:await()
    if self._is_completed then
        return self._value
    else
        local co = coroutine.running()
        self:done_then(function(value)
            coroutine.resume(co, value)
        end)
        return coroutine.yield()
    end
end

return Promise