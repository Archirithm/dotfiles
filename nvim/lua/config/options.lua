
vim.opt.number = true           -- 显示绝对行号
vim.opt.relativenumber = false  -- 关闭相对行号 (按需开启)
vim.opt.expandtab = true        -- 将 Tab 转换为空格
vim.opt.shiftwidth = 4          -- 缩进为 4 个空格 (适合 C++/Python)
vim.opt.tabstop = 4             -- Tab 键等同于 4 个空格
vim.opt.smartindent = true      -- 开启智能缩进

vim.opt.termguicolors = true    -- 开启 24 位真色彩 (Kitty 完美支持)
vim.opt.swapfile = false        -- 关闭烦人的 .swp 交换文件
vim.opt.mouse = "a"             -- 允许使用鼠标
vim.opt.laststatus = 3          -- 全局唯一底部状态栏
vim.opt.clipboard = "unnamedplus" -- 允许 Neovim 与系统剪贴板互通 (极其重要)

vim.opt.formatoptions:remove({ "c", "r", "o" }) -- 禁止换行时自动延续注释
vim.opt.cursorline = true                       -- 开启光标行提示
vim.opt.cursorlineopt = "number"                -- 仅高亮行号部分
vim.opt.iskeyword:append("-")                   -- 把包含中划线的词语视为一个整体
vim.o.whichwrap = vim.o.whichwrap .. "<>,h,l"   -- 允许左右键跨行移动
vim.opt.wrap = false                            -- 关闭自动换行 (长代码超出窗口边缘时直接隐藏)

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- 设置 Neovim 启动和打开文件时，默认不折叠任何代码
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- vim.opt.foldcolumn = "1"

vim.opt.undofile = true

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "取消搜索高亮" })
