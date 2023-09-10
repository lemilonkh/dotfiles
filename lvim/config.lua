-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

vim.opt.colorcolumn = "80"
-- vim.opt.cmdheight = 2         -- more space in the neovim command line for displaying messages
vim.opt.relativenumber = true -- relative line numbers
vim.opt.wrap = true           -- wrap lines

-- use treesitter folding
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.opt.foldlevelstart = 99

vim.api.nvim_create_user_command("Wq", "wq", { nargs = 0 })
vim.api.nvim_create_user_command("WQ", "wq", { nargs = 0 })
vim.api.nvim_create_user_command("Wa", "wa", { nargs = 0 })
vim.api.nvim_create_user_command("WA", "wa", { nargs = 0 })
vim.api.nvim_create_user_command("W", "w", { nargs = 0 })

-- plugins
lvim.plugins = {
  -- { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  -- { "rose-pine/neovim", name = "rose-pine" },
  { "morhetz/gruvbox", name = "gruvbox" },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({
            search = {
              mode = function(str)
                return "\\<" .. str
              end,
            },
          })
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Flash Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },
  { "norcalli/nvim-colorizer.lua" },
}

require 'colorizer'.setup()
-- Color scheme
-- require("catppuccin").setup({
--   flavor = "macchiato",
--   dim_inactive = {
--     enabled = true,
--     percentage = 0.15,
--   },
-- })
-- vim.cmd.colorscheme "catppuccin"
lvim.colorscheme = "gruvbox"
lvim.transparent_window = true

-- LSP
local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = {vim.api.nvim_buf_get_name(0)},
    title = ""
  }
  vim.lsp.buf.execute_command(params)
end

local lspconfig = require "lspconfig"
lspconfig.tsserver.setup {
  commands = {
    OrganizeImports = {
      organize_imports,
      description = "Organize Imports"
    }
  }
}

-- DAP configuration
lspconfig.gdscript.setup {}
local dap = require("dap")
dap.adapters.godot = {
  type = "server",
  host = "127.0.0.1",
  port = 6006,
}

dap.configurations.gdscript = {
  {
    type = "godot",
    request = "launch",
    name = "Launch scene",
    project = "${workspaceFolder}",
    launch_scene = true,
  }
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = "gd",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_global.expandtab = false
  end
})

-- transparent background
-- vim.api.nvim_command([[
--     augroup ChangeBackgroudColour
--         autocmd colorscheme * :hi normal guibg=None
--     augroup END
-- ]])
-- vim.o.termguicolors = true
-- vim.cmd [[silent! colorscheme snow]]

-- Function to check if a floating dialog exists and if not
-- then check for diagnostics under the cursor
function OpenDiagnosticIfNoFloat()
  for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_config(winid).zindex then
      return
    end
  end
  -- THIS IS FOR BUILTIN LSP
  vim.diagnostic.open_float({
    scope = "cursor",
    focusable = false,
    close_events = {
      "CursorMoved",
      "CursorMovedI",
      "BufHidden",
      "InsertCharPre",
      "WinLeave",
    },
  })
end

-- Show diagnostics under the cursor when holding position
vim.api.nvim_create_augroup("lsp_diagnostics_hold", { clear = true })
vim.api.nvim_create_autocmd({ "CursorHold" }, {
  pattern = "*",
  command = "lua OpenDiagnosticIfNoFloat()",
  group = "lsp_diagnostics_hold",
})

-- custom lvim commands in dashboard
local dashboard = require "alpha.themes.dashboard"
local function makeButton(...)
  local t = {...}
  table.insert(lvim.builtin.alpha.dashboard.section.buttons.entries, dashboard.button(unpack(t)))
end

-- makeButton("s", "  Open Last Session", "<cmd>lua require('persistence').load()<cr>")
-- makeButton("q", "  Quit NVIM", ":qa<CR>")

-- add extra bindings with leader-key prefix using which-key
lvim.builtin.which_key.mappings["l"]["o"] = { ":OrganizeImports<cr>", "Organize Imports" }

