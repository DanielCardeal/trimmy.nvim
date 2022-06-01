# Trimmy.nvim

A simple, non-intrusive, diff based, whitespace trimmer that prevents you from
being hated by your coworkers!

## What it does

When working in a huge collaborative codebase, one may encounter the following
problem:

1. You need to change a single line of a ~500 lines file which contains **many**
   end of line whitespaces.

2. Before your changes are saved, your whitespace trimmer of choice deletes
   **all** the file's end of line whitespaces.

3. You try to commit your changes but cannot find where they are, since your
   `git status` is polluted with irrelevant whitespace changes.

4. You start reconsidering your life choices and call it quits for the day.

Having suffered with this problem myself, I have then decided to implement a
simple plugin to trim whitespace only on changed lines of edited buffers.

## Requirements

Since this plugin uses the newest features of Neovim's API, Neovim 0.7.0+ is
required.

There may be some Vim compatible alternative for `trimmy` in the future, but
this is not my top priority at the moment.

## Installation

Using your favorite plugin manager, integration should be as easy as installing
the plugin and calling `require('trimmy').setup()` somewhere in your `init.lua`.

- Example ([packer.nvim](https://github.com/wbthomason/packer.nvim)):

```lua
use {
    "DanielCardeal/trimmy",
    config = function()
        require('trimmy').setup()
    end
}
```

After that, `trimmy` should be able to detect and trim modified lines before
saving a buffer.

## Commands

This plugin exposes the following commands:

- `Trimmy`: trims contents of current edited buffer. 

- `TrimmyToggleTrimOnSave`: toggles trim-on-save functionality.

## Customization

A table of options can be passed to the `setup` function to configure the
plugin behavior. Current options are:

- `trimOnSave` (boolean): whether to enable auto-trimming on save on plugin
  initialization.

- `pattern` (list of strings): file patterns for files to trim on save.
