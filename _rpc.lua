---@meta

---代表一个RPC会话，可以向对方notify或者request
---@class RpcSession
local RpcSession = {}

---以通知的方式进行RPC调用
---@param method integer|string
---@vararg any @rpc method args
---@return boolean
function RpcSession:notify(method, ...) end

---以请求的方式进行RPC调用，等待回复
---@param method integer|string
---@vararg any @rpc method args
---@return any
function RpcSession:request(method, ...) end