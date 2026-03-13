return {
  -- 1. Mason Core
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({ ui = { border = "rounded" } })
    end,
  },

  -- 2. Mason-LSP Bridge
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "clangd", "ts_ls", "gopls" },
      })
    end,
  },

  -- 3. Autocompletion & Snippets
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        performance = { max_view_entries = 5, },
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })
    end,
  },

    -- 4. LSP Config (Modern Native 0.11+ Style)
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      -- 1. Setup our on_attach function
      local on_attach = function(client, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }

        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, opts)

        -- Telescope-powered navigation
        local ok, builtin = pcall(require, "telescope.builtin")
        if ok then
          vim.keymap.set("n", "gd", builtin.lsp_definitions, opts)
          vim.keymap.set("n", "gr", builtin.lsp_references, opts)
          vim.keymap.set("n", "gi", builtin.lsp_implementations, opts)
          vim.keymap.set("n", "<leader>ds", builtin.lsp_document_symbols, opts)
          vim.keymap.set("n", "<leader>ws", builtin.lsp_workspace_symbols, opts)
        end
      end
      -- 2. Capabilities for autocompletion
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- 3. Use the NEW native way to avoid the deprecation warning
      -- We define a table of servers and their specific configs
      local servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=never",
            "--fallback-style=llvm"
          },
          -- This tells it exactly where your project root is
          root_markers = { ".git", ".clangd", "Makefile", "compile_commands.json" },
        },
        pyright = {},
        ts_ls = {},
        lua_ls = {
          settings = { Lua = { diagnostics = { globals = { "vim" } } } }
        }
      }

      -- 4. Register the configs using the new native API
      for name, config in pairs(servers) do
        config.capabilities = capabilities
        config.on_attach = on_attach

        -- This is the "new" way (nvim 0.11+) that replaces require('lspconfig')[name].setup()
        vim.lsp.config(name, config)
      end

      -- 5. Force the servers to enable/start
      vim.lsp.enable(vim.tbl_keys(servers))
    end,
  },
  { "ray-x/lsp_signature.nvim" },
}
