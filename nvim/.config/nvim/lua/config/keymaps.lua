-- Keymaps
-- See :h vim.keymap.set()
local map = vim.keymap.set

-- Plugin APIs
local telescope = require("telescope.builtin")
local gitsigns = require("gitsigns")
local toggleterm = require("toggleterm")
local comment = require("Comment.api")
local flash = require("flash")


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
map('n', '<C-q>', function() vim.cmd.cclose() end, { noremap = true, desc = "Close quickfix" })

map('x', '<leader>p', [["_dP]])

map({'n', 'x', 'o'}, 's', function() flash.jump() end, { desc = "Flash" })
map({'n', 'x', 'o'}, 'S', function() flash.treesitter() end, { desc = "Flash treesitter" })
map('o', 'r', function() flash.remote() end, { desc = "Remote Flash" })
map({'x', 'o'}, 'R', function() flash.treesitter_search() end, { desc = "Treesitter Search" })

--------------------------------------------------
--- Splits
--------------------------------------------------

map('n', '<leader>sv', '<cmd>vsplit<CR>', { desc = "Vertical split" })
map('n', '<leader>sh', '<cmd>split<CR>', { desc = "Horizontal split" })
map('n', '<leader>sc', '<cmd>close<CR>', { desc = "Close window" })
map('n', '<leader>so', '<cmd>only<CR>', { desc = "Close other splits" })

--------------------------------------------------
--- Diagnostics
--------------------------------------------------

map('n', '[d', vim.diagnostic.goto_prev, { desc = "Next diagnostic" })
map('n', ']d', vim.diagnostic.goto_next, { desc = "Prev diagnostic" })
map("n", "]e", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Next error" })

map("n", "[e", function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Prev error" })

map('n', '<leader>dl', vim.diagnostic.open_float, { desc = "Line diagnostics" })
map('n', '<leader>df', vim.diagnostic.setloclist, { desc = "File diagnostics" })
map("n", "<leader>dw", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Workspace diagnostics" })
map("n", "<leader>dt", function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, { desc = "Toggle disagnostics" })
map("n", "<leader>dq", function() vim.diagnostic.setqflist() end, { desc = "Quickfix" })

--------------------------------------------------
--- Buffers
--------------------------------------------------

map("n", "<S-l>", ":bnext<CR>")
map("n", "<S-h>", ":bprevious<CR>")
map("n", "<leader>bd", function()
    require("mini.bufremove").delete(0, false)
end, { desc = "Delete buffer" })
map("n", "<leader>bo", "<cmd>%bd|e#|bd#<CR>", { desc = "Close all other buffers" })

--------------------------------------------------
--- Telescope
--------------------------------------------------

map('n', '<leader>ff', telescope.find_files, { desc = "Files"} )
map('n', '<leader>fg', require('telescope').extensions.live_grep_args.live_grep_args, { desc = "Grep" })
map('n', '<leader>fr', telescope.resume, { desc = "Resume" })
map('n', '<leader>fb', telescope.buffers, { desc = "Buffers" })
map('n', '<leader>fs', telescope.lsp_document_symbols, { desc = "Symbols" })
map('n', '<leader>fw', telescope.grep_string, { desc = "Word" })

--------------------------------------------------
--- Git
--------------------------------------------------

map("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git status" })
map("n", "<leader>gB", "<cmd>G blame<CR>", { desc = "Git blame" })

map("n", "<leader>gb", function()
    gitsigns.toggle_current_line_blame()
end, { desc = "Toggle git blame (line)" })

map("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "LazyGit" })

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

--------------------------------------------------
--- File Explorer
--------------------------------------------------

map("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle Explorer" })
map("n", "<leader>ef", "<cmd>NvimTreeFindFile<CR>", { desc = "Find Current File" })
map("n", "<leader>et", "<cmd>NvimTreeFocus<CR>", { desc = "Focus Explorer" })
map("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh Explorer" })

map("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })
map("n", "<leader>e-", function() require("oil").toggle_float() end, { desc = "Oil Float" })

--------------------------------------------------
--- Copilot Chat
--------------------------------------------------

map("n", "<leader>cc", ":CopilotChatToggle<CR>", { desc = "Toggle Copilot Chat" })
map("v", "<leader>cc", ":CopilotChatToggle<CR>", { desc = "Toggle Copilot Chat (visual)" })
map("n", "<leader>ce", ":CopilotChatExplain<CR>", { desc = "Explain code" })
map("n", "<leader>cr", ":CopilotChatReview<CR>", { desc = "Review code" })
map("n", "<leader>cf", ":CopilotChatFix<CR>", { desc = "Fix code" })
map("n", "<leader>co", ":CopilotChatOptimize<CR>", { desc = "Optimize code" })
map("n", "<leader>cd", ":CopilotChatDocs<CR>", { desc = "Generate docs" })
map("n", "<leader>ct", ":CopilotChatTests<CR>", { desc = "Generate tests" })
map("n", "<leader>ca", ":CopilotAddDir ", { desc = "Add directory context" })
map("n", "<leader>cA", ":CopilotAddFile ", { desc = "Add file context" })
map("n", "<leader>cx", ":CopilotAddGit<CR>", { desc = "Add git repo context" })
