---@meta

error 'this file should not be execute'

---调试引擎
---@class UDbgEngine
local UDbgEngine = {}

---@class PsInfo
---@field pid integer
---@field name string
---@field path string
---@field wow64 boolean

---@return fun():PsInfo
function UDbgEngine:enum_process() end

---打开一个进程作为udbg目标，注意此目标不可调试
---
---open process as udbg target
---@param pid integer
---@return UDbgTarget
function UDbgEngine:open(pid) end

---附加正在运行的进程
---
---attach active process
---@param pid integer
---@return UDbgTarget
function UDbgEngine:attach(pid) end

---创建一个调试目标
---
---create udbg target
---@param path string @目标(进程路径) target process path
---@param cwd? string @目标子进程的工作目录里 CWD of subprocess
---@param args? string[] @目标子进程的命令行参数 shell arguments
---@return UDbgTarget
function UDbgEngine:create(path, cwd, args) end

---@class UDbgTarget
---@field pid integer
---@field psize integer
---@field arch string
---@field path string
---@field status string @readonly "idle" "opened" "attached" "paused" "running" "ended"
---@field image_base integer
UDbgTarget = {}

---load lua script from client by RPC
---@param name string
---@return string @full path of the script
---@return string @file content of the script
function _G.__loadremote(name) end

---enum module
---
---```lua
---for m in udbg.target:enum_module() do
---    log(hex(m.base), m.name, m.path)
---end
---```
---@return fun():UDbgModule
function UDbgTarget:enum_module() end

---获取线程列表
---
---get thread list
---@return UDbgThread[]
function UDbgTarget:thread_list() end

---打开指定的线程
---
---open a thread
---@param tid integer
---@return UDbgThread
function UDbgTarget:open_thread(tid) end

---获取模块对象，参数可以是模块基址或者模块名称
---
---get module instance
---@param arg string|integer @specify the module name or base address
---@return UDbgModule
function UDbgTarget:get_module(arg) end

---获取指定地址处的符号
---
---get symbol by address
---@param address integer
---@param detail? boolean
---@return string @若detail为false，返回一个字符串值，形式为 `模块名!函数名+偏移` `模块名+偏移`；若detail为true，返回四个值：module_name, symbol, offset, module_base
---@return string @symbol 符号名
---@return integer @offset 符号偏移 或 模块偏移(符号名为nil)
---@return integer @module_base 模块基址
function UDbgTarget:get_symbol(address, detail) end

---解析符号对应的地址，符号类似于windbg中的格式
---
---get address by symbol
---```lua
---assert(udbg.target:parse_address'kernel32!CreateFileW')
---assert(udbg.target:parse_address'ntdll' == udbg.target:get_module'ntdll'.base)
---```
---@param sym string @the symbol string
---@return integer?
function UDbgTarget:parse_address(sym) end

---获取断点对象列表
---
---get list of breakpoint
---@return UDbgBreakpoint[]
function UDbgTarget:breakpoint_list() end

---@return UDbgBreakpoint
function UDbgTarget:get_breakpoint(id) end

function UDbgTarget:add_breakpoint(address, bp_type, bp_size, temp, tid) end

---@class BpOption
---@field type string
---@field size integer
---@field enable boolean
---@field temp boolean
---@field tid integer
---@field auto boolean
---@field callback function

---add a breakpoint
---@param address integer|string
---@param opt function|BpOption
---@param arg3 BpOption
---@return UDbgBreakpoint|nil @bp object if success
---@return string? @error if failure
function UDbgTarget:add_bp(address, opt, arg3) end

---@class MemoryPage
---@field base integer
---@field size integer
---@field usage string
---@field alloc_base integer
---@field readonly boolean
---@field writable boolean
---@field executable boolean

---@class UiMemoryPage
---@field base integer
---@field alloc_base integer
---@field size integer
---@field usage string
---@field type string
---@field protect string

