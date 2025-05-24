vim.keymap.set('n', '<SPACE>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.relativenumber = true
vim.opt.syntax = 'on'
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.scroll = 5
vim.opt.scrolloff = 2
vim.opt.wrap = false
vim.opt.termbidi = true

require "paq" {
  "savq/paq-nvim", -- let paq manage itself
  "tpope/vim-surround",
  "m4xshen/autoclose.nvim",
  "chrisgrieser/nvim-various-textobjs",
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  "abecodes/tabout.nvim",
  "rmagatti/auto-session",
  "tpope/vim-commentary",
  "tpope/vim-repeat",
  "vim-test/vim-test",
  "airblade/vim-gitgutter",
  "BurntSushi/ripgrep",
  "nvim-telescope/telescope.nvim",
  "sharkdp/fd",
  "nvim-lualine/lualine.nvim",
  "nvim-neo-tree/neo-tree.nvim",
  "nvim-lua/plenary.nvim",
  "nvim-tree/nvim-web-devicons",
  "MunifTanjim/nui.nvim",
  { "nvim-treesitter/nvim-treesitter", build = ":tsupdate" },
  "nvim-treesitter/nvim-treesitter-textobjects",
  "neovim/nvim-lspconfig",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "VonHeikemen/lsp-zero.nvim",
  "mason-org/mason.nvim",
  "mason-org/mason-lspconfig.nvim",
  "stevearc/conform.nvim",
  "artemave/workspace-diagnostics.nvim",
  -- theme
  "Mofiqul/vscode.nvim",

}

require 'nvim-treesitter.configs'.setup {
  ensure_installed = { 'bash', 'css', 'html', 'javascript', 'json', 'jsonc', 'lua', 'rust', 'typescript', 'haskell', 'racket' },

  highlight = {
    enable = true,
  },
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
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
        ["<leader>n"] = "@statement.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
        ["<leader>N"] = "@statement.inner",
      },
    },
    select = {
      enable = true,

      -- automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- you can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["aa"] = "@parameter.outer",
        ["an"] = "@statement.outer",
        ["in"] = "@statement.inner",
        -- you can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
        -- you can also use captures from other query groups like `locals.scm`
        -- ["as"] = { query = "@local.scope", query_group = "locals", desc = "select language scope" },
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
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]n"] = "@statement.outer",
        ["]]"] = { query = "@class.outer", desc = "Next class start" },
        --
        -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
        ["]o"] = "@loop.*",
        -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
        --
        -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
        -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
        ["]s"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
        ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[n"] = "@statement.outer",
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
}

vim.keymap.set({ "o", "x" }, "aS", '<cmd>lua require("various-textobjs").subword("outer")<CR>')
vim.keymap.set({ "o", "x" }, "iS", '<cmd>lua require("various-textobjs").subword("inner")<CR>')
vim.keymap.set({ "o", "x" }, "am", '<cmd>lua require("various-textobjs").chainMember("outer")<CR>')
vim.keymap.set({ "o", "x" }, "im", '<cmd>lua require("various-textobjs").chainMember("inner")<CR>')

local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
-- Repeat movement with ; and ,
-- ensure ; goes forward and , goes backward regardless of the last direction
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

-- vim way: ; goes to the direction you were moving.
-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

require('lualine').setup()

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
    ["<tab>"] = cmp.mapping.confirm({ select = true }),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    -- ["<c-space>"] = cmp.mapping.complete(),
  }),
})

vim.diagnostic.config({ update_in_insert = true })

require("mason").setup()
require("neo-tree").setup({
  close_if_last_window = true,
  auto_restore_session_experimental = true,
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
require("auto-session").setup({
  suppressed_dirs = { "~/", "~/Code", "~/Downloads", "/" },
  -- to solve conflict between neo-tree and auto-session
  pre_save_cmds = { "tabdo Neotree close" },
  post_restore_cmds = { "Neotree" }
});

require("workspace-diagnostics").setup({})

local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
end)

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

require("autoclose").setup({})
require("tabout").setup({})

vim.o.background = 'dark'
local c = require('vscode.colors').get_colors()
require('vscode').setup({
  -- Alternatively set style in setup
  -- style = 'light'

  -- Enable transparent background
  transparent = false,

  -- Enable italic comment
  italic_comments = true,

  -- Underline `@markup.link.*` variants
  underline_links = true,

  -- Disable nvim-tree background color
  disable_nvimtree_bg = true,

  -- Apply theme colors to terminal
  terminal_colors = true,

  -- Override colors (see ./lua/vscode/colors.lua)
  -- color_overrides = {
  --     vscLineNumber = '#FFFFFF',
  -- },

  -- -- Override highlight groups (see ./lua/vscode/theme.lua)
  -- group_overrides = {
  --     -- this supports the same val table as vim.api.nvim_set_hl
  --     -- use colors from this colorscheme by requiring vscode.colors!
  --     Cursor = { fg=c.vscDarkBlue, bg=c.vscLightGreen, bold=true },
  -- }
})
vim.cmd.colorscheme "vscode"

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>tf', ':TestFile<CR>', { desc = 'Test file' })
vim.keymap.set('n', '<leader>tn', ':TestNearest<CR>', { desc = 'Run nearest test to cursor' })
vim.keymap.set('n', '<leader>ts', ':TestSuite<CR>', { desc = 'Run full test suite' })
vim.keymap.set('n', '<leader>tl', ':TestLast<CR>', { desc = 'Run the last test' })

vim.keymap.set('n', '<leader>b', ':ls<CR>:buffer ', { desc = 'select buffer' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>c', ':Neotree toggle<cr>', { noremap = true, silent = true })
