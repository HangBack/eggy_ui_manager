---@class ClassUtil
---@field __name string 类名
---@field private init fun()
local ClassUtil = {}

-- 自定义索引，必须有返回值，否则将报错
---@param key any 索引
---@return any
function ClassUtil:__custom_index(key) end

-- 自定义新索引，必须有返回值，否则将报错
---@param key any 索引
---@param value any 值
---@return any
function ClassUtil:__new_custom_index(key, value) end

-- Getter
---@return any
function ClassUtil:__get_() end

-- Setter
---@param value any
function ClassUtil:__set_(value) end

-- 构造函数
function ClassUtil:init() end

-- 递归查找继承链中的__custom_index
local function find_custom_index(current_class)
    local custom_index = rawget(current_class, "__custom_index")
    if custom_index then
        return custom_index
    end
    for _, parent_table in ipairs(current_class.__parents) do
        custom_index = find_custom_index(parent_table)
        if custom_index then
            return custom_index
        end
    end
    return nil
end

-- 递归查找getter方法
local function find_getter(current_class, key)
    local getter_name = "__get_" .. key
    local getter = rawget(current_class, getter_name)
    if getter then
        return getter
    end
    for _, parent_table in ipairs(current_class.__parents) do
        getter = find_getter(parent_table, key)
        if getter then
            return getter
        end
    end
    return nil
end

-- 递归查找setter方法
local function find_setter(current_class, key)
    local setter_name = "__set_" .. key
    local setter = rawget(current_class, setter_name)
    if setter then
        return setter
    end
    for _, parent_table in ipairs(current_class.__parents) do
        setter = find_setter(parent_table, key)
        if setter then
            return setter
        end
    end
    return nil
end

-- 递归查找继承链中的__new_custom_index
local function find_new_custom_index(current_class)
    local custom_index = rawget(current_class, "__new_custom_index")
    if custom_index then
        return custom_index
    end
    for _, parent_table in ipairs(current_class.__parents) do
        custom_index = find_new_custom_index(parent_table)
        if custom_index then
            return custom_index
        end
    end
    return nil
end


---@generic T: ClassUtil
---@param class_name `T` 类名
---@return table
local function Class(class_name, ...)
    local parents = { ... }
    local class_table = {
        __name = class_name,
        __parents = parents
    }
    ---@meta
    local metatable = {}
    -- 设置类表的元表，用于处理类方法的继承
    if #parents > 0 then
        metatable.__index = function(t, key)
            -- 遍历所有父类查找方法
            for _, parent in ipairs(parents) do
                local value = parent[key]
                if value ~= nil then
                    return value
                end
            end
        end
    end

    metatable.__call = function(self, ...)
        local instance = {}
        local error_msg = nil
        local function deferred_error(err)
            -- 保存完整的错误堆栈
            error_msg = {
                message = err,
                traceback = traceback(tostring(err), 2)
            }
        end

        local function process_deferred_error(err_info)
            if err_info then
                -- 可以选择重新抛出原始错误或包装后的错误
                LuaAPI.log(err_info.traceback)
            end
        end
        -- 创建实例的元表
        local instance_meta = {
            __index = function(t, key)
                -- 1. 先检查是否有getter方法
                local getter = find_getter(class_table, key)
                if getter then
                    return getter(t)
                end

                -- 2. 然后尝试自定义索引方法（递归查找继承链）
                local custom_index = find_custom_index(class_table) --[[@as fun(t: table, key: any): any]]
                if custom_index then
                    local status, result = xpcall(custom_index, deferred_error, t, key)
                    if status and result ~= nil then
                        return result
                    end
                end

                -- 3. 最后尝试在类继承链中查找
                local value = class_table[key]
                if value ~= nil then
                    return value
                end
                if error_msg then
                    process_deferred_error(error_msg)
                end
            end,

            __newindex = function(t, key, value)
                -- 检查是否有setter方法
                local setter = find_setter(class_table, key)
                if setter then
                    setter(t, value)
                else
                    -- 没有setter时直接设置值
                    local custom_new_index = find_new_custom_index(class_table)
                    if custom_new_index then
                        local status, result = xpcall(custom_new_index, deferred_error, t, key, value)
                        if not status then
                            rawset(t, key, value)
                        end
                    else
                        -- 没有setter时直接设置值
                        rawset(t, key, value)
                    end
                end
            end
        }

        setmetatable(instance, instance_meta)

        -- 调用初始化方法
        if self.init then
            self.init(instance, ...)
        end

        return instance
    end
    setmetatable(class_table, metatable)

    return class_table
end

return Class