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
  -- { "wuelnerdotexe/vim-astro" },
  { "rose-pine/neovim",           name = "rose-pine" },
  { "morhetz/gruvbox",            name = "gruvbox" },
  { "norcalli/nvim-colorizer.lua" },
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {
      bind = true,
      handler_opts = {
        border = "rounded"
      },
    },
    config = function(_, opts) require "lsp_signature".setup(opts) end
  },
  { "nvim-lua/plenary.nvim" },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    -- requires = {{ "nvim-lua/plenary.nvim" }}
    config = function()
      local harpoon = require("harpoon");
      harpoon:setup()

      -- lvim.builtin.which_key.mappings["a"] = { function() harpoon:list():append() end, "Add to Harpoon" }
      -- lvim.builtin.which_key.mappings["t"] = { function()  end, "Add to Harpoon" }
      vim.keymap.set("n", "<C-a>", function() harpoon:list():append() end)
      vim.keymap.set("n", "<C-t>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
      vim.keymap.set("n", "<C-x>", function() harpoon:list():select(1) end)
      vim.keymap.set("n", "<C-c>", function() harpoon:list():select(2) end)
      vim.keymap.set("n", "<C-v>", function() harpoon:list():select(3) end)
      vim.keymap.set("n", "<C-b>", function() harpoon:list():select(4) end)
    end,
  },
  -- godot
  {
    "habamax/vim-godot",
    event = "BufEnter *.gd",
    config = function()
      local null_ls = require("null-ls")
      null_ls.register({
        null_ls.builtins.formatting.gdformat,
      })
      vim.cmd([[
        setlocal foldmethod=expr
        setlocal tabstop=4
        setlocal shiftwidth=4
        setlocal indentexpr=
      ]])
    end,
  },
  -- rust
  {
    "simrat39/rust-tools.nvim",
    config = function()
      -- local lsp_installer_servers = require("nvim-lsp-installer.servers")
      -- local _, requested_server = lsp_installer_servers.get_server("rust_analyzer")
      require("rust-tools").setup({
        tools = {
          autoSetHints = true,
          -- hover_with_actions = true,
          -- options same as lsp hover / vim.lsp.util.open_floating_preview()
          hover_actions = {

            -- the border that is used for the hover window
            -- see vim.api.nvim_open_win()
            border = {
              { "╭", "FloatBorder" },
              { "─", "FloatBorder" },
              { "╮", "FloatBorder" },
              { "│", "FloatBorder" },
              { "╯", "FloatBorder" },
              { "─", "FloatBorder" },
              { "╰", "FloatBorder" },
              { "│", "FloatBorder" },
            },

            -- whether the hover action window gets automatically focused
            -- default: false
            auto_focus = true,
          },
          runnables = {
            use_telescope = true,
          },
        },
        server = {
          on_init = require("lvim.lsp").common_on_init,
          on_attach = function(client, bufnr)
            require("lvim.lsp").common_on_attach(client, bufnr)
            local rt = require("rust-tools")
            -- Hover actions
            vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            vim.keymap.set("n", "<leader>lA", rt.code_action_group.code_action_group, { buffer = bufnr })
          end,
        },
      })
    end,
    ft = { "rust", "rs" },
  },
  {
    "saecki/crates.nvim",
    version = "v0.3.0",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("crates").setup {
        null_ls = {
          enabled = true,
          name = "crates.nvim",
        },
        popup = {
          border = "rounded",
        },
      }
    end,
  },
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()
    end,
  },
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
lvim.colorscheme = "rose-pine"
lvim.transparent_window = true

-- lualine
-- local function searchCount()
--   local search = vim.fn.searchcount({ maxcount = 0 }) -- maxcount = 0 disables cap at 99
--   if search.current > 0 then
--     return "/" .. vim.fn.getreg("/") .. " [" .. search.current .. "/" .. search.total .. "]"
--   else
--     return ""
--   end
-- end

-- lvim.builtin.lualine.options.theme = "material"
-- table.insert(lvim.builtin.lualine.sections.lualine_x, { searchCount })
lvim.builtin.lualine.options.section_separators = { left = "", right = "" }
lvim.builtin.lualine.options.component_separators = { left = "", right = "" }

-- LSP
local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
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

-- TypeScript stuff
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "eslint", filetypes = { "typescript", "typescriptreact" } }
-- }
lspconfig.eslint.setup {
  settings = {
    codeAction = {
      disableRuleComment = { enable = true }
    }
  }
}
-- lspconfig.prettier.setup {}

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    command = "prettier",
    filetypes = { "typescript", "typescriptreact", "javascript", "astro" },
  },
  { command = "rustfmt", filetypes = { "rust" } }
}

require("lvim.lsp.manager").setup "tailwindcss"

