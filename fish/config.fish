# Initial Fisher first-run
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

# Only tinker with PATH in login shells
if status is-login
    # TODO
end

# Only bother with visual/alias changes in interactive shells
if status is-interactive
    # TODO
end

starship init fish | source

# Disable loading CRDs, since they're denied by RBAC
set -gx FISH_KUBECTL_COMPLETION_COMPLETE_CRDS 0

