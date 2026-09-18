return {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html", -- required for question parsing
    cmd = "Leet",
    init = function()
        -- leetcode.nvim talks to leetcode.com through plenary.curl; plain
        -- curl gets blocked by Cloudflare, so route requests through the
        -- curl-impersonate Firefox wrapper instead.
        vim.g.plenary_curl_bin_path = vim.fn.expand("~/.local/bin/curl_ff98")
    end,
    keys = {
        { "<leader>xl", "<cmd>Leet<CR>", desc = "LeetCode" },
        { "<leader>xr", "<cmd>Leet run<CR>", desc = "LeetCode run/test" },
        { "<leader>xs", "<cmd>Leet submit<CR>", desc = "LeetCode submit" },
        { "<leader>xt", "<cmd>Leet tabs<CR>", desc = "LeetCode tabs" },
        { "<leader>xp", "<cmd>Leet list<CR>", desc = "LeetCode problem list" },
        { "<leader>xq", "<cmd>Leet exit<CR>", desc = "LeetCode exit" },
    },
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
    },
    opts = {
        lang = "python3",
        plugins = {
            non_standalone = true, -- allow :Leet alongside other open buffers
        },
        editor = {
            reset_previous_code = false, -- keep my code when reopening a solved question
        },
        hooks = {
            -- Opening a question spawns a new tab but leaves the dashboard
            -- tab open behind it. Close the dashboard tab as soon as a
            -- question opens so tabs don't pile up.
            question_enter = {
                function()
                    local menu = _Lc_state and _Lc_state.menu
                    if not (menu and menu.winid and vim.api.nvim_win_is_valid(menu.winid)) then
                        return
                    end

                    local ok, tabnr =
                        pcall(vim.api.nvim_tabpage_get_number, vim.api.nvim_win_get_tabpage(menu.winid))
                    if ok then
                        pcall(vim.cmd, tabnr .. "tabclose")
                    end
                end,
            },
        },
    },
    config = function(_, opts)
        -- The plugin lazily initializes its state on the *first* `:Leet` call
        -- (`start_with_cmd`), then re-registers the `:Leet` command via
        -- `leetcode.command.setup()` as the real subcommand dispatcher. We
        -- patch that second-stage registration so `:Leet lang <lang>` sets
        -- the language directly (no picker), while leaving the plugin's own
        -- lazy-init flow untouched -- overriding the command up front (before
        -- state is initialized) causes `_Lc_state.menu` nil errors.
        local leet_cmd = require("leetcode.command")
        leet_cmd.setup = function()
            vim.api.nvim_create_user_command("Leet", function(args)
                local fargs = vim.split(args.args, "%s+", { trimempty = true })
                if fargs[1] == "lang" and fargs[2] then
                    local slug = fargs[2]
                    local utils = require("leetcode.utils")
                    local q = utils.curr_question()
                    if not q then
                        return
                    end

                    local lang = utils.get_lang(slug) or utils.get_lang_by_name(slug)
                    if not lang then
                        return vim.notify(("LeetCode: unknown language `%s`"):format(slug), vim.log.levels.ERROR)
                    end

                    require("leetcode.picker.language").select(lang, q)
                    return
                end

                leet_cmd.exec(args)
            end, {
                bar = true,
                bang = true,
                nargs = "?",
                desc = "Leet",
                complete = leet_cmd.complete,
            })
        end

        require("leetcode").setup(opts)
    end,
}
