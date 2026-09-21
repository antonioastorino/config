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

-- Line numbers.
vim.opt.number = true
vim.opt.relativenumber = true

-- Mouse stays on so selection and scrolling keep working, but a click in
-- another window is swallowed instead of moving focus there. getmousepos()
-- reports where the click landed before nvim acts on it.
for _, click in ipairs({ "<LeftMouse>", "<2-LeftMouse>", "<3-LeftMouse>", "<4-LeftMouse>" }) do
    vim.keymap.set({ "n", "i", "v" }, click, function()
        if vim.fn.getmousepos().winid ~= vim.api.nvim_get_current_win() then
            return ""
        end
        return click
    end, { expr = true })
end

-- Leave insert mode with jk; <esc> is disabled so the habit sticks.
vim.keymap.set("i", "jk", "<esc>")
vim.keymap.set("i", "<esc>", "<nop>")

-- Cursor line, shown only in the focused window.
vim.api.nvim_set_hl(0, "CursorLine", { ctermbg = 236, bg = "#303030" })

vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter", "FocusGained" }, {
    callback = function() vim.wo.cursorline = true end,
})
vim.api.nvim_create_autocmd({ "WinLeave", "FocusLost" }, {
    callback = function() vim.wo.cursorline = false end,
})

-- Window navigation. In terminal mode nvim has no <c-w> prefix, so leave
-- terminal mode first with <c-\><c-n>; Vim's <c-w>h works there directly.
for _, key in ipairs({ "h", "j", "k", "l" }) do
    vim.keymap.set("n", "<c-" .. key .. ">", "<c-w>" .. key)
    vim.keymap.set("i", "<c-" .. key .. ">", "<esc><c-w>" .. key)
    vim.keymap.set("t", "<c-" .. key .. ">", "<c-\\><c-n><c-w>" .. key)
end

-- Drop out of Terminal-Job mode. Vim uses <c-w>N, nvim <c-\><c-n>. Record
-- the choice so re-entering the window does not undo it.
vim.keymap.set("t", "<c-n>", function()
    vim.b.term_insert = false
    return "<c-\\><c-n>"
end, { expr = true })

-- Terminal. Vim opens :ter[minal] in a horizontal split, already in insert
-- mode; nvim takes over the current window and starts in normal mode.
-- One abbreviation per accepted prefix, guarded so it only fires when the
-- word is the command itself rather than an argument.
for _, cmd in ipairs({ "ter", "term", "termi", "termin", "termina", "terminal" }) do
    vim.cmd(string.format(
        [[cnoreabbrev <expr> %s (getcmdtype() ==# ':' && getcmdpos() == %d) ? 'belowright split \| terminal' : '%s']],
        cmd, #cmd + 1, cmd))
end

vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        -- Pasting leaves you in normal mode; go straight back to the prompt.
        vim.keymap.set("n", "p", "p<cmd>startinsert<cr>", { buffer = true })
        vim.cmd.startinsert()
    end,
})

-- Re-entering a terminal window restores the mode it was last left in.
-- Entering Terminal-Job mode by any means marks it as the state to restore;
-- only <c-n> above clears it. The window navigation maps pass through
-- <c-\><c-n>, which must not count as leaving insert on purpose.
vim.api.nvim_create_autocmd("TermEnter", {
    callback = function() vim.b.term_insert = true end,
})

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    callback = function()
        if vim.bo.buftype == "terminal" and vim.b.term_insert ~= false then
            vim.cmd.startinsert()
        end
    end,
})

-- File searching (:find, gf). Recursive, so headers resolve without knowing
-- the project layout.
vim.opt.path:append("**")

-- Vim completes the command line inline, cycling matches. Nvim defaults to
-- "pum,tagfile", which dumps every match into a popup instead.
vim.opt.wildoptions = ""
