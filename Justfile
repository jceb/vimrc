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

# Update vim plugins
[group("vim")]
vim-plugin-update:
    nvim -c ':lua require("lazy").update({wait = true}); vim.cmd.qa()'
    jj commit -m "chore: update dependencies" lazy-lock.json

# Removes patches, fetches changes, then reapplies the patches again
update: unpatch jj-fetch patch

# Removes patches, fetches changes, updates plugins then reapplies the patches again
upgrade: unpatch jj-fetch vim-plugin-update patch
