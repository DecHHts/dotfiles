local augroup = vim.api.nvim_create_augroup("FileTypeSettings", {})

-- Verilog：习惯上用 2 空格缩进
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "verilog", "systemverilog" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- HTML：也常用 2 空格
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "html" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- .v 文件默认识别为 verilog（避免被误判为 coq 等其他语言）
vim.filetype.add({
  extension = {
    v = "verilog",
    sv = "systemverilog",
    vh = "verilog",
  },
})
