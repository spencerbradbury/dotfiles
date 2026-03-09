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
        config = function()
            require("bufferline").setup()
            vim.keymap.set("n", "<S-l>", ":bnext<CR>")
            vim.keymap.set("n", "<S-h>", ":bprevious<CR>")
            vim.keymap.set("n", "<leader>x", ":bd<CR>")
        end
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
            require("which-key").setup()
        end
    }


}
