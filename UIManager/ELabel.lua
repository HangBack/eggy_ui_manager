---@class UIManager.ELabel : UIManager.ENode
---@field __name "UIManager.ELabel"
---@field text string 文本内容
---@field label_background_color Color 背景颜色
---@field label_background_opacity Fixed 背景不透明度
---@field text_color Color 文本颜色，Hex值，例如0xFF0000是红色
---@field transition_time Fixed 样式变化时间
---@field font_family FontKey 字体
---@field font_size integer 字体大小
---@field outline_color Color 描边颜色
---@field outline boolean 是否描边
---@field outline_opacity Fixed 描边不透明度
---@field outline_width Fixed 描边宽度
---@field shadow_color Color 阴影颜色
---@field shadow boolean 是否阴影
---@field shadow_x_offset Fixed 阴影x偏移
---@field shadow_y_offset Fixed 阴影y偏移
---@field protected _text string 受保护的文本内容
---@field protected _label_background_color Color 背景颜色
---@field protected _label_background_opacity Fixed 背景不透明度
---@field protected _text_color Color 受保护的文本颜色
---@field protected _transition_time Fixed 受保护的样式变化时间
---@field protected _font_family FontKey 字体
---@field protected _font_size integer 字体大小
---@field protected _outline_color Color 描边颜色
---@field protected _outline boolean 是否描边
---@field protected _outline_opacity Fixed 描边不透明度
---@field protected _outline_width Fixed 描边宽度
---@field protected _shadow_color Color 阴影颜色
---@field protected _shadow boolean 是否阴影
---@field protected _shadow_x_offset Fixed 阴影x偏移
---@field protected _shadow_y_offset Fixed 阴影y偏移
local ELabel = Class("UIManager.ELabel", UIManager.ENode)
local allroles = UIManager.allroles

---@param _node ENode
---@param _name string
function ELabel:init(_node, _name)
    UIManager.ENode.init(self, _node, _name)
    self._text = ""
    self._transition_time = 0.0
end

function ELabel:__get_text()
    return self._text
end

function ELabel:__set_text(value)
    self._text = value
    self:__update_text()
end

-- 更新文本数据
function ELabel:__update_text()
    if self.client_role then
        self.client_role.set_label_text(self._id, self._text)
    else
        for _, role in ipairs(allroles) do
            role.set_label_text(self._id, self._text)
        end
    end
end

function ELabel:__get_label_background_color()
    return self._label_background_color
end

function ELabel:__set_label_background_color(value)
    self._label_background_color = value
    self:__update_label_background_color()
end

-- 更新背景颜色
function ELabel:__update_label_background_color()
    if self.client_role then
        self.client_role.set_label_background_color(self._id, self._label_background_color, self._transition_time)
    else
        for _, role in ipairs(allroles) do
            role.set_label_background_color(self._id, self._label_background_color, self._transition_time)
        end
    end
end

function ELabel:__get_label_background_opactiy()
    return self._label_background_opactiy
end

function ELabel:__set_label_background_opactiy(value)
    self._label_background_opactiy = value
    self:__update_label_background_opactiy()
end

-- 更新背景不透明度
function ELabel:__update_label_background_opactiy()
    if self.client_role then
        self.client_role.set_label_background_opacity(self._id, self._label_background_opacity, self._transition_time)
    else
        for _, role in ipairs(allroles) do
            role.set_label_background_opacity(self._id, self._label_background_opacity, self._transition_time)
        end
    end
end

function ELabel:__get_text_color()
    return self._text_color
end

function ELabel:__set_text_color(value)
    self._text_color = value
    self:__update_text_color()
end

-- 更新文本颜色
function ELabel:__update_text_color()
    if self.client_role then
        self.client_role.set_label_color(self._id, self._text_color, self._transition_time)
    else
        for _, role in ipairs(allroles) do
            role.set_label_color(self._id, self._text_color, self._transition_time)
        end
    end
end

function ELabel:__get_transition_time()
    return self._transition_time
end

function ELabel:__set_transition_time(value)
    self._transition_time = math.tofixed(value)
end

function ELabel:__get_font_family()
    return self._font_family
end

function ELabel:__set_font_family(value)
    self._font_family = value
    self:__update_font_family()
end

-- 更新字体
function ELabel:__update_font_family()
    if self.client_role then
        self.client_role.set_label_font(self._id, self._font_family)
    else
        for _, role in ipairs(allroles) do
            role.set_label_font(self._id, self._font_family)
        end
    end
end

