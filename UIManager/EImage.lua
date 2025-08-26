---@class UIManager.EImage : UIManager.ENode
---@field __name "UIManager.EImage"
---@field image_color Color 图片颜色
---@field image_texture ImageKey 图片预设
---@field transition_time Fixed 样式变化时间
---@field protected _image_color Color 图片颜色
---@field protected _image_texture ImageKey 图片预设
---@field protected _transition_time Fixed 受保护的样式变化时间
local EImage = Class("UIManager.EImage", UIManager.ENode)
local allroles = UIManager.allroles

---@param _node ENode
---@param _name string
function EImage:init(_node, _name)
    UIManager.ENode.init(self, _node, _name)
    self._image_color = 0xffffff
    self._image_texture = -1
    self._transition_time = 0.0
end

function EImage:__get_image_color()
    return self._image_color
end

function EImage:__set_image_color(value)
    self._image_color = value
end

-- 更新图片颜色
function EImage:__update_image_color()
    if self.client_role then
        self.client_role.set_image_color(self._id, self._image_color, self._transition_time)
    else
        for _, role in ipairs(allroles) do
            role.set_image_color(self._id, self._image_color, self._transition_time)
        end
    end
end

function EImage:__get_image_texture()
    return self._image_texture
end

function EImage:__set_image_texture(value)
    self._image_texture = value
end

-- 更新图片预设
function EImage:__update_image_texture()
    if self.client_role then
        self.client_role.set_image_texture_by_key_with_auto_resize(self._id, self._image_texture, false)
    else
        for _, role in ipairs(allroles) do
            role.set_image_texture_by_key_with_auto_resize(self._id, self._image_texture, false)
        end
    end
end

function EImage:__get_transition_time()
    return self._transition_time
end

function EImage:__set_transition_time(value)
    self._transition_time = math.tofixed(value)
end

function EImage:reset_size()
    if self.client_role then
        self.client_role.set_image_texture_by_key_with_auto_resize(self._id, self._image_texture, true)
    else
        for _, role in ipairs(allroles) do
            role.set_image_texture_by_key_with_auto_resize(self._id, self._image_texture, true)
        end
    end
end

return EImage
