# UI管理器

这是一个结合蛋仔派对界面的UI管理工具

你可以访问在线工具[UI管理器](http://www.eggycode.com/ui_manager)进行编辑

# 为何使用

使用本工具，你可以快速将每个UI控件单独封装，并可以使用简单的方法/属性修改游戏中界面的显示样式。

本工具同时还提供事件监听器，在界面中填写好的事件，可以快速通过本工具节点的on方法进行调用，每个监听器相互独立，可随时销毁。

# 快速开始
请将项目中的`UIManager`目录以及`ClassUtils.lua`放置于你的蛋仔Lua工程主目录中

接着在想要使用UI管理器，你需要在你的main文件中导入所需文件
```lua
require "UIManager.Utils"
```

## 重构UI数据

使用`Eggitor`插件将地图UI数据导出到`./Data/UINodes.lua`中。

接着在网站[UI管理器](http://www.eggycode.com/ui_manager)中，将`UINodes.lua`中的代码复制粘贴至网站的`或手动输入内容`文本域中，也可也手动将该文件拖动至`导入文件`下方区域中。

点击处理数据，接着下方会出现`预览`和`输出`，点击`输出`，接着我们点击下方的`复制到剪贴板`或者`下载文件`

## 导入UI数据

将下载的文件或复制的代码，粘贴/放置到你的自定义数据文件中，例如`./test_data.lua`。

## 构建UI管理器

做好以上工作后，现在你可以使用UI管理器构建UI节点了！
例如
```lua
require "UIManager.Utils"

local test_data = require "test_data"

LuaAPI.call_delay_frame(1, function()
    UIManager.Builder(test_data)
    --- 你可以使用 UIManager.query_nodes_by_name(_name: string) 获取对应名称的控件，注意，该方法会返回一个数组
    --- 除此之外，你也可以使用 UIManager.query_node_by_id(_id_: string) 获取对应类型的控件。
    --- 你可以使用 UIManager.typeof(_node: UIManager.ENodeUnion?, _type: T) 检查节点类型，这样你便可以轻松通过emmylua访问节点的方法
end)
```
# 常用API
| API                                                                                                                                         | 说明                                                                  |
| ------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| UIManager.query_nodes_by_name(_name: string): UIManager.ENodeUnion[]                                                                        | 通过名称查询节点                                                      |
| UIManager.query_node_by_id(_name: string): UIManager.ENodeUnion?                                                                            | 通过ID查询节点                                                        |
| ENode:get_first_node_by_name(name: string): UIManager.ENodeUnion?                                                                           | 根据名称查询子节点                                                    |
| ENode:get_first_node_by_name_dfs(name: string): UIManager.ENodeUnion?                                                                       | 根据名称查询子节点（深度优先）                                        |
| ENode:query_nodes_by_name(name: string): UIManager.ENodeUnion[]       \| {[1]: nil}                                                         | 根据名称查询子节点数组                                                |
| ENode:query_nodes_by_name_dfs(name: string): UIManager.ENodeUnion[] \| {[1]: nil}                                                           | 根据名称查询子节点数组（深度优先）                                    |
| ENode:for_all_roles(key: string, value: any)                                                                                                | 在事件回调中为每个玩家设置属性                                        |
| ENode:listen(_event: string, _callback fun(data: {role: Role, target: UIManager.ENode, listener: UIManager.Listener}) : UIManager.Listener) | 将指定事件委派到节点上，使得某个事件仅对该节点生效                    |
| ENode:trigger(role: Role, _event_name: string): UIManager.Promise<{role: Role, node: UIManager.ENodeUnion}>                                 | 以role的身份触发该节点的指定事件                                      |
| ENode:wait(_interval: integer): UIManager.Promise<ENode>                                                                                    | 内部等待一定帧数，返回一个Promise对象，支持链式调用                   |
| UIManager.Promise:wait(_interval: integer): UIManager.Promise<T>                                                                            | 内部等待一定帧数，返回一个Promise对象，支持链式调用                   |
| UIManager.Promise:done_then(_callback fun(e: T) : G): UIManager.Promise<G>                                                                  | 在上一节点完成之后立即执行回调函数，返回一个Promise对象，支持链式调用 |

# 示例代码


```lua
require "UIManager.Utils"
UIManager.Builder(require "test_data")

LuaAPI.call_delay_frame(1, function()
    x = UIManager.query_nodes_by_name("正方形")[1] --[[@as UIManager.EImage]]
    x
        :wait(30)
        :done_then(
            function(e)
                print(e)
                return { x = 123 }
            end)
        :wait(30)
        :done_then(
            function(e)
                return { y = e.x }
            end)
        :wait(30)
        :done_then(function(e)
            print(e)
        end)
end)

```


# 贡献

豆油汉堡