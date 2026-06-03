# JC's neovim configuration

## Install

- Clone repository: `git clone https://github.com/jceb/vimrc.git ~/.config/nvim`
- Make sure you install language servers, build-utils, go, etc. all kinds of
  components that you deem important for your setup.
- Install plugins by starting neovim (a few errors might be shown at the end.
  Just quit with `:q`): `nvim`
- Apply patches to plugins (yes, I maintain a number of patches for plugins that
  I don't want to / can't get merged upstream):
  `cd ~/.confg/nvim; quilt push -a`

### Trying it out without replacing your config

If you want to give my configuration a spin without replacing your own
configuration, just follow these steps:

- Clone repository:
  `git clone https://github.com/jceb/vimrc.git ~/.config/nvim-jc`
- Tell neovim to use this configuration: `export NVIM_APPNAME=nvim-jc`
- Follow the rest of the installation instructions layed out above.

## Configuration

See [`./init.lua`](./init.lua)
