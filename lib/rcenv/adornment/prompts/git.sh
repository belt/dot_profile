function git_prompt() {
  local git_status="`git status -unormal 2>&1`"
  if ! [[ "$git_status" =~ Not\ a\ git\ repo ]]; then
    if [[ "$git_status" =~ nothing\ to\ commit ]]; then
      # no changes added to commit
      local ansi=35
    elif [[ "$git_status" =~ Changes\ to\ be\ committed ]]; then
      # Changes to be committed
      local ansi=33
    elif [[ "$git_status" =~ nothing\ added\ to\ commit\ but\ untracked\ files\ present ]]; then
      # nothing added to commit but untracked files present
      local ansi=36
    else
      # nothing to commit, working directory clean
      local ansi=32
    fi

    [[ "$git_status" =~ On\ branch\ ([^[:space:]]+) ]]
    PS1="\[\033[01m\]\[\033[32m\]\u@\h\[\033[00m\]:\[\033[01m\]\[\033[31m\]\w\[\033[00m\]"; export PS1
    if [ -z "${BASH_REMATCH[1]}" -o "${BASH_REMATCH[1]}" == 'master' ]; then
      PS1="${PS1}\$ "; builtin export PS1
    else
      PS1="${PS1}\[\033[00m\][\[\033[${ansi}m\]${BASH_REMATCH[1]}\[\033[00m\]]\$ "; builtin export PS1
    fi
  fi
}
