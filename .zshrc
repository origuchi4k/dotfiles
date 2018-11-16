# Created by newuser for 5.0.5

### Env ###
export EDITOR=vim	# エディタをvimに設定
export LANG=ja_JP.UTF-8	# モジコードをUTF-8に設定
export KCODE=u		# KCODEにUTF-8を設定

### Bindkey ###
bindkey -v		# キーバインドをviモードに設定
bindkey '^j' vi-cmd-mode
bindkey -M viins '\er' history-incremental-pattern-search-forward
bindkey -M viins '^?'  backward-delete-char
bindkey -M viins '^A'  beginning-of-line
bindkey -M viins '^B'  backward-char
bindkey -M viins '^D'  delete-char-or-list
bindkey -M viins '^E'  end-of-line
bindkey -M viins '^F'  forward-char
bindkey -M viins '^G'  send-break
bindkey -M viins '^H'  backward-delete-char
bindkey -M viins '^K'  kill-line
bindkey -M viins '^N'  down-line-or-history
bindkey -M viins '^P'  up-line-or-history
bindkey -M viins '^R'  history-incremental-pattern-search-backward
bindkey -M viins '^U'  backward-kill-line
bindkey -M viins '^W'  backward-kill-word
bindkey -M viins '^Y'  yank

### Complement ###
autoload -U compinit; compinit	# 補完機能を有効にする
setopt auto_list		# 補完候補を一覧で表示する(d)
setopt auto_menu		# 補完キー連打で補完候補を順に表示する(d)
setopt list_packed		# 補完候補をできるだけ詰めて表示する
bindkey "^[[Z" reverse-menu-complete	# Shift-Tabで補完候補を逆順する

### Ls Color ###
# 色の設定
export LSCOLORS=Exfxcxdxbxegedabagacad
# 補完時の色の設定
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
# ZLS_COLORSとは？
export ZLS_COLORS=$LS_COLORS
# lsコマンド時、自動で色がつく(ls -Gのようなもの？)
alias ls='ls -G'
export CLICOLOR=true
# 補完候補に色を付ける
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

## Prompt ###
autoload -Uz colors; colors
autoload -Uz add-zsh-hook
autoload -Uz terminfo

tmp_prompt="%F{cyan}[%n@%D{%T}]%% %f"
tmp_prompt2="%F{cyan}%_> %f"
tmp_rprompt="%F{magenta}[%~]%f"

PROMPT=$tmp_prompt	# 通常のプロンプト
PROMPT2=$tmp_prompt2	# 通常のプロンプト
RPROMPT=$tmp_rprompt	# 右側のプロンプト

terminfo_down_sc=$terminfo[cud1]$terminfo[cuu1]$terminfo[sc]$terminfo[cud1]
left_down_prompt_preexec() {
    print -rn -- $terminfo[el]
}
add-zsh-hook preexec left_down_prompt_preexec

function zle-keymap-select zle-line-init zle-line-finish
{
    case $KEYMAP in
        main|viins)
            PROMPT_2="%F{yellow}-- INSERT --%f"
            ;;
        vicmd)
            PROMPT_2="%F{green}-- NORMAL --%f"
            ;;
    esac

#     PROMPT="%{$terminfo_down_sc$PROMPT_2$terminfo[rc]%}$tmp_prompt"
    PROMPT="%{$terminfo_down_sc$PROMPT_2$terminfo[rc]%}[%(?.%{${fg[cyan]}%}.%{${fg[red]}%})%n%{${reset_color}%}]%# "
    zle reset-prompt
	
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select
zle -N edit-command-line

# ------------------------------
# Other Settings
# ------------------------------

### Aliases ###
#時刻を表示させる
alias history='history -E'

# cdコマンド実行後、lsを実行する
function cd() {
  builtin cd $@ && ls;
}

### history ###
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
# 他のターミナルとヒストリーを共有
setopt share_history
# 直前と同じコマンドはヒストリに追加しない
setopt hist_ignore_dups
# 余分なスペースを削除してヒストリに保存する
setopt hist_reduce_blanks

# Ctrl+sのロック, Ctrl+qのロック解除を無効にする
setopt no_flow_control
