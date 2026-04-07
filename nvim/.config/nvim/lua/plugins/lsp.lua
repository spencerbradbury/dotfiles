return {
  -- 0. Copilot Completion Core
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = "<C-l>",
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>",
        },
        layout = {
          position = "right",
          ratio = 0.3,
        },
      },
      filetypes = {
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
      copilot_node_command = "node",
    },
  },

  -- 0.1 Copilot source for nvim-cmp
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua", "hrsh7th/nvim-cmp" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },

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
          { name = "copilot", priority = 100 },
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
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "williamboman/mason-lspconfig.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      -- 1. Setup our on_attach function
      local on_attach = function(client, bufnr)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Go to declaration" })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover" })
        vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename" })
        vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code actions" })
        vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, { buffer = bufnr, desc = "Format" })

        -- Telescope-powered navigation
        local ok, builtin = pcall(require, "telescope.builtin")
        if ok then
          vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = bufnr, desc = "Go to definition" })
          vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = bufnr, desc = "Go to references" })
          vim.keymap.set("n", "gi", builtin.lsp_implementations, { buffer = bufnr, desc = "Go to implementation" })
        end
      end
      -- 2. Capabilities for autocompletion
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- 3. Use the NEW native way to avoid the deprecation warning
      local servers = {
        clangd = {
          cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=never", "--fallback-style=llvm" },
          root_markers = { ".git", ".clangd", "compile_commands.json" },
        },
        pyright = {},
        ts_ls = {},
        gopls = {},
        lua_ls = {
          settings = { Lua = { diagnostics = { globals = { "vim" } } } }
        }
      }

      require("mason-lspconfig").setup({
          ensure_installed = vim.tbl_keys(servers),
      })

      -- 4. Register the configs using the new native API
      for name, config in pairs(servers) do
        config.capabilities = capabilities
        config.on_attach = on_attach
        vim.lsp.config(name, config)
      end

      -- 5. Force the servers to enable/start
      vim.lsp.enable(vim.tbl_keys(servers))
    end,
  },
  { "ray-x/lsp_signature.nvim" },
}
