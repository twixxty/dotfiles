if status is-interactive
# Commands to run in interactive sessions can go here
end
if status is-interactive
    meow
end
function fish_prompt
    set -l last_status $status

    # show pwd only when not in home
    if test "$PWD" != "$HOME"
        set_color brblue
        echo -n (prompt_pwd)' '
    end

    # green > normally, red if the last command failed
    if test $last_status -eq 0
        set_color brgreen
    else
        set_color brred
    end
    echo -n '> '
    set_color normal
end

set -U fish_greeting "
haiiii >.<"

# Added by Antigravity CLI installer
fish_add_path -g "$HOME/.local/bin"
