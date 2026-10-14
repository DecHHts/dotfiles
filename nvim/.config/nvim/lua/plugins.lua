-- 自动安装 lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- ============================
  -- 配色方案
  -- ============================
{
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      style = "night",
      on_colors = function(c)
        c.bg = "#0d1117"        -- Ayu 风格的近黑背景，和 Ghostty 一致
        c.bg_dark = "#0a0d12"   -- 侧边栏、浮窗
      end,
    })
    vim.cmd.colorscheme("tokyonight-night")
  end,
},

  -- ============================
  -- 语法高亮（Treesitter，对 Verilog/C 支持很好）
  -- ============================
{
  "nvim-treesitter/nvim-treesitter",
  branch = "master",   -- 锁定旧稳定分支，避免用到重写后的 main 分支
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "c", "cpp", "verilog", "python", "html", "css", "lua", "vim" },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
},

  -- ============================
  -- LSP 配置（代码跳转、补全、报错提示）
  -- ============================
{
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = { "clangd", "pyright", "html", "svlangserver" },
    })

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- 新版 API：用 vim.lsp.config 定义每个 server 的配置
    vim.lsp.config("clangd", { capabilities = capabilities })
    vim.lsp.config("pyright", { capabilities = capabilities })
    vim.lsp.config("html", { capabilities = capabilities })
    vim.lsp.config("svlangserver", { capabilities = capabilities })

    -- 启用这些 server（取代原来逐个 .setup()）
    vim.lsp.enable({ "clangd", "pyright", "html", "svlangserver" })

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
      end,
    })
  end,
},


  -- ============================
  -- 自动补全
  -- ============================
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args) require("luasnip").lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        },
      })
    end,
  },

  -- ============================
  -- 文件树
  -- ============================
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
    end,
  },

  -- ============================
  -- 模糊查找
  -- ============================
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files)
      vim.keymap.set("n", "<leader>fg", builtin.live_grep)
      vim.keymap.set("n", "<leader>fb", builtin.buffers)
    end,
  },

  -- ============================
  -- 状态栏
  -- ============================
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({ options = { theme = "catppuccin" } })
    end,
  },

  -- ============================
  -- Git 集成（左侧显示改动标记）
  -- ============================
  { "lewis6991/gitsigns.nvim", config = true },

  -- ============================
  -- 自动括号/引号配对
  -- ============================
  { "windwp/nvim-autopairs", config = true },

  -- ============================
  -- 注释快捷键（gcc 注释当前行）
  -- ============================
  { "numToStr/Comment.nvim", config = true },
})
