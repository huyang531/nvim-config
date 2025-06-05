vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set softtabstop=4")
vim.cmd("set number")

require("config.lazy")
require("config.keymap")

-- TODO:
-- Auto complete is still pretty stupid? At least for lua files trying to access vim.<something>
-- YouTube Tutorial
-- Bug with telescope?
-- Lazy Git
-- Auto format on save?
