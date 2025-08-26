---@class UIManager.EInputField : UIManager.ENode
---@field __name "UIManager.EInputField"
---@field text string 文本内容
---@field text_color Color 文本颜色，Hex值，例如0xFF0000是红色
---@field protected _text string 受保护的文本内容
local EInputField = Class("UIManager.EInputField", UIManager.ENode)
local allroles = UIManager.allroles

---@param _node ENode
---@param _name string
function EInputField:init(_node, _name)
    UIManager.ENode.init(self, _node, _name)
    self._text = ""
end

function EInputField:__get_text()
    return self._text
end

function EInputField:__set_text(value)
    self._text = value
    self:__update_text()
end

-- 更新文本数据
function EInputField:__update_text()
    if self.client_role then
        self.client_role.set_input_field_text(self._id, self._text)
    else
        for _, role in ipairs(allroles) do
            role.set_input_field_text(self._id, self._text)
        end
    end
end

return EInputField
