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
        end,
    },

    {
        "tpope/vim-fugitive",
        cmd = { "G", "Git" },
    },

    -- Comment toggling
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
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
    },

    -- Trouble
    {
      "folke/trouble.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = {},
    },

    -- Flash
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
    },

    -- Oil
    {
        "stevearc/oil.nvim",
        opts = {
            default_file_explorer = true,
            columns = { "icon" },
            view_options = {
                show_hidden = true,
            },
        },
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
}
