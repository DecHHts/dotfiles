# dotfiles

我的 macOS 终端与编辑器配置，用 [GNU Stow](https://www.gnu.org/software/stow/) 管理。

仓库里存放真实文件，家目录里只放指向它们的软链接。改 `~/.zshrc` 就等于改仓库里的文件，git 能直接跟踪。

## 目录结构

每个子目录是一个 stow「包」，包内路径与 `~` 下的路径一一对应：

```
~/dotfiles/
├── zsh/.zshrc                        → ~/.zshrc
├── starship/.config/starship.toml    → ~/.config/starship.toml
├── nvim/.config/nvim/                → ~/.config/nvim/
├── git/.gitconfig                    → ~/.gitconfig
├── Brewfile                          # Homebrew 软件清单
└── README.md
```

| 包 | 内容 |
| --- | --- |
| `zsh` | zsh 配置：autosuggestions、syntax-highlighting、history-substring-search、zoxide、fzf、eza 等 |
| `starship` | 提示符：Catppuccin Mocha 配色的胶囊样式，显示完整路径、git 状态、语言版本 |
| `nvim` | Neovim：lazy.nvim 管理插件，含 LSP（mason）、nvim-cmp、treesitter、telescope、nvim-tree、lualine |
| `git` | git 用户名与邮箱 |
| `Brewfile` | 命令行工具与 Nerd Font 字体 |

## 在新 Mac 上恢复

```bash
# 1. 安装 Homebrew（已装可跳过）
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. 克隆仓库（需先在新电脑上配好 GitHub SSH key；没配的话把地址换成 https://github.com/DecHHts/dotfiles.git）
git clone git@github.com:DecHHts/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 3. 安装 Brewfile 中的全部软件和字体（含 stow）
brew bundle

# 4. 把系统自带的同名配置挪开，避免 stow 冲突
mkdir -p ~/.dotfiles_backup
for f in ~/.zshrc ~/.gitconfig ~/.config/starship.toml ~/.config/nvim; do
  [ -e "$f" ] && [ ! -L "$f" ] && mv "$f" ~/.dotfiles_backup/
done

# 5. 建立软链接
stow zsh starship nvim git
```

然后：

1. 把终端字体设为 **Monaspice 系列的 Nerd Font**（例如 MonaspiceRn Nerd Font，或其他任意 Nerd Font），否则提示符两端的半圆和图标会显示成方块。
   - Terminal.app：设置 → 描述文件 → 文本 → 字体
   - iTerm2：Settings → Profiles → Text → Font
2. 新开一个终端窗口，提示符应变成胶囊样式。
3. 运行 `nvim`，lazy.nvim 会自动安装插件，等它装完后重启一次 nvim。

检查链接是否正确：

```bash
ls -la ~/.zshrc ~/.config/starship.toml ~/.config/nvim ~/.gitconfig
# 每一行都应该显示 -> dotfiles/...
```

## 日常使用

### 修改配置后同步到 GitHub

照常编辑原来的路径（`~/.zshrc`、`~/.config/starship.toml` 等）即可，改动会直接落在仓库里：

```bash
cd ~/dotfiles
git status                 # 看看改了什么
git add -A
git commit -m "描述这次改动"
git push
```

### 在另一台电脑上拉取最新配置

```bash
cd ~/dotfiles && git pull
exec zsh                   # 让 zsh 配置立即生效
```

软链接不需要重新建立；只有新增了文件或包时才需要再跑一次 `stow`。

### 新增一个工具的配置

以 tmux 为例：

```bash
cd ~/dotfiles
mkdir -p tmux
mv ~/.tmux.conf tmux/      # 按照它在 ~ 下的路径放进包里
stow tmux                  # 生成软链接
git add tmux && git commit -m "add tmux" && git push
```

位于 `~/.config/xxx` 下的配置，包内也要带上 `.config` 这一层，例如 `yazi/.config/yazi/`。

### 新装或卸载了 Homebrew 软件

```bash
brew bundle dump --file=~/dotfiles/Brewfile --force
cd ~/dotfiles && git add Brewfile && git commit -m "update Brewfile" && git push
```

### 常用 stow 命令

| 命令 | 作用 |
| --- | --- |
| `stow <包>` | 建立该包的软链接 |
| `stow -R <包>` | 重新链接（包内新增或删除了文件时用） |
| `stow -D <包>` | 删除该包的软链接（仓库里的文件保留） |
| `stow -n -v <包>` | 只演示会做什么，不实际执行 |

以上命令都要在 `~/dotfiles` 目录里运行。

## 隐私规则

这个仓库会推到 GitHub，提交前注意：

- **不要放任何密钥**：API key、token、代理密码、SSH 私钥都不进仓库。
- 需要在 shell 里设置的敏感变量，写进 `~/.zshrc.local`（已被 `.gitignore` 忽略），`.zshrc` 中用这一行加载：
  ```bash
  [ -f ~/.zshrc.local ] && source ~/.zshrc.local
  ```
- Neovim 的撤销历史目录 `nvim/.config/nvim/undodir/` 已被忽略：它保存的是被编辑文件的内容快照，可能包含 `~/.ssh/config` 等私密信息。
- 提交前可以快速自查：
  ```bash
  grep -rnEi "token|secret|passw|api_key|http://.*@" ~/dotfiles --exclude-dir=.git
  ```

## 常见问题

**`stow` 报错 `existing target is neither a link nor a directory`**
说明 `~` 下已经有一个同名的普通文件。先把它挪走（见「在新 Mac 上恢复」第 4 步）再运行 `stow`。如果想用那份现有文件覆盖仓库里的版本，可以用 `stow --adopt <包>`，再用 `git diff` 检查。

**提示符两端显示成方块或问号**
终端字体不是 Nerd Font。运行 `brew bundle` 后，在终端设置里改成 Monaspice 系列的 Nerd Font。

**改了 starship.toml 没有变化**
新开一个终端窗口，或者执行 `exec zsh`。
