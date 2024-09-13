#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\[\e[36m\]\u\[\e[0m\]@\[\e[32m\]\h\[\e[0m\] \[\e[33m\]\W\[\e[0m\]]\[\e[35m\]\\$\[\e[0m\] '

HISTTIMEFORMAT='%F %T '


#---------------------------------------------------------

# exports

export EDITOR=nvim


#---------------------------------------------------------


# listings
alias ls='eza'
alias ll='eza -la'

# better tree
alias tree='tree -C --dirsfirst'

# mkdir with make parent directories + verbose
alias mkdir='mkdir -p -v'


# python init venv
alias vinit='python -m venv .venv; source .venv/bin/activate'

# python activate venv
alias va='source .venv/bin/activate'

# python deactivate venv
alias vd='deactivate'


# ping check
alias pc='ping -c 5 1.1.1.1'


# grep bash history
alias hg='history | grep'


#---------------------------------------------------------


# shell wrapper for changing working directory when exiting yazi
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
