fastfetch

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Created by newuser for 5.9
# Use your plugin system here

#return 1 # <--- Comment this line to disable HyDE's oh-my-zsh plugins and use the zinit examples below

#! This file will not load, remove the return 1 line above to enable this file.
#? Below is an example of how to set up Zsh plugins using Zinit

# ================================================================

# Zinit plugin manager setup
# This section ensures zinit is installed and sourced, which allows you to manage plugins efficiently.
# Zinit is fast, flexible, and supports loading plugins, snippets, and more from GitHub and other sources.

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit ice depth"1" 
zinit light romkatv/powerlevel10k


# Plugin: history-search-multi-word
# Allows searching your command history by multiple words, making it easier to find previous commands.
zinit load zdharma-continuum/history-search-multi-word

# Plugin: zsh-autosuggestions
# Suggests commands as you type based on your history and completions, improving efficiency.
zinit light zsh-users/zsh-autosuggestions

# Plugin: fast-syntax-highlighting
# Provides fast syntax highlighting for your Zsh command line, making it easier to spot errors.
zinit light zdharma-continuum/fast-syntax-highlighting

# Snippet: Useful Zsh functions
# Loads a collection of handy Zsh functions from a Gist.
zinit snippet https://gist.githubusercontent.com/hightemp/5071909/raw/

# Plugin: z (rupa/z)
# Enables quick directory jumping based on your usage history.
# just like zoxide, but for zsh
zinit light rupa/z

# Plugin: zsh-completions
# Adds many extra tab completions for Zsh, improving command-line productivity.
zinit light zsh-users/zsh-completions

# Plugin: zsh-history-substring-search
# Lets you search your history for commands containing a substring, similar to Oh My Zsh.
zinit light zsh-users/zsh-history-substring-search

# Snippet: Oh My Zsh git plugin
# Loads useful git aliases and functions from Oh My Zsh's git plugin.
zinit snippet https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh

# Plugin: zsh-autopair
# Automatically inserts matching brackets, quotes, etc., as you type.
zinit light hlissner/zsh-autopair

# Plugin: fzf-tab
# Enhances tab completion with fzf-powered fuzzy search and a better UI.
zinit light Aloxaf/fzf-tab

# Plugin: alias-tips
# Shows tips for using defined aliases when you type commands, helping you learn and use your aliases.
zinit light djui/alias-tips

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#开启tab上下左右选择补全
zstyle ':completion:*' menu select
autoload -Uz compinit
compinit

# 设置历史记录文件的路径
HISTFILE=~/.zsh_history

# 设置在会话（内存）中和历史文件中保存的条数，建议设置得大一些
HISTSIZE=1000
SAVEHIST=1000

# 忽略重复的命令，连续输入多次的相同命令只记一次
setopt HIST_IGNORE_DUPS

# 忽略以空格开头的命令（用于临时执行一些你不想保存的敏感命令）
setopt HIST_IGNORE_SPACE

# 在多个终端之间实时共享历史记录
# 这是实现多终端同步最关键的选项
setopt SHARE_HISTORY

# 让新的历史记录追加到文件，而不是覆盖
setopt APPEND_HISTORY
# 在历史记录中记录命令的执行开始时间和持续时间
setopt EXTENDED_HISTORY

