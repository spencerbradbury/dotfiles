-- Keymaps
-- See :h vim.keymap.set()
local map = vim.keymap.set

-- Plugin APIs
local telescope = require("telescope.builtin")
local gitsigns = require("gitsigns")
local toggleterm = require("toggleterm")
local comment = require("Comment.api")


--------------------------------------------------
--- Window Navigation
--------------------------------------------------
map({ 't', 'i' }, '<A-h>', '<C-\\><C-n><C-w>h')
map({ 't', 'i' }, '<A-j>', '<C-\\><C-n><C-w>j')
map({ 't', 'i' }, '<A-k>', '<C-\\><C-n><C-w>k')
map({ 't', 'i' }, '<A-l>', '<C-\\><C-n><C-w>l')
map({ 'n' }, '<A-h>', '<C-w>h')
map({ 'n' }, '<A-j>', '<C-w>j')
map({ 'n' }, '<A-k>', '<C-w>k')
map({ 'n' }, '<A-l>', '<C-w>l')

-------------------------------------------------
--- Editing
-------------------------------------------------

map('v', '<', '<gv')
map('v', '>', '>gv')

map('v', 'J', ":m '>+1<CR>gv=gv")
map('v', 'K', ":m '<-2<CR>gv=gv")

map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')

map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

map('n', '<Esc>', '<cmd>nohlsearch<CR>')
map('n', '<leader>cc', function() vim.cmd.cclos() end, { noremap = true })

--------------------------------------------------
--- Splits
--------------------------------------------------

map('n', '<leader>sv', ':vsplit<CR>')
map('n', '<leader>sh', ':split<CR>')

--------------------------------------------------
--- Diagnostics
--------------------------------------------------

map('n', '[d', vim.diagnostic.goto_prev)
map('n', ']d', vim.diagnostic.goto_next)

map('n', '<leader>e', vim.diagnostic.open_float)
map('n', '<leader>q', vim.diagnostic.setloclist)

map("n", "<leader>xx", "<cmd>Touble diagnostics toggle<CR>", { desc = "Diagnostics panel" })

--------------------------------------------------
--- Buffers
--------------------------------------------------

map("n", "<S-l>", ":bnext<CR>")
map("n", "<S-h>", ":bprevious<CR>")
map("n", "<leader>bd", function()
    require("mini.bufremove").delete(0, false)
end, { desc = "Delete buffer" })

--------------------------------------------------
--- Telescope
--------------------------------------------------

map('n', '<leader>ff', telescope.find_files)
map('n', '<leader>fg', require('telescope').extensions.live_grep_args.live_grep_args)
map('n', '<leader>fr', telescope.resume)
map('n', '<leader>fb', telescope.buffers)
map('n', '<leader>fs', telescope.lsp_document_symbols)

--------------------------------------------------
--- Git
--------------------------------------------------

map("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git status" })
map("n", "<leader>gB", "<cmd>G blame<CR>", { desc = "Git blame" })

map("n", "<leader>gb", function()
    gitsigns.toggle_current_line_blame()
end, { desc = "Toggle git blame (line)" })

map("n", "<leader>lg", "<cmd>LazyGit<CR>", { desc = "LazyGit" })

--------------------------------------------------
--- Comments
--------------------------------------------------

map("n", "<C-_>", comment.toggle.linewise.current, { silent = true, desc = "Toggle comment current line" })

map("v", "<C-_>", function()
    comment.toggle.linewise(vim.fn.visalmode())
end, { silent = true, desc = "Toggle comment visual mode" })

map("i", "<C-_>", function()
    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
        "n",
        false
    )
    comment.toggle.linewise.current()
    vim.api.nvim_feedkeys("i", "n", false)
end, { silent = true, desc = "Toggle comment (insert)" })

--------------------------------------------------
--- Toggle term
--------------------------------------------------

map("n", "<leader>tt", function()
    toggleterm.toggle(1)
end, { desc = "Terminal" })

map("n", "<leader>tn", function()
    toggleterm.toggle(2)
end, { desc = "Scratch terminal" })

map("n", "<leader>tf", function()
    toggleterm.toggle(3, 0, vim.fn.getcwd(), "float")
end, { desc = "Floating terminal" })

-- map("n", "<leader>tm", function()
--         toggleterm.exec("./goto_docker.sh /tmp make", 1)
-- end, { desc = "Run make" })
--
-- map("n", "<leader>tc", function()
--     toggleterm.exec('./goto_docker.sh /tmp "make clean"', 1)
-- end, { desc = "Run make clean" })

