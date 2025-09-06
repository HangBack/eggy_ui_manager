---@class UIManager
---@field client_role Role?
UIManager = {}

UIManager.allroles = GameAPI.get_all_valid_roles()
UIManager.nodes_list = {} --[[@as table<ENode, UIManager.ENode?>]]
UIManager.name_node_mapping = {} --[[@as table<string, UIManager.ENode[]?> ]]
---@type 
--- {
---     [string]: {
---         trigger: integer,
---         [ENode]: {
---             callbacks: fun(data: {
---                 role: Role,
---                 target: UIManager.ENodeUnion,
---                 listener: UIManager.Listener
---             })[],
---             node: UIManager.ENodeUnion
---         }?
---     }?
--- }
UIManager.event_handlers = {}

UIManager.ECanvas = require "UIManager.ECanvas"
UIManager.ENode = require "UIManager.ENode"
UIManager.ELabel = require "UIManager.ELabel"
UIManager.EButton = require "UIManager.EButton"
UIManager.EImage = require "UIManager.EImage"
UIManager.EProgressbar = require "UIManager.EProgressbar"
UIManager.EInputField = require "UIManager.EInputField"
UIManager.Builder = require "UIManager.Builder"
UIManager.Listener = require "UIManager.Listener"
UIManager.Array = require "UIManager.Array"
UIManager.ArrayReadOnly = require "UIManager.ArrayReadOnly"

---@alias UIManager.ENodeUnion UIManager.ENode | UIManager.ELabel | UIManager.EImage

---@enum UIManager.ENodeType
UIManager.ENodeType = {
    ELabel = "UIManager.ELabel",
    EButton = "UIManager.EButton",
    EImage = "UIManager.EImage",
    ENode = "UIManager.ENode",
}

-- 通过名称查询节点数组
---@param _name string
---@return UIManager.ENodeUnion[]
UIManager.query_nodes_by_name = function(_name)
    return UIManager.name_node_mapping[_name] or {}
end

-- 通过ID查询节点
---@param _id ENode
---@return UIManager.ENodeUnion?
UIManager.query_node_by_id = function(_id)
    return UIManager.nodes_list[_id]
end

---@enum UIManager.EVENT
UIManager.EVENT = {
    CLICK = "CLICK"
}

---@generic T
---@param _node UIManager.ENodeUnion?
---@param _type `T`
---@return TypeGuard<T>
UIManager.typeof = function(_node, _type)
    return _node and _node.__name == _type or false
end
