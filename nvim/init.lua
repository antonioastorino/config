-- Neovim configuration.
-- Ported from ../.vimrc one piece at a time.

-- Leader. Must come before any mapping that uses it.
vim.g.mapleader = " "

-- Reload / edit this configuration.
vim.keymap.set("n", "<leader>sv", function()
    vim.cmd.source(vim.env.MYVIMRC)
    vim.notify("Reloaded " .. vim.env.MYVIMRC)
end, { desc = "Source config" })

vim.keymap.set("n", "<leader>ev", "<cmd>vsplit $MYVIMRC<cr>", { desc = "Edit config" })

-- Save / quit.
vim.keymap.set("n", "<leader><leader>w", "<cmd>w<cr>", { desc = "Write buffer" })
vim.keymap.set("n", "<leader><leader>q", "<cmd>q<cr>", { desc = "Quit window" })

-- File searching (:find, gf). Recursive, so headers resolve without knowing
-- the project layout.
vim.opt.path:append("**")

-- Vim completes the command line inline, cycling matches. Nvim defaults to
-- "pum,tagfile", which dumps every match into a popup instead.
vim.opt.wildoptions = ""
