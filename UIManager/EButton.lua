---@class UIManager.EButton : UIManager.ENode
---@field __name "UIManager.EButton"
---@field text string 按钮文本
---@field text_color Color 文本颜色，Hex值，例如0xFF0000是红色
---@field font_size Fixed 字体大小
---@field normal_image ImageKey 常态图片
---@field pressed_image ImageKey 按下图片
---@field protected _text string 受保护的文本内容
---@field protected _text_color Color 受保护的文本颜色
---@field protected _font_size Fixed 受保护的字体大小
---@field protected _normal_image ImageKey 常态图片
---@field protected _pressed_image ImageKey 按下图片
local EButton = Class("UIManager.EButton", UIManager.ENode)
local allroles = UIManager.allroles

---@param _node ENode
---@param _name string
function EButton:init(_node, _name)
    UIManager.ENode.init(self, _node, _name)
    self._text = ""
end

function EButton:__set_disabled(value)
    self._disabled = value
    self:__update_disabled()
end

function EButton:__update_disabled()
    if self.client_role then
        self.client_role.set_node_touch_enabled(self._id, self._disabled)
        self.client_role.set_button_enabled(self._id, not self._disabled)
    else
        for _, role in ipairs(allroles) do
            role.set_node_touch_enabled(self._id, self._disabled)
            role.set_button_enabled(self._id, not self._disabled)
        end
    end
end

function EButton:__get_text()
    return self._text
end

function EButton:__set_text(value)
    self._text = value
    self:__update_text()
end

-- 更新文本数据
function EButton:__update_text()
    if self.client_role then
        self.client_role.set_button_text(self._id, self._text)
    else
        for _, role in ipairs(allroles) do
            role.set_button_text(self._id, self._text)
        end
    end
end

function EButton:__get_text_color()
    return self._text_color
end

function EButton:__set_text_color(value)
    self._text_color = value
    self:__update_text_color()
end

-- 更新文本颜色
function EButton:__update_text_color()
    if self.client_role then
        self.client_role.set_button_text_color(self._id, self._text_color)
    else
        for _, role in ipairs(allroles) do
            role.set_button_text_color(self._id, self._text_color)
        end
    end
end

function EButton:__get_font_size()
    return self._font_size
end

function EButton:__set_font_size(value)
    self._font_size = math.tofixed(value)
    self:__update_font_size()
end

-- 更新字体大小
function EButton:__update_font_size()
    if self.client_role then
        self.client_role.set_button_font_size(self._id, self._font_size)
    else
        for _, role in ipairs(allroles) do
            role.set_button_font_size(self._id, self._font_size)
        end
    end
end

return EButton
