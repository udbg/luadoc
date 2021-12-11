---@meta
-- 新增的库函数接口的字符串的参数，都是**utf8**编码，给udbg执行的lua脚本也都推荐用utf8编码

error 'this file should not be execute'

---@type integer @pointer width, in bytes
__llua_psize = 8
---@type function? @error function used by thread.spawn() / libffi closure callback
__llua_error = nil

---@alias OsArch string | "'x86'" | "'x86_64'" | "'arm'" | "'aarch64'" | "'mips'" | "'mips64'" | "'powerpc'" | "'powerpc64'" | "'riscv64'" | "'s390x'" | "'sparc64'"

---@type string | "'linux'" | "'macos'" | "'ios'" | "'freebsd'" | "'dragonfly'" | "'netbsd'" | "'openbsd'" | "'solaris'" | "'android'" | "'windows'"
os.name = ''
---@type OsArch
os.arch = ''
---@type string | "'windows'" | "'unix'"
os.family = ''
---@type string | "'dll'" | "'so'" | "'dylib'"
os.dllextension = ''
---@type integer @pointer width, in bytes
os.pointersize = 8

---获取脚本所在的文件路径
---
---get the script path
---@return string
function __file__() end

---read a file
---@param path string @utf8 encoding
---@return string @data bytes
function readfile(path) end

---write file
---@param path string @utf8 encoding
---@param data string @data bytes
function writefile(path, data) end

---os library extension
do
    ---使用通配符枚举文件
    ---
    ---enum path by wildcard
    ---
    ---```lua
    ---for path in os.glob [[C:\Windows\*.exe]] do
    ---    log(path)
    ---end
    ---```
    ---@param wildcard string
    ---@return fun():string
    function os.glob(wildcard) end

    ---获取进程的可执行文件路径
    ---
    ---get the executing program's path
    ---@return string
    function os.getexe() end

    ---获取当前工作目录
    ---
    ---get current working directory
    ---@return string
    function os.getcwd() end

    function os.chdir(dir) end

    function os.env(var) end

    function os.putenv(var, val) end

    function os.mkdir(path) end

    function os.rmdir(dir) end

    ---递归创建目录
    ---
    ---make directory recursively
    ---@param path string
    function os.mkdirs(path) end

    ---@alias Stdio string|"'pipe'"|"'inherit'"|"'null'"
    ---@alias ReadArg integer|"'*'"|"'*a'"

    ---create a [command](https://doc.rust-lang.org/std/process/struct.Command.html)
    ---@param arg string|{cwd: string, stdout?: Stdio, stderr?: Stdio, stdin?: Stdio, env?: string[]}
    ---@return Command
    function os.command(arg) end

    ---@class Command @https://doc.rust-lang.org/std/process/struct.Command.html
    local Command = {}

    ---spawn the command as a child process
    ---@return Child
    function Command:spawn() end

    ---@class Child @https://doc.rust-lang.org/std/process/struct.Child.html
    local Child = {}

    ---get the pid of child process
    function Child:id() end

    ---kill the child
    function Child:kill() end

    ---waits for the child to exit completely
    function Child:wait() end

    function Child:try_wait() end

    ---read the stdout
    ---@param n ReadArg
    function Child:read(n) end

    ---read the stderr
    ---@param n ReadArg
    function Child:read_error(n) end

    ---write data to stdin
    ---@param data string
    function Child:write(data) end
end

---类似python中os.path.*的路径操作功能
---
---path utility like python
os.path = {} do
    ---get the directory of path
    ---@param path string
    ---@return string?
    function os.path.dirname(path) end

    ---detect if a path is exists
    ---@param path string
    ---@return boolean
    function os.path.exists(path) end

    ---get the absolute path
    ---@param path string
    ---@return string
    function os.path.abspath(path) end

    function os.path.basename(path) end

    ---split extension name
    ---@param path string
    ---@return string,string
    function os.path.splitext(path) end

    ---set path extension to @ext
    ---@param path string
    ---@param ext string
    ---@return string
    function os.path.withext(path, ext) end

    function os.path.withname(path, name) end

    function os.path.join(dir, ...) end

    function os.path.isabs(path) end

    function os.path.isdir(path) end

    function os.path.isfile(path) end

    function os.path.meta(path) end
end

---string library extension
do
    ---convert utf8 string to utf16(le)
    ---@param utf8 string @utf8 encoding
    ---@return string @utf16 encoding
    function string.to_utf16(utf8) end

    ---convert utf16 string to utf8
    ---@param utf16 string @utf16 encoding
    ---@return string @utf8 encoding
    function string.from_utf16(utf16) end

    ---比较字符串，默认不区分大小写
    ---
    ---compare two strings with optional case_sensitive
    ---@param t1 string
    ---@param t2 string
    ---@param case_sensitive? boolean @default is false
    ---@return boolean
    function string.equal(t1, t2, case_sensitive) end

    ---通配符匹配字符串，默认不区分大小写
    ---
    ---if s matches the wildcard
    ---```lua
    ---local s = 'C:/abc.txt'
    ---assert(s:wildmatch '*abc.txt')
    ---```
    ---@param s string
    ---@param pattern string @the wildcard string
    ---@param case_sensitive? boolean @default is false
    ---@return boolean
    function string.wildmatch(s, pattern, case_sensitive) end
end

---多线程库
---
---llua's system thread library
_G.thread = {} do
    ---spawn a thread with specific lua function
    ---@param fn function
    ---@param name? string
    ---@return LLuaThread
    function thread.spawn(fn, name) end

    ---sleep in current thread
    ---@param ms integer
    function thread.sleep(ms) end

    ---get current thread id
    ---@return integer
    function thread.id() end

    ---get current thread name
    ---@return string
    function thread.name() end

    ---https://doc.rust-lang.org/std/thread/fn.park.html
    function thread.park() end

    ---https://doc.rust-lang.org/std/thread/fn.yield_now.html
    function thread.yield_now() end

    ---创建一个条件变量
    ---
    ---create a conditional variable
    ---@return LLuaCondvar
    function thread.condvar() end

    ---@class LLuaCondvar
    local condvar = {} do
        ---https://doc.rust-lang.org/std/sync/struct.Condvar.html#method.notify_one
        ---@param val any
        function condvar:notify_one(val) end

        ---https://doc.rust-lang.org/std/sync/struct.Condvar.html#method.notify_all
        ---@param val any
        function condvar:notify_all(val) end

        ---wait the conditional variable
        ---@param timeout? integer @milliseconds
        function condvar:wait(timeout) end
    end

    ---@see https://doc.rust-lang.org/std/thread/struct.Thread.html
    ---@class LLuaThread
    ---@field name string
    ---@field id integer
    ---@field handle integer
    local LLuaThread = {}

    ---waits for the associated thread to finish  
    ---https://doc.rust-lang.org/std/thread/struct.JoinHandle.html#method.join
    function LLuaThread:join() end

    ---Atomically makes the handle’s token available if it is not already  
    ---https://doc.rust-lang.org/std/thread/struct.Thread.html#method.unpark
    function LLuaThread:unpark() end
end