-- get list of memory page
---@return UiMemoryPage[]
function UDbgTarget:get_memory_map() end

-- enum memory page
---@return fun():MemoryPage
function UDbgTarget:enum_memory() end

-- enum process's handle
---@return fun():integer,integer,string,string @handle,type_index,type_name,name
function UDbgTarget:enum_handle(pid) end

---query virtual address
---@param address integer
---@return MemoryPage
function UDbgTarget:virtual_query(address) end

---读取以'0'结尾的C字符串
---
---read C string, terminated with '\0'
---@param address integer
---@param max_size? integer
---@return string?
function UDbgTarget:read_string(address, max_size) end

---读取以L'0'结尾的Unicode字符串，并转换成utf8字符串 (Windows ONLY)
---
---read unicode string, terminated with L'\0', and convert to utf8
---@param address integer
---@param max_size? integer
---@return string?
function UDbgTarget:read_wstring(address, max_size) end

---读取指定长度的二进制字节串
---
---read bytes
---@param address integer
---@param size integer
---@return string?
function UDbgTarget:read_bytes(address, size) end

---write bytes
---@param address integer
---@param bytes string|userdata
---@return boolean
function UDbgTarget:write_bytes(address, bytes) end

---写入一个C字符串，区别于write_bytes，总会在末尾处写入一个'\0'
---
---write c string, always write a '\0' in the end
---@param address integer
---@param str string|userdata
---@return boolean
function UDbgTarget:write_string(address, str) end

---写入一个unicode字符串，区别于write_bytes，总会在末尾处写入一个L'\0' (Windows ONLY)
---
---write unicode string, always write a L'\0' in the end
---@param address integer
---@param str string|userdata
---@return boolean
function UDbgTarget:write_string(address, str) end

function UDbgTarget:detect_return(pointer) end

function UDbgTarget:detect_string(pointer) end

---指定格式，一次读取多个数据，注意 目前暂不支持设置大小端和尺寸对齐
---
---read multiple value by pack format. NOTE: currently NOT support set endian and alignment
---```lua
---local fmt = 'I4fz'
---local a = udbg.target.image_base
---udbg.target:write_string(a, fmt:pack(10, 2.1, 'test'))
---local i, f, s = udbg.target:read_pack(a, fmt)
---assert(i == 10 and math.abs(f-2.1)<0.1 and s == 'test')
---```
---
---@param address integer
---@param fmt string @see [§6.4.2](command:extension.lua.doc?["en-us/54/manual.html/6.4.2"])
function UDbgTarget:read_pack(address, fmt) end

---UDbgTarget.eparam get the exception param
---@param i integer index
---@return  integer param valaue
function UDbgTarget:eparam(i) end

---detatch the target
function UDbgTarget:detach() end

---kill the target
function UDbgTarget:kill() end

---try pause the target
function UDbgTarget:pause() end

function UDbgTarget:do_cmd(cmd) end

---suspend the target
function UDbgTarget:suspend() end

---resume the target
function UDbgTarget:resume() end

---开始调试事件循环
---
---start debug event loop
---
---see `udbg/core.lua` `udbg.start`
---@return fun()
function UDbgTarget:loop_event() end

---@class UDbgBreakpoint
---@field address integer
---@field id integer
---@field type string|"'soft'"|"'table'"|"'hwbp'"
---@field hitcount integer
---@field enabled boolean
UDbgBreakpoint = {} do
    ---enable this breakpoint
    function UDbgBreakpoint:enable() end

    ---disable this breakpoint
    function UDbgBreakpoint:disable() end

    ---remove this breakpoint
    function UDbgBreakpoint:remove() end
end

---@class UDbgThread
---@field tid integer
---@field teb integer
---@field entry integer
---@field handle integer
---@field name string
---@field status string
---@field priority string
local UDbgThread = {} do
    ---suspend the thread
    ---@return integer @suspend count
    function UDbgThread:suspend() end

    ---resume the thread
    function UDbgThread:resume() end

    ---get the last error (Windows ONLY)
    ---@param target UDbgTarget
    ---@return integer?
    function UDbgThread:last_error(target) end
