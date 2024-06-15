_ossh_and_ssh_completions() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"

    # Fetch hostnames from ~/.ssh/config
    hostnames=$(awk '/^Host / { for (i = 2; i <= NF; i++) print $i }' ~/.ssh/config)

    # Set opts
    opts="${hostnames}"

    # Provide completions
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )

    return 0
}

complete -F _ossh_and_ssh_completions ossh
