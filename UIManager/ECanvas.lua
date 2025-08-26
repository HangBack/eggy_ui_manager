---@class UIManager.ECanvas : Class
---@field __name "UIManager.ECanvas"
---@field id ECanvas ID值 - 只读
---@field name string UI名称 - 只读
---@field parent UIManager.ECanvas? 父亲节点 - 只读
---@field children ArrayReadOnly<UIManager.ECanvas> 子节点列表 - 只读
---@field client_role Role? 客户端玩家
---@field protected _id ECanvas 受保护的id值
---@field protected _name string 受保护的UI名称
---@field protected _parent UIManager.ECanvas 受保护的父亲节点
---@field protected _children Array<UIManager.ECanvas> 受保护的子节点列表
---@field protected _client_role Role? 受保护的客户端玩家
---@field new fun(self: UIManager.ECanvas, _node: ECanvas, _name: string)
local ECanvas = Class("UIManager.ECanvas")
local nodes_list = UIManager.nodes_list

---@param _node ECanvas
---@param _name string
function ECanvas:init(_node, _name)
    if nodes_list[_node] then
        nodes_list[_node] = nil
    end
    nodes_list[_node] = self
    self._name = _name
    self._parent = nil
    self._id = _node

    local array = UIManager.Array:new() --[[@as Array<UIManager.ECanvas>]]
    self._children = array
    self._read_only_children = UIManager.ArrayReadOnly:new(array)
end

function ECanvas:__init_children()
    for idx, node in ipairs(GameAPI.get_eui_children(self.id)) do
        local uinode = nodes_list[node] --[[@as UIManager.ECanvas]]
        uinode._parent = self
        self._children[idx] = uinode
    end
end

function ECanvas:__get_children()
    return self._read_only_children
end

function ECanvas:__set_children(value)
    warn(("attempt to set a read-only value field 'children' of '%s'"):format(self.__name))
end

function ECanvas:__get_parent()
    return self._parent
end

function ECanvas:__set_parent(value)
    warn(("attempt to set a read-only value field 'parent' of '%s'"):format(self.__name))
end

function ECanvas:__get_name()
    return self._name
end

function ECanvas:__set_name(value)
    warn(("attempt to set a read-only value field 'name' of '%s'"):format(self.__name))
end

function ECanvas:__get_id()
    return self._id
end

function ECanvas:__set_id(value)
    warn(("attempt to set a read-only value field 'id' of '%s'"):format(self.__name))
end

return ECanvas
