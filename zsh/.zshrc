# ============================================================
# 基础环境变量
# ============================================================
export LANG=en_US.UTF-8
export EDITOR="nvim"
export VISUAL="$EDITOR"

# Homebrew 环境（Apple Silicon 路径，Intel 芯片改成 /usr/local）
if [[ "$OSTYPE" == darwin* ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  ZPLUG="/opt/homebrew/share"
  HSS="$ZPLUG/zsh-history-substring-search/zsh-history-substring-search.zsh"
else
  export PATH="$HOME/.local/bin:$PATH"
  ZPLUG="/usr/share"
  HSS="$HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh"
  bindkey '^[[1;5C' forward-word    # Ctrl+→ 按词移动
  bindkey '^[[1;5D' backward-word   # Ctrl+← 按词移动
fi

# ============================================================
# 历史记录设置
# ============================================================
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_HISTORY       # 记录时间戳
setopt HIST_EXPIRE_DUPS_FIRST # 清理历史时优先删除重复项
setopt HIST_IGNORE_DUPS       # 不记录连续重复命令
setopt HIST_IGNORE_SPACE      # 以空格开头的命令不记录
setopt HIST_VERIFY            # 历史扩展前先确认
setopt SHARE_HISTORY          # 多终端共享历史记录
setopt APPEND_HISTORY         # 追加而非覆盖

# ============================================================
# 常用 zsh 选项
# ============================================================
setopt AUTO_CD              # 直接输入目录名即可跳转
setopt CORRECT              # 命令拼写自动纠错
setopt INTERACTIVE_COMMENTS # 允许在交互模式下使用 # 注释
setopt NO_CASE_GLOB         # 文件名匹配不区分大小写
setopt AUTO_PUSHD           # cd 时自动加入目录栈
setopt PUSHD_IGNORE_DUPS    # 目录栈中忽略重复项

# ============================================================
# 补全系统
# ============================================================
autoload -Uz compinit
compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # 补全时不区分大小写
zstyle ':completion:*' menu select                      # 补全菜单可用方向键选择
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ============================================================
# 插件加载（Homebrew 安装路径）
# ============================================================
# 语法高亮（必须放在插件加载的最后）
source $ZPLUG/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# 自动建议（根据历史输入灰色提示）
source $ZPLUG/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# 历史子串搜索（上下键根据已输入内容搜索历史）
source $HSS
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# ============================================================
# 快捷键绑定
# ============================================================
bindkey -e                          # 使用 Emacs 风格快捷键
bindkey '^[[1;9C' forward-word      # Option+Right 按词移动
bindkey '^[[1;9D' backward-word     # Option+Left 按词移动
bindkey '^[[3~' delete-char         # Fn+Delete 正向删除

# ============================================================
# 常用别名
# ============================================================
# 现代化命令替代
alias ls='eza --icons --group-directories-first'
alias ll='eza -l --icons --group-directories-first'
alias la='eza -la --icons --group-directories-first'
alias tree='eza --tree --icons'
alias cat='bat --style=plain'
alias vim="nvim"
alias vi="nvim"

# ============================================================
# fzf 模糊查找集成
# ============================================================
source <(fzf --zsh)
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --color=always --style=numbers --line-range=:100 {}'"

# ============================================================
# zoxide（更智能的 cd，记忆常用目录）
# ============================================================
eval "$(zoxide init zsh)"
alias cd='z'

# ============================================================
# Ghostty Shell 集成（配合前面 config 中的 shell-integration）
# ============================================================
if [ -n "$GHOSTTY_RESOURCES_DIR" ]; then
    source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
fi

# ============================================================
# Starship 提示符（必须放在 .zshrc 最后）
# ============================================================
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
eval "$(starship init zsh)"


# ============================================================
# EDA 虚拟机 VNC 隧道
# ============================================================
vnc-off()  { pkill -f "5901:localhost:5901" 2>/dev/null; }
vnc-home() { vnc-off; ssh -fN -L 5901:localhost:5901 eda; }
vnc-ts()   { vnc-off; ssh -fN -L 5901:localhost:5901 eda-ts; }

# ============================================================
# C语言学习命令
# ============================================================
run() { local f="$1"; shift; gcc -Wall -Wextra -std=c11 -g -fsanitize=address,undefined "$f" -o /tmp/a.out -lm && /tmp/a.out "$@"; }
