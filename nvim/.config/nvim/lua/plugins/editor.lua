return {
    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = "BufReadPost",
        opts = {
            ensure_installed = {
                "c",
                "cpp",
                "python",
                "lua",
                "bash",
                "json",
                "yaml",
            },
            highlight = { enable = true },
            indent = { enable = true },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                    },
                },
            },
        },
    },

    -- Treesitter text objects
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-live-grep-args.nvim",

            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            }
        },
        config = function()
            local telescope = require("telescope")

            telescope.setup({
                defaults = {
                    reuse_win = false,
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
            })

            telescope.load_extension("fzf")
            telescope.load_extension("live_grep_args")

            vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files)
            vim.keymap.set('n', '<leader>fg', require('telescope').extensions.live_grep_args.live_grep_args)
            vim.keymap.set('n', '<leader>fr', require('telescope.builtin').resume)
            vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers)
            vim.keymap.set('n', '<leader>fs', require('telescope.builtin').lsp_document_symbols)
        end,
    },

    -- Git integration
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup {
                current_line_blame = false, -- Disable on startup
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = "eol", -- "eol" | "overlay" | "right_align"
                    delay = 100,
                },
                current_line_blame_formatter = "<author>, <author_time:%r> • <summary>",
            }

            vim.keymap.set(
                "n",
                "<leader>gb",
                function()
                    require("gitsigns").toggle_current_line_blame()
                end,
                { desc = "Toggle git blame (line)" }
            )
        end,
    },

    {
        "tpope/vim-fugitive",
        cmd = { "G", "Git" },
        keys = {
            { "<leader>gs", ":Git<CR>", desc = "Git status" },
            { "<leader>gB", ":G blame<CR>", desc = "Git full-file blame" },
        },
    },

    -- Comment toggling
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()

            local api = require("Comment.api")

            -- Normal Mode: toggle current line
            vim.keymap.set("n", "<C-_>", api.toggle.linewise.current, { silent = true, desc = "Toggle Comment" })
            -- Visual Mode: toggle selected lines
            vim.keymap.set("v", "<C-_>", function()
                api.toggle.linewise(vim.fn.visalmode())
            end, { silent = true, desc = "Toggle comment" })
            -- Insert Mode: toggle current line
            vim.keymap.set("i", "<C-_>", function()
                vim.api.nvim_feedkeys(
                    vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
                    "n",
                    false
                )
                api.toggle.linewise.current()
                vim.api.nvim_feedkeys("i", "n", false)
            end, { silent = true, desc = "Toggle comment (insert)" })
        end,
    },


    -- ToggleTerm
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup({
                start_in_insert = true,
                persist_size = true,
                close_on_exit = false,
                direction = "horizontal",
                size = 10,
                on_open = function(term)
                    local opts = { noremap = true, silent = true }
                    if term.cmd ~= "lazygit" then
                        vim.api.nvim_buf_set_keymap(
                            term.bufnr,
                            "t",
                            "<Esc>",
                            [[<C-\><C-n>]],
                            opts
                        )
                    end
                end,
            })

            local toggleterm = require("toggleterm")

            -- Main terminal toggle
            vim.keymap.set("n", "<leader>tt", function()
                toggleterm.toggle(1)
            end, { desc = "Toggle main terminal" })

            -- Run make in main terminal
            vim.keymap.set("n", "<leader>tm", function()
                toggleterm.exec("./goto_docker.sh /tmp make", 1)
            end, { desc = "Run make" })

            -- Run make clean in main terminal
            vim.keymap.set("n", "<leader>tc", function()
                toggleterm.exec('./goto_docker.sh /tmp "make clean"', 1)
            end, { desc = "Run make clean" })

            -- Scratch terminal
            vim.keymap.set("n", "<leader>tn", function()
                toggleterm.toggle(2)
            end, { desc = "Toggle scratch terminal" })

            -- Floating terminal
            vim.keymap.set("n", "<leader>tf", function()
                toggleterm.toggle(3, 0, vim.fn.getcwd(), "float")
            end, { desc = "Floating terminal" })
        end,
    },

    -- LazyGit
    {
        "kdheepak/lazygit.nvim",
        lazy = true,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        dependencies = { "nvim-lua/plenary.nvim", "akinsho/toggleterm.nvim" },
        keys = {
            { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
        }
    },

    -- Trouble
    {
      "folke/trouble.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = {},
      keys = {
        { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics panel" },
      },
    },
}
