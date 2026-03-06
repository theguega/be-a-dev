git config --global alias.wta '!f() { git worktree add -b "$1" "../$1"; }; f'
git config --global alias.wtr '!f() { git worktree remove "../$1"; }; f'
git config --global alias.wtl '!f() { git worktree list; }; f'
