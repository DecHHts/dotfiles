local opt = vim.opt

-- ============================
-- 十字光标（你要的核心需求）
-- ============================
opt.cursorline = true     -- 高亮光标所在行
opt.cursorcolumn = true   -- 高亮光标所在列
-- 两者叠加 = 十字光标指示效果

-- ============================
-- 行号
-- ============================
opt.number = true
opt.relativenumber = true  -- 相对行号，方便 j/k 跳转计数

-- ============================
-- 缩进（C/Verilog 常用 4 空格，可在 ft.lua 里对个别语言覆盖）
-- ============================
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true       -- Tab 转空格
opt.smartindent = true
opt.autoindent = true

-- ============================
-- 搜索
-- ============================
opt.ignorecase = true
opt.smartcase = true       -- 输入大写字母时自动区分大小写
opt.incsearch = true
opt.hlsearch = true

-- ============================
-- 界面显示
-- ============================
opt.termguicolors = true   -- 真彩色支持
opt.signcolumn = "yes"     -- 左侧固定留出提示符位置（避免报错时界面跳动）
opt.wrap = false           -- 不自动换行（写代码时更清晰）
opt.scrolloff = 8          -- 光标上下保留 8 行可视空间
opt.sidescrolloff = 8
opt.colorcolumn = "80"     -- 80 列参考线（C/Verilog 常见代码规范）

-- ============================
-- 文件处理
-- ============================
opt.swapfile = false
opt.backup = false
opt.undofile = true        -- 持久化撤销历史（重开文件也能撤销）
opt.undodir = vim.fn.expand("~/.config/nvim/undodir")

-- ============================
-- 分屏行为
-- ============================
opt.splitright = true      -- 垂直分屏在右侧打开
opt.splitbelow = true      -- 水平分屏在下方打开

-- ============================
-- 其他
-- ============================
opt.mouse = "a"             -- 支持鼠标操作
opt.clipboard = "unnamedplus" -- 与系统剪贴板共享
opt.updatetime = 250        -- 更快的补全/诊断响应
vim.g.mapleader = " "       -- Leader 键设为空格
