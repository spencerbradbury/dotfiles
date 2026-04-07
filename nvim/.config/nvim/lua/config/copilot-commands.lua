-- Copilot Chat context helper commands
local function get_files_from_dir(dir, pattern)
  pattern = pattern or ".*"  -- default: all files
  
  local cmd = string.format("find %s -type f -name '%s' 2>/dev/null", vim.fn.shellescape(dir), pattern)
  local result = vim.fn.systemlist(cmd)
  
  if vim.v.shell_error ~= 0 then
    vim.notify("Error reading directory: " .. dir, vim.log.levels.ERROR)
    return {}
  end
  
  return result
end

local function create_context_buffer(files, title)
  -- Create new buffer
  vim.cmd("new")
  local bufnr = vim.api.nvim_get_current_buf()
  
  -- Make it a temporary buffer (won't prompt to save)
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = bufnr })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = bufnr })
  vim.api.nvim_set_option_value("modifiable", true, { buf = bufnr })
  
  -- Add title and file markers
  local lines = { "-- " .. title, "-- Generated context for Copilot Chat", "" }
  
  for _, file in ipairs(files) do
    if vim.fn.filereadable(file) == 1 then
      table.insert(lines, "-- ========================================")
      table.insert(lines, "-- File: " .. file)
      table.insert(lines, "-- ========================================")
      
      local file_lines = vim.fn.readfile(file)
      for _, line in ipairs(file_lines) do
        table.insert(lines, line)
      end
      table.insert(lines, "")
    end
  end
  
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  
  -- Make it read-only after populating (prevents accidental edits)
  vim.api.nvim_set_option_value("modifiable", false, { buf = bufnr })
  
  -- Select all and open chat
  vim.cmd("normal! ggVG")
  vim.defer_fn(function()
    vim.cmd("CopilotChatToggle")
  end, 100)
end

-- Command: :CopilotAddDir <path> [pattern]
-- Adds all files from a directory to a new buffer
vim.api.nvim_create_user_command("CopilotAddDir", function(opts)
  local args = vim.split(opts.args, " ")
  local dir = args[1]
  local pattern = args[2] or "*"  -- default to all files
  
  if not dir or dir == "" then
    vim.notify("Usage: :CopilotAddDir <path> [pattern]", vim.log.levels.WARN)
    return
  end
  
  local files = get_files_from_dir(dir, pattern)
  if #files == 0 then
    vim.notify("No files found in: " .. dir, vim.log.levels.WARN)
    return
  end
  
  create_context_buffer(files, "Directory: " .. dir)
end, {
  nargs = "+",
  complete = "dir",
})

-- Command: :CopilotAddFile <path> [path2] [path3]...
-- Adds specific files to a new buffer
vim.api.nvim_create_user_command("CopilotAddFile", function(opts)
  local files = vim.split(opts.args, " ")
  
  if #files == 0 or files[1] == "" then
    vim.notify("Usage: :CopilotAddFile <path> [path2] [path3]...", vim.log.levels.WARN)
    return
  end
  
  -- Filter to readable files only
  local readable_files = {}
  for _, file in ipairs(files) do
    if vim.fn.filereadable(file) == 1 then
      table.insert(readable_files, file)
    else
      vim.notify("File not readable: " .. file, vim.log.levels.WARN)
    end
  end
  
  if #readable_files == 0 then
    vim.notify("No readable files provided", vim.log.levels.ERROR)
    return
  end
  
  create_context_buffer(readable_files, "Selected Files")
end, {
  nargs = "+",
  complete = "file",
})

-- Command: :CopilotAddBufdir
-- Adds all files from current buffer's directory to new buffer
vim.api.nvim_create_user_command("CopilotAddBufdir", function(opts)
  local bufdir = vim.fn.expand("%:p:h")
  local pattern = opts.args ~= "" and opts.args or "*"
  
  local files = get_files_from_dir(bufdir, pattern)
  if #files == 0 then
    vim.notify("No files found in: " .. bufdir, vim.log.levels.WARN)
    return
  end
  
  create_context_buffer(files, "Buffer Directory: " .. bufdir)
end, {
  nargs = "?",
})

-- Command: :CopilotAddGit [pattern]
-- Adds all tracked files from git repo (optionally filtered by pattern)
vim.api.nvim_create_user_command("CopilotAddGit", function(opts)
  local pattern = opts.args ~= "" and opts.args or "*"
  local cmd = "git ls-files | head -50"  -- limit to first 50 files to avoid token overload
  
  local files = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("Not a git repository or git command failed", vim.log.levels.ERROR)
    return
  end
  
  if #files == 0 then
    vim.notify("No files in git repository", vim.log.levels.WARN)
    return
  end
  
  create_context_buffer(files, "Git Repository Files (limited to 50)")
end, {
  nargs = "?",
})
