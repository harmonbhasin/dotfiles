# --- Environment ---

# Paths
set -gx BUN_INSTALL "$HOME/.bun"
fish_add_path "$BUN_INSTALL/bin"
set -x GOPATH $HOME/go

# IDE
set -gx EDITOR "nvim"
set -g fish_key_bindings fish_vi_key_bindings

# Prevent general pip installation
set -g -x PIP_REQUIRE_VIRTUALENV true

# --- Commands ---
if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source

    # Aliases
    # Mine
    alias vi "nvim"
    alias v "nvim"
    alias python "python3"
    alias pip "pip3"
    # Work
    alias change-ec2 "/Users/harmonbhasin/work/securebio/instance_manipulator.sh"
    alias check-ec2 "/Users/harmonbhasin/work/securebio/check_ec2.sh"
    alias start-ec2 "/Users/harmonbhasin/work/securebio/start_ec2.sh"
    alias stop-ec2 "/Users/harmonbhasin/work/securebio/stop_ec2.sh"
    alias grab-ec2 "/Users/harmonbhasin/work/securebio/grab_ec2.sh"


    atuin init fish | source
end
alias claude="/Users/harmonbhasin/.claude/local/claude"

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/harmonbhasin/.lmstudio/bin
# End of LM Studio CLI section

