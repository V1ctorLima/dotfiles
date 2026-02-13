# Claude Code Configuration

This directory contains my synced Claude Code visual setup and configuration.

## 🚀 Quick Setup on New Machine

1. Clone your dotfiles repository:
   ```bash
   git clone <your-repo-url> ~/dotfiles
   ```

2. Run the installation script:
   ```bash
   ~/dotfiles/.claude/install.sh
   ```

3. Done! Your visual setup is now configured.

## 📁 What's Synced

- **settings.json** - Main configuration including:
  - Custom status line (`ccstatusline`)
  - Permissions presets
  - Enabled plugins
  - Theme preferences

- **keybindings.json** (if customized) - Keyboard shortcuts

## 🔧 How It Works

The install script creates symlinks from `~/.claude/` to `~/dotfiles/.claude/`:
- `~/.claude/settings.json` → `~/dotfiles/.claude/settings.json`
- Machine-specific settings go in `~/.claude/settings.local.json` (not synced)

## 📝 Making Changes

### Synced Changes (All Machines)
Edit `~/dotfiles/.claude/settings.json` and commit:
```bash
cd ~/dotfiles
git add .claude/settings.json
git commit -m "Update Claude Code settings"
git push
```

### Machine-Specific Changes
Edit `~/.claude/settings.local.json` directly (not tracked in git)

## 🔄 Syncing to Other Machines

```bash
cd ~/dotfiles
git pull
```

Changes will be reflected immediately since `settings.json` is symlinked!

## 🎨 Current Visual Setup

- **Status Line**: Custom status line using `ccstatusline`
- **Plugins**:
  - frontend-design
  - review-confluence-page
- **Permissions**: Pre-approved git, gh, and various bash commands

## 📚 Resources

- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
- [Status Line Guide](https://docs.anthropic.com/claude-code/status-line)
