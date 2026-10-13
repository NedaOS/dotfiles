function fish_prompt
    set -l last_status $status

    # Read the latest Noctalia palette on every prompt
    if test -r ~/.config/fish/noctalia-prompt-colors.fish
        source ~/.config/fish/noctalia-prompt-colors.fish
    end

    # Current directory
    if set -q noctalia_prompt_directory
        set_color $noctalia_prompt_directory
    else
        set_color normal
    end
    printf '%s' "$PWD"

    # Git branch
    if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
        set -l branch (command git branch --show-current)

        if set -q noctalia_prompt_git
            set_color $noctalia_prompt_git
        end

        if test -n "$branch"
            printf ' 󰊢 %s' "$branch"
        else
            printf ' 󰊢 detached'
        end
    end

    printf '\n'

    # Command status
    if test $last_status -eq 0
        if set -q noctalia_prompt_success
            set_color $noctalia_prompt_success
        end
        printf '❯ '
    else
        if set -q noctalia_prompt_error
            set_color $noctalia_prompt_error
        end
        printf '✗ [%d] ❯ ' $last_status
    end

    set_color normal
end
