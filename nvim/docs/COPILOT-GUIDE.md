# Copilot Setup Reference

## Quick Start

### Authentication
First time setup, authenticate with GitHub:
```
:Copilot auth
```

Follow the browser prompt to authenticate. Authorization persists.

To switch accounts, clear the token cache:
```bash
rm -rf ~/.config/github-copilot ~/.cache/github-copilot
```

Then `:Copilot auth` again.

---

## Autocompletion (Ghost Text)

**How it works:**
- Copilot suggests completions as you type (75ms debounce)
- Suggestions appear as gray ghost text inline
- Works automatically in insert mode

**Keybinds:**

| Key | Action |
|-----|--------|
| `Tab` | Accept current suggestion |
| `<M-]>` (Alt+]) | Next suggestion |
| `<M-[>` (Alt+[) | Previous suggestion |
| `<C-]>` (Ctrl+]) | Dismiss suggestion |
| `<C-Space>` | Force completion menu |
| `<S-Tab>` | Cycle backwards in menu |

**Tips:**
- Trigger appears at 75ms of inactivity
- Works in Python, JavaScript, Lua, Go, C++, etc.
- Disabled in: help, git commits, yaml, shell
- Type a few characters then wait—Copilot will suggest

---

## Chat (Structured Prompting)

Open interactive chat window: `<leader>cc`

### Chat Keybinds

| Bind | Action |
|------|--------|
| `<leader>cc` | Open/toggle chat |
| `<leader>ce` | Explain code |
| `<leader>cr` | Review code |
| `<leader>cf` | Fix code |
| `<leader>co` | Optimize code |
| `<leader>cd` | Generate docs |
| `<leader>ct` | Generate tests |

### In Chat Window

| Bind | Action |
|------|--------|
| `<CR>` or `<C-s>` | Submit prompt |
| `<C-l>` | Clear chat |
| `<C-y>` | Accept diff |
| `gd` | Show diff |
| `gp` | Show info |
| `gs` | Show context |
| `[[` / `]]` | Prev/next in panel |

---

## Daily Workflow

### 1. Code Completion
```
1. Start typing in insert mode
2. Wait ~100ms for ghost text suggestion
3. Press Tab to accept or Alt+] for alternatives
4. Continue coding
```

### 2. Quick Questions
```
1. Press <leader>cc to open chat
2. Type your question
3. Press Enter to submit
4. Review response in float window
5. Press Ctrl+y to accept diffs, or copy manually
6. Close with Escape
```

### 3. Code Review
```
1. Select code in visual mode
2. Press <leader>cc to open chat with visual context
3. Or use <leader>cr for automated review
4. Review response and apply changes
```

### 4. Generate Tests/Docs
```
1. Have cursor in function/file
2. Press <leader>ct for tests or <leader>cd for docs
3. Accept results or refine with follow-up prompts
```

---

## Model Configuration

### Current Model
Chat uses `gpt-4.1` by default.

### Check Active Model
```
:CopilotChat
```
Then use the model selector (displayed in chat window).

### Change Model
Edit [plugins/chat.lua](../lua/plugins/chat.lua#L12):
```lua
model = "gpt-5.1",  -- Available: gpt-4.1, gpt-5.1, gpt-5, claude-3.5-sonnet, etc.
```

### Recommended Models
- **gpt-5.1**: Latest, best reasoning (default recommendation)
- **gpt-4.1**: Stable, balanced performance
- **claude-3.5-sonnet**: Excellent code understanding
- **gpt-5**: Faster inference

---

## Troubleshooting

### Copilot not suggesting
1. Ensure authenticated: `:Copilot auth`
2. Check not disabled: `:Copilot enable`
3. Not in excluded filetypes (yaml, sh, gitcommit, etc.)
4. Have typed at least a few characters

### Chat not opening
1. Check plugins loaded: `:checkhealth copilot`
2. May need to restart nvim after first install
3. Ensure Python available: `python3 --version`

### Slow suggestions
- Increase debounce in [plugins/copilot.lua](../lua/plugins/copilot.lua#L11): `debounce = 150`
- Or disable auto_trigger and use `<C-Space>` manually

### Wrong model selected
1. Open chat: `:CopilotChat`
2. Press 'm' or navigate to model selector
3. Select desired model
4. Changes persist for session

---

## Useful Commands

| Command | Action |
|---------|--------|
| `:Copilot auth` | Authenticate with GitHub |
| `:Copilot enable` | Enable Copilot |
| `:Copilot disable` | Disable Copilot |
| `:CopilotChat` | Open main chat |
| `:CopilotChatReset` | Clear chat history |
| `:CopilotChatToggle` | Toggle visibility |

---

## Integration with LSP

Completion menu (`<C-Space>`) sources (in priority order):
1. **Copilot suggestions** (AI-powered)
2. **LSP completions** (language server)
3. **Snippets** (luasnip)
4. **Buffer words**
5. **File paths**

Copilot completions appear first if available, with LSP fallback.

---

## Tips & Tricks

1. **Copy+Paste Large Code**: Ask in chat, then `<C-y>` to accept diffs or copy the code block
2. **Multi-line Context**: Visual selection (`v`) + `<leader>cc` sends full context
3. **Ask Clarifying Questions**: You can chat back and forth—send follow-ups
4. **Test Generation**: Select test file, `<leader>ct` to generate tests
5. **Refactor**: Select code, `<leader>cr` for structured refactoring

---

## Disabled Filetypes

To reduce noise, Copilot is disabled in:
- YAML configs
- Shell scripts
- Git commit messages
- Help files

Enable selectively in [plugins/copilot.lua](../lua/plugins/copilot.lua#L30) if needed.
