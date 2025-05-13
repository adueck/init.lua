vim.keymap.set('n', '<SPACE>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.relativenumber = true
vim.opt.syntax = 'on'
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.scroll = 5
vim.opt.scrolloff = 2
vim.opt.termbidi = true

require "paq" {
  "savq/paq-nvim", -- let paq manage itself
  "tpope/vim-surround",
  "rmagatti/auto-session",
  "tpope/vim-commentary",
  "tpope/vim-repeat",
  "vim-test/vim-test",
  "shaunsingh/nord.nvim",
  "navarasu/onedark.nvim",
  "airblade/vim-gitgutter",
  "BurntSushi/ripgrep",
  "nvim-telescope/telescope.nvim",
  "sharkdp/fd",
  -- "ribru17/bamboo.nvim",
  "nvim-lualine/lualine.nvim",
  "nvim-neo-tree/neo-tree.nvim",
  "nvim-lua/plenary.nvim",
  "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
  "MunifTanjim/nui.nvim",
  { "nvim-treesitter/nvim-treesitter", build = ":tsupdate" },
  "nvim-treesitter/nvim-treesitter-textobjects",
  "neovim/nvim-lspconfig",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "mason-org/mason.nvim",
  "mason-org/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  "stevearc/conform.nvim",
}

require 'nvim-treesitter.configs'.setup {
  ensure_installed = { 'bash', 'css', 'html', 'javascript', 'json', 'jsonc', 'lua', 'rust', 'typescript', 'haskell', 'racket' },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<cr>", -- set to `false` to disable one of the mappings
      node_incremental = "<cr>",
      scope_incremental = "<tab>",
      node_decremental = "<s-tab>",
    },
  },
  textobjects = {
    select = {
      enable = true,

      -- automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- you can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        -- you can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
        -- you can also use captures from other query groups like `locals.scm`
        ["as"] = { query = "@local.scope", query_group = "locals", desc = "select language scope" },
      },
      -- you can choose the select mode (default is charwise 'v')
      --
      -- can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'v', or '<k>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'v',  -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },
      -- if you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true or false
      include_surrounding_whitespace = false,
    },
  },
}

require('lualine').setup()
require('onedark').setup {
  style = 'warm'
}
-- require('bamboo').load()
-- require('bamboo').setup {
--   style = "multiplex"
-- }
require('onedark').load()


-- lsp zero
-- reserve a space in the gutter
vim.opt.signcolumn = 'yes'

-- add cmp_nvim_lsp capabilities settings to lspconfig
-- this should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- this is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('lspattach', {
  desc = 'lsp actions',
  callback = function(event)
    local opts = { buffer = event.buf }

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gI', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<f2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({ 'n', 'x' }, '<f3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<f4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end,
})

-- you'll find a list of language servers here:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
-- these are example language servers.
require('lspconfig').ts_ls.setup({})
require('lspconfig').lua_ls.setup({})
require('lspconfig').hls.setup({})

local cmp = require('cmp')


cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
  },
  snippet = {
    expand = function(args)
      -- you need neovim v0.10 to use vim.snippet
      vim.snippet.expand(args.body)
    end,
  },

  mapping = cmp.mapping.preset.insert({
    ["<cr>"] = cmp.mapping.confirm({ select = true }),
    -- ["<c-space>"] = cmp.mapping.complete(),
  }),
})

vim.diagnostic.config({ update_in_insert = true })

require("mason").setup()
require("neo-tree").setup({
  close_if_last_window = true,
})
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    -- conform will run multiple formatters sequentially
    -- conform will run the first available formatter
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
  },
  format_on_save = {
    -- these options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>t', ':Neotree toggle<cr>', { noremap = true, silent = true })
