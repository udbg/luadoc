
---@module 'libffi'

error 'this file should not be execute'

local libffi = {}

---load a dynamic library
---@param name string
---@return userdata
function libffi.load(name) end

---create a FfiFunc without type
---@param fptr integer
---@return FfiFunc
---```lua
--- local msgbox = libffi.fn(libffi.C.GetProcAddress(libffi.C.GetModuleHandleA'user32', 'MessageBoxA'))
--- msgbox(0, 'text', 'title', 0)
---```
function libffi.fn(fptr) end

---create a FuncType or Func
---@param retype string @if arg is integer, return a Func without type info; if arg is string, the types must be provide, and return a FuncType
---@param argtype string[] @type of the c function arguments
---@return FuncType
---@overload fun(fptr: integer)
---```lua
--- local FnAdd = libffi.fn('int', {'int', 'int'})
---```
function libffi.fn(retype, argtype) end

---allocate a memory with specific size
---@param size integer
---@return userdata
function libffi.malloc(size) end

---allocate a memory with specific size, type
---@param size integer
---@param type? string
---@return userdata
function libffi.mem(size, type) end

---read pack
---@param ptr integer|userdata
---@param fmt string @see string.unpack
--@return ...
function libffi.read_pack(ptr, fmt) end

---write type
---@param ptr integer|userdata
---@param fmt string @see string.pack
---@param val any
function libffi.write_pack(ptr, fmt, val) end

---read bytes from memory directly (lua_pushlstring)
---@param ptr integer|userdata
---@param size integer
---@return userdata
function libffi.read(ptr, size) end

---write bytes to memory directly (memcpy)
---@param ptr integer|userdata
---@param size? integer
---@return string
function libffi.write(ptr, size) end

---fill memory with value (memset)
---@param ptr integer|userdata
---@param size integer
---@param val? integer
---@return string
function libffi.fill(ptr, size, val) end

---read a c-string from memory directly (lua_pushstring)
---@param ptr integer|userdata
---@param size? integer
---@return string
function libffi.string(ptr, size) end

return libffi