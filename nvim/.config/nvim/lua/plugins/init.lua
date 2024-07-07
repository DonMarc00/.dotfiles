return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
  {
    "williamboman/mason.nvim",
    oopts = {
      ensure_installed = {
        "lua-language-server", "stylua",
        "html-lsp", "css-lsp", "prettier"
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css"
      },
    },
  },
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {}
    end,
  },
  { "startup-nvim/startup.nvim" }, 
{
    "github/copilot.vim",
    lazy = false,
    config = function()
      -- Optional configuration settings
      vim.g.copilot_no_tab_map = true
      vim.api.nvim_set_keymap("i", "<S-Right>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
    end,
  },
  {
  "jose-elias-alvarez/null-ls.nvim",
  config = function()
    require("null-ls").setup({
      sources = {
        require("null-ls").builtins.formatting.prettier,
        require("null-ls").builtins.formatting.black,
        -- add other formatters here
      },
    })
  end,
}, }