function ELabel:__get_font_size()
    return self._font_size
end

function ELabel:__set_font_size(value)
    self._font_size = math.tointeger(value)
    self:__update_font_size()
end

-- 更新字体大小
function ELabel:__update_font_size()
    if self.client_role then
        self.client_role.set_label_font_size(self._id, self._font_size, self._transition_time)
    else
        for _, role in ipairs(allroles) do
            role.set_label_font_size(self._id, self._font_size, self._transition_time)
        end
    end
end

function ELabel:__get_outline_color()
    return self._outline_color
end

function ELabel:__set_outline_color(value)
    self._outline_color = value
    self:__update_outline_color()
end

-- 更新描边颜色
function ELabel:__update_outline_color()
    if self.client_role then
        self.client_role.set_label_outline_color(self._id, self._outline_color)
    else
        for _, role in ipairs(allroles) do
            role.set_label_outline_color(self._id, self._outline_color)
        end
    end
end

function ELabel:__get_outline()
    return self._outline
end

function ELabel:__set_outline(value)
    self._outline = value
    self:__update_outline()
end

-- 更新是否描边
function ELabel:__update_outline()
    if self.client_role then
        self.client_role.set_label_outline_enabled(self._id, self._outline)
    else
        for _, role in ipairs(allroles) do
            role.set_label_outline_enabled(self._id, self._outline)
        end
    end
end

function ELabel:__get_outline_opacity()
    return self._outline_opacity
end

function ELabel:__set_outline_opacity(value)
    self._outline_opacity = math.tofixed(value)
    self:__update_outline_opacity()
end

-- 更新描边不透明度
function ELabel:__update_outline_opacity()
    if self.client_role then
        self.client_role.set_label_outline_opacity(self._id, self._outline_opacity)
    else
        for _, role in ipairs(allroles) do
            role.set_label_outline_opacity(self._id, self._outline_opacity)
        end
    end
end

function ELabel:__get_outline_width()
    return self._outline_width
end

function ELabel:__set_outline_width(value)
    self._outline_width = math.tofixed(value)
    self:__update_outline_width()
end

-- 更新描边宽度
function ELabel:__update_outline_width()
    if self.client_role then
        self.client_role.set_label_outline_width(self._id, self._outline_width)
    else
        for _, role in ipairs(allroles) do
            role.set_label_outline_width(self._id, self._outline_width)
        end
    end
end

function ELabel:__get_shadow_color()
    return self._shadow_color
end

function ELabel:__set_shadow_color(value)
    self._shadow_color = value
    self:__update_shadow_color()
end

-- 更新阴影颜色
function ELabel:__update_shadow_color()
    if self.client_role then
        self.client_role.set_label_shadow_color(self._id, self._shadow_color)
    else
        for _, role in ipairs(allroles) do
            role.set_label_shadow_color(self._id, self._shadow_color)
        end
    end
end

function ELabel:__get_shadow()
    return self._shadow
end

function ELabel:__set_shadow(value)
    self._shadow = value
    self:__update_shadow()
end

-- 更新是否阴影
function ELabel:__update_shadow()
    if self.client_role then
        self.client_role.set_label_shadow_enabled(self._id, self._shadow)
    else
        for _, role in ipairs(allroles) do
            role.set_label_shadow_enabled(self._id, self._shadow)
        end
    end
end

function ELabel:__get_shadow_x_offset()
    return self._shadow_x_offset
end

function ELabel:__set_shadow_x_offset(value)
    self._shadow_x_offset = math.tofixed(value)
    self:__update_shadow_x_offset()
end

-- 更新阴影x偏移
function ELabel:__update_shadow_x_offset()
    if self.client_role then
        self.client_role.set_label_shadow_x_offset(self._id, self._shadow_x_offset)
    else
        for _, role in ipairs(allroles) do
            role.set_label_shadow_x_offset(self._id, self._shadow_x_offset)
        end
    end
end

function ELabel:__get_shadow_y_offset()
    return self._shadow_y_offset
end

function ELabel:__set_shadow_y_offset(value)
    self._shadow_y_offset = math.tofixed(value)
    self:__update_shadow_y_offset()
end

-- 更新阴影y偏移
function ELabel:__update_shadow_y_offset()
    if self.client_role then
        self.client_role.set_label_shadow_y_offset(self._id, self._shadow_y_offset)
    else
        for _, role in ipairs(allroles) do
            role.set_label_shadow_y_offset(self._id, self._shadow_y_offset)
        end
    end
end

return ELabel
