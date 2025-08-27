---@class UIManager.EBagSlot : UIManager.ENode
---@field __name "UIManager.EBagSlot"
---@field related_lifeentity LifeEntity 绑定的LifeEntity
---@field protected _related_lifeentity LifeEntity 受保护的绑定的LifeEntity
local EBagSlot = Class("UIManager.EBagSlot", UIManager.ENode)
local allroles = UIManager.allroles

---@param _node ENode
---@param _name string
function EBagSlot:init(_node, _name)
    UIManager.ENode.init(self, _node, _name)
    self._text = ""
end

function EBagSlot:__get_related_lifeentity()
    return self._related_lifeentity
end

function EBagSlot:__set_related_lifeentity(value)
    self._related_lifeentity = value
    self:__update_related_lifeentity()
end

-- 更新绑定的LifeEntity
function EBagSlot:__update_related_lifeentity()
    if self._related_lifeentity == nil then
        if self.client_role then
            self.client_role.set_bagslot_related_lifeentity(self._id, nil)

return EBagSlot
