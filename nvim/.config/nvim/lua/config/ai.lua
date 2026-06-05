-- AI inline-completion engine selection.
--
-- Picks ONE ghost-text engine at startup so Copilot and Supermaven never
-- fight over the screen or the accept key:
--   * Signed into GitHub Copilot  -> use copilot.lua (ghost text)
--   * Not signed into Copilot      -> use Supermaven (free tier)
--
-- Detection is a cheap synchronous file check. Override anytime by setting
-- `vim.g.ai_completion = "copilot"` or `"supermaven"` before plugins load
-- (e.g. at the top of init.lua), then restart.

local M = {}

function M.copilot_signed_in()
  -- Manual override escape hatch.
  if vim.g.ai_completion == "copilot" then return true end
  if vim.g.ai_completion == "supermaven" then return false end

  -- GitHub Copilot stores its OAuth token in one of these files once you've
  -- run `:Copilot auth` / signed in. Presence of "oauth_token" == signed in.
  for _, name in ipairs({ "apps.json", "hosts.json" }) do
    local path = vim.fn.expand("~/.config/github-copilot/" .. name)
    if vim.fn.filereadable(path) == 1 then
      local ok, lines = pcall(vim.fn.readfile, path)
      if ok and table.concat(lines, "\n"):find("oauth_token") then
        return true
      end
    end
  end
  return false
end

-- Convenience: returns "copilot" or "supermaven".
function M.engine()
  return M.copilot_signed_in() and "copilot" or "supermaven"
end

return M