end

---@class UDbgModule
---@field base integer @模块基址
---@field size integer @模块大小
---@field name string @模块名称
---@field path string @模块路径
---@field arch OsArch @模块代码架构
---@field entry integer @RVA of entry point
---@field entry_point integer @address of entry point
local UDbgModule = {} do
    ---enum symbol in module
    ---@param name? string
    ---@return fun():Symbol
    function UDbgModule:enum_symbol(name) end

    ---enum the export symbol
    ---@param name? string
    ---@return fun():Symbol
    function UDbgModule:enum_export(name) end

    function UDbgModule:find_function(address) end

    ---get the `SymbolFile` of module
    ---@return SymbolFile?
    function UDbgModule:symbol_file() end

    ---get symbol info by name
    ---@param name string
    ---@return Symbol
    function UDbgModule:get_symbol(name) end

    ---add custome symbol for this module
    ---@param offset integer
    ---@param name string
    function UDbgModule:add_symbol(offset, name) end

    ---load symbol file for this module
    ---@param path string @pdb file path
    ---@return boolean success
    ---@return string? error
    function UDbgModule:load_symbol(path) end
end

---@class SymbolFile
local SymbolFile = {} do
    ---open symbol file (*.pdb)
    ---@param path string
    ---@return SymbolFile?
    function SymbolFile.open(path) end

    ---get type information
    ---@param id integer
    ---@return TypeInfo?
    function SymbolFile:get_type(id) end

    ---get type information
    ---@param name string
    ---@return TypeInfo[]
    function SymbolFile:find_type(name) end

    function SymbolFile:get_field(type_id) end

    function SymbolFile:enum_field(type_id) end
end

---@class Symbol
---@field name string @符号名称
---@field uname string @符号名称(已解码)
---@field offset integer @符号在模块里的偏移
---@field len integer @符号的长度，用于函数一类的符号
---@field flags integer
---@field type_id integer|nil
local Symbol = {}

---@class Capstone
_G.Capstone = {}

---new capstone instance
---@param arch string|"'x86'"|"'x86_64'"|"'arm'"|"'arm64'"
---@param mode? string|"'32'"|"'64'"|"'arm'"|"'thumb'"
---@return Capstone
function Capstone.new(arch, mode) end

---@class Insn
---@field string string
---@field mnemonic string

---@class InsnDetail
---@field groups integer
---@field read integer
---@field write integer
---@field prefix integer
---@field opcode integer

---disasm
---@param arg integer|string @address or binary
---@param a2? integer @address if arg is binary
function Capstone:disasm(arg, a2) end

---instruction's detail
---@param insn Insn
---@return InsnDetail
function Capstone:detail(insn) end

---@class Regs
---@field _pc integer 平台无关的PC寄存器的值 rip|eip
---@field _sp integer 平台无关的SP寄存器的值 rsp|esp
---* x64下可用寄存器：`rax` `rbx` `rcx` `rdx` `rsp` `rbp` `rip` `rsi` `rdi` `r8` .. `r15` `rflags` 浮点数(float)：`mm0` .. `mm7` 浮点数(double)：`xmm0` .. `xmm15`
---* x86下可用寄存器：`eax` `ebx` `ecx` `edx` `esp` `ebp` `eip` `esi` `edi` `eflags` 浮点数(float)：`mm0` .. `mm7` 浮点数(double)：`xmm0` .. `xmm15`
---* 还可用整数索引参数值，x64下 `reg[1] = reg.rcx` `reg[2] = reg.rdx` `reg[3] = reg.r8` `reg[4] = reg.r9`，其他整数 `reg[i] = qword(reg.rsp + i * 8)`；x86下 `reg[i] = dword(reg.esp + i * 4)`
_G.reg = {}
