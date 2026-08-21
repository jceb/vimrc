#!/usr/bin/env -S just --justfile

set shell := ["bash", "-euo", "pipefail", "-c"]

set default-list

# Applies all quilt patches
[group("patches")]
patch:
    quilt push -a

# Removes all applied quilt patches
[group("patches")]
unpatch:
    quilt pop -a || true

# Fetches changes from the remote
[group("jj")]
jj-fetch:
    jj git fetch
    jj rebase --onto "trunk()"

# Install, update and clean nvim plugins
[group("vim")]
nvim-plugin-sync:
    nvim -c ':lua require("lazy").sync({wait = true}); vim.cmd.qa()'
    jj commit -m "chore: update dependencies" lazy-lock.json

# Restore nvim plugins to the state registered in the lock file
[group("vim")]
nvim-plugin-restore:
    nvim -c ':lua require("lazy").restore({wait = true}); vim.cmd.qa()'

# Removes patches, fetches changes, then reapplies the patches again
update: unpatch jj-fetch nvim-plugin-restore patch

# Removes patches, fetches changes, updates plugins then reapplies the patches again
upgrade: unpatch jj-fetch nvim-plugin-sync patch
