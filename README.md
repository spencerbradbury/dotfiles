## Dotfiles Setup (GNU Stow)

This repo uses **GNU Stow** to manage symlinks from this directory into `$HOME`.

### Structure
Each folder represents a “package” of configs:
```
dotfiles/
├── nvim/
├── zsh/
├── git/
```

Inside each package, files are laid out as they should appear in `$HOME`:

```
zsh/.zshrc → ~/.zshrc
nvim/.config/nvim/ → ~/.config/nvim/
```

---

### Install Stow
```bash
sudo apt install stow   # Debian/Ubuntu
# or
brew install stow       # macOS
```

---

### Usage

From the root of this repo:

**Stow (create symlinks)**
```
stow zsh
stow nvim
```
**Unstow (remove symlinks)**
```
stow -D zsh
```
**Restow (relink after changes)**
```
stow -R zsh
```

---

### Notes

- Always run `stow` from the repo root (or use `--target $HOME`).
- Use one folder per config “package”.
- Existing files in `$HOME` may need to be removed or backed up first.

---

### First-time setup
```
git clone <repo> ~/dotfiles
cd ~/dotfiles
stow *
```
If files already exist, either remove them manually or use 
```
stow --adopt <package>
```
>[!WARNING] 
>`--adopt` will move existing files into this repo. Review changes with `git diff` before committing.