lspconfig.astro.setup {
  init_options = {
    typescript = {
      tsdk = vim.fs.normalize '~/.local/share/pnpm/global/5/node_modules/typescript/lib',
    },
  },
}
-- vim.g.astro_typescript = 'enable'

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
-- local dashboard = require "alpha.themes.dashboard"
-- local function makeButton(...)
--   local t = { ... }
--   table.insert(lvim.builtin.alpha.dashboard.section.buttons.entries, dashboard.button(unpack(t)))
-- end

-- makeButton("s", "  Open Last Session", "<cmd>lua require('persistence').load()<cr>")
-- makeButton("q", "  Quit NVIM", ":qa<CR>")

-- add extra bindings with leader-key prefix using which-key
lvim.builtin.which_key.mappings["l"]["o"] = { ":OrganizeImports<cr>", "Organize Imports" }
lvim.builtin.which_key.mappings["b"]["p"] = { ":bp", "Previous" }

-- access docs of current token via gk
lvim.lsp.buffer_mappings.normal_mode['gk'] = lvim.lsp.buffer_mappings.normal_mode['K']

-- Rust support
-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "lua",
  "rust",
  "toml",
}

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "rust_analyzer" })

local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")

local codelldb_path = mason_path .. "bin/codelldb"
local liblldb_path = mason_path .. "packages/codelldb/extension/lldb/lib/liblldb"
local this_os = vim.loop.os_uname().sysname

-- The path in windows is different
if this_os:find "Windows" then
  codelldb_path = mason_path .. "packages\\codelldb\\extension\\adapter\\codelldb.exe"
  liblldb_path = mason_path .. "packages\\codelldb\\extension\\lldb\\bin\\liblldb.dll"
else
  -- The liblldb extension is .so for linux and .dylib for macOS
  liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
end

pcall(function()
  require("rust-tools").setup {
    tools = {
      executor = require("rust-tools/executors").termopen, -- can be quickfix or termopen
      reload_workspace_from_cargo_toml = true,
      runnables = {
        use_telescope = true,
      },
      inlay_hints = {
        auto = true,
        only_current_line = false,
        show_parameter_hints = false,
        parameter_hints_prefix = "<-",
        other_hints_prefix = "=>",
        max_len_align = false,
        max_len_align_padding = 1,
        right_align = false,
        right_align_padding = 7,
        highlight = "Comment",
      },
      hover_actions = {
        border = "rounded",
      },
      on_initialized = function()
        vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, {
          pattern = { "*.rs" },
          callback = function()
            local _, _ = pcall(vim.lsp.codelens.refresh)
          end,
        })
      end,
    },
    dap = {
      -- adapter= codelldb_adapter,
      adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
    },
    server = {
      on_attach = function(client, bufnr)
        require("lvim.lsp").common_on_attach(client, bufnr)
        local rt = require "rust-tools"
        vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
      end,

      capabilities = require("lvim.lsp").common_capabilities(),
      settings = {
        ["rust-analyzer"] = {
          lens = {
            enable = true,
          },
          checkOnSave = {
            enable = true,
            command = "clippy",
          },
          procMacro = {
            ignored = {
              leptos_macro = {
                -- optional in case of issues
                -- "component",
                "server",
              }
            }
          }
        },
      },
    },
  }
end)

lvim.builtin.dap.on_config_done = function(dap)
  dap.adapters.codelldb = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
  dap.configurations.rust = {
    {
      name = "Launch file",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
    },
  }
end

vim.api.nvim_set_keymap("n", "<m-d>", "<cmd>RustOpenExternalDocs<Cr>", { noremap = true, silent = true })

lvim.builtin.which_key.mappings["C"] = {
  name = "Rust",
  r = { "<cmd>RustRunnables<Cr>", "Runnables" },
  t = { "<cmd>lua _CARGO_TEST()<cr>", "Cargo Test" },
  m = { "<cmd>RustExpandMacro<Cr>", "Expand Macro" },
  c = { "<cmd>RustOpenCargo<Cr>", "Open Cargo" },
  p = { "<cmd>RustParentModule<Cr>", "Parent Module" },
  d = { "<cmd>RustDebuggables<Cr>", "Debuggables" },
  v = { "<cmd>RustViewCrateGraph<Cr>", "View Crate Graph" },
  R = {
    "<cmd>lua require('rust-tools/workspace_refresh')._reload_workspace_from_cargo_toml()<Cr>",
    "Reload Workspace",
  },
  o = { "<cmd>RustOpenExternalDocs<Cr>", "Open External Docs" },
  y = { "<cmd>lua require'crates'.open_repository()<cr>", "[crates] open repository" },
  P = { "<cmd>lua require'crates'.show_popup()<cr>", "[crates] show popup" },
  i = { "<cmd>lua require'crates'.show_crate_popup()<cr>", "[crates] show info" },
  f = { "<cmd>lua require'crates'.show_features_popup()<cr>", "[crates] show features" },
  D = { "<cmd>lua require'crates'.show_dependencies_popup()<cr>", "[crates] show dependencies" },
}
