local map = vim.keymap.set

-- 保存 / 退出
map("n", "<leader>w", ":w<CR>", { desc = "保存文件" })
map("n", "<leader>q", ":q<CR>", { desc = "退出" })

-- 窗口分屏导航（Ctrl+方向键切换分屏）
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- 取消搜索高亮
map("n", "<leader>h", ":nohlsearch<CR>", { desc = "清除搜索高亮" })

-- 更方便的行移动（可视模式下整行上下移）
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- 保持光标居中的翻页/搜索
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
