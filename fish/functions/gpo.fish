function gpo -d "Pushes a new git branch to origin"
    git push -u origin (git rev-parse --abbrev-ref HEAD)
end