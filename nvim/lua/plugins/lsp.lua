return {
  {
    { "numToStr/Comment.nvim", opts = {}, lazy = false },
    -- add tsserver and setup with typescript.nvim instead of lspconfig
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "jose-elias-alvarez/typescript.nvim",
        init = function()
          require("lazyvim.util").lsp.on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
            vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
          end)
        end,
      },
      ---@class PluginLspOpts
      opts = {
        ---@type lspconfig.options
        -- you can do any additional lsp server setup here
        -- return true if you don't want this server to be setup with lspconfig
        ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
        -- setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
        -- },
        ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
        setup = {
          godot = function(_, opts)
            local lspconfig = require("lspconfig")
            lspconfig.gdscript.setup({})
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
              },
            }
          end,
          arduino_language_server = function(_, opts)
            local lspconfig = require("lspconfig")
            lspconfig.arduino_language_server.setup({
              cmd = {
                "arduino-language-server",
                "-cli-config",
                "/home/milan/.arduino15/arduino-cli.yaml",
                "-cli",
                "arduino-cli",
                "-clangd",
                "clangd",
                "-fqbn",
                "arduino:avr:uno",
              },
              --[[ root_dir = function(fname)
                -- P(vim.fn.expand "%:p:h")
                -- return vim.fn.expand "%:p:h"
                local root_files = { vim.fn.expand("%") }
                P(fname)
                P(root_files)
                local primary = lspconfig.util.root_pattern(unpack(root_files))(fname)
                P(primary)
                return primary
              end, ]]
              filetypes = { "arduino", "ino", "cpp", "c", "h" }, -- Add or adjust filetypes if needed
              root_dir = lspconfig.util.root_pattern("*.ino", "*.cpp"), -- You might need to tweak this
              -- root_dir = lspconfig.util.find_git_ancestor,
            })
          end,
        },
      },
    },

    -- for typescript, LazyVim also includes extra specs to properly setup lspconfig,
    -- treesitter, mason and typescript.nvim. So instead of the above, you can use:
    { import = "lazyvim.plugins.extras.lang.typescript" },
    -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
    { import = "lazyvim.plugins.extras.lang.json" },

    -- add more treesitter parsers
    {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        ensure_installed = {
          "bash",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "query",
          "regex",
          "tsx",
          "typescript",
          "vim",
          "yaml",
          "rust",
          "gdscript",
          "rust",
          "arduino_language_server",
        },
      },
    },

    -- since `vim.tbl_deep_extend`, can only merge tables and not lists, the code above
    -- would overwrite `ensure_installed` with the new value.
    -- If you'd rather extend the default config, use the code below instead:
    {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        -- add tsx and treesitter
        vim.list_extend(opts.ensure_installed, {
          "tsx",
          "typescript",
        })
      end,
    },

    -- add any tools you want to have installed below
    {
      "williamboman/mason.nvim",
      opts = {
        ensure_installed = {
          "stylua",
          "shellcheck",
          "shfmt",
          "flake8",
          "prettierd",
        },
      },
    },
  },
}
