return {
    -- Colorscheme
    { "folke/tokyonight.nvim" },
    { "ellisonleao/gruvbox.nvim" },
    { "catppuccin/nvim", name = "catppuccin" },
    { "rebelot/kanagawa.nvim" },
    { "rose-pine/neovim", name = "rose-pine" },
    { "EdenEast/nightfox.nvim" },
    { "Mofiqul/dracula.nvim" },
    { "ribru17/bamboo.nvim" },
    { "savq/melange-nvim" },
    { "navarasu/onedark.nvim" },

    { "zaldih/themery.nvim",
        lazy = false,
        config = function()
            require("themery").setup({
                themes = {
                    "bamboo",
                    -- "bamboo-light",
                    -- "bamboo-multiplex",
                    "bamboo-vulgaris",
                    -- "blue",
                    -- "carbonfox",
                    -- "catppuccin",
                    -- "catppuccin-latte",
                    -- "catppuccin-macchiato",
                    "catppuccin-mocha",
                    -- "catppuccin-frappe",
                    -- "darkblue",
                    -- "dawnfox",
                    -- "dayfox",
                    -- "delek",
                    "desert",
                    -- "default",
                    "dracula",
                    -- "dracula-soft",
                    "duskfox",
                    -- "elflord",
                    -- "evening",
                    -- "industry",
                    -- "kanagawa",
                    "kanagawa-dragon",
                    -- "kanagawa-lotus",
                    "kanagawa-wave",
                    -- "koehler",
                    -- "lunaperche",
                    "melange",
                    -- "morning",
                    -- "murphy",
                    -- "nightfox",
                    -- "nordfox",
                    "onedark",
                    -- "pablo",
                    -- "peachpuff",
                    -- "quiet",
                    "retrobox",
                    -- "ron",
                    -- "rose-pine",
                    -- "rose-pine-dawn",
                    "rose-pine-main",
                    -- "rose-pine-moon",
                    -- "shine",
                    -- "slate",
                    -- "sorbet",
                    "terafox",
                    -- "tokyonight",
                    -- "tokyonight-day",
                    "tokyonight-moon",
                    -- "tokyonight-night",
                    -- "tokyonight-storm",
                    -- "torte",
                    "unokai",
                    -- "vim",
                    "wildcharm",
                    -- "zaibatsu",
                    -- "zellner",
                },
            })
        end
    },

    -- Statusline
    { "nvim-lualine/lualine.nvim" },

    -- File icons
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- Buffer Tabs
    { "akinsho/bufferline.nvim",
        version = "*",
        dependencies = "nvim-tree/nvim-web-devicons",
        opts = {
            options = {
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "File Explorer",
                        highlight = "Directory",
                        separator = true,
                    },
                },
            },
        },
    },

    -- Remove Buffer
    { "echasnovski/mini.bufremove",
        version = false,
    },

    -- File Tree
    { "nvim-tree/nvim-tree.lua", dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("nvim-tree").setup({
                -- Custom setup here
                view = {
                    width = 30,
                    side = "left",
                },
                renderer = {
                    icons = {
                        show = {
                            file = true,
                            folder = true,
                            git = true,
                        },
                    },
                },
                filesystem_watchers = {
                    enable = false,
                },
                actions = {
                    open_file = {
                        quit_on_open = false,
                    },
                },
            })
        end,
    },

    -- Start screen
    { "mhinz/vim-startify",
        config = function()
            vim.g.startify_lists = {
                { type = "files",   header = { "    Recent Files" } },
                { type = "dir",     header = { "    Files in Current Directory" } },
                { type = "bookmarks", header = { "    Bookmarks" } },
            }
        end,
    },

    -- Leader key popup
    { "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            local wk = require("which-key")
            wk.setup()

            wk.add({
                { "<leader>b", group = "Buffers", icon = "󰓩 " },
                { "<leader>c", group = "Copilot", icon = " " },                            
                { "<leader>d", group = "Diagnostics"},
                { "<leader>e", group = "Explorer", icon = "󰙅 " },
                { "<leader>f", group = "Find", icon = "󰍉 " },
                { "<leader>g", group = "Git" },
                { "<leader>l", group = "LSP" },
                { "<leader>s", group = "Split" },
                { "<leader>t", group = "Terminal" },
            })
        end,
    },

    -- Copilot Chat
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
            { "zbirenbaum/copilot.lua" },
            { "nvim-lua/plenary.nvim" },
        },
        build = "make tiktoken",
        opts = {
            debug = false,
            model = "gpt-4.1",
            temperature = 0.1,
            Question_header = "# User ",
            Answer_header = "# Copilot ",
            default_window_config = {
                relative = "editor",
                position = { row = 1, col = 0 },
                size = {
                    width = "0.8",
                    height = "0.6",
                },
            },
            show_help = true,
            show_folds = true,
            highlight_selection = true,
            highlight_insertion = true,
            auto_follow_cursor = false,
            auto_insert_mode = false,
            insert_at_end = false,
            clear_chat_on_new_prompt = false,
        },
        config = function(_, opts)
            require("CopilotChat").setup(opts)
        end,
    },
}
