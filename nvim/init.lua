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

-- Colours. Everything not listed here stays at nvim's default.
-- To change one: put the cursor on the token, run :Inspect to see which
-- groups apply, and add or edit a line below. 'termguicolors' is on, so
-- values are gui hex -- ctermfg is ignored and will silently do nothing.
-- Setting a legacy group (Type) covers all the treesitter captures that
-- link to it (@type, @type.definition, ...); set a capture directly
-- (@type.builtin) only when you want it to differ from the rest.
for group, spec in pairs({
    -- The .vimrc colours by intent, softened for a truecolor display: the
    -- raw ANSI values (#ff0000, #0000ff) are harsh on this background.
    Statement  = { fg = "#c5c8c6", bold = true }, -- Gray
    Identifier = { fg = "#b8bcc0" },              -- Gray
    String     = { fg = "#c792ea" },              -- Mauve
    Function   = { fg = "#a8d4ec", bold = true }, -- LightBlue
    Comment    = { fg = "#6a9955" },              -- DarkGreen
    Constant   = { fg = "#e06c75" },              -- Red
    Special    = { fg = "#bfbf2f" },              -- DaryYellow 
    Type       = { fg = "#ffff7b" },              -- Yellow
    PreProc    = { fg = "#82b1ff", bold = true }, -- Blue
    -- The directive captures fall back to @keyword, not PreProc, so they
    -- need linking explicitly: #define/#ifdef/#endif, then #include.
    ["@keyword.directive"] = { link = "PreProc" },
    ["@keyword.import"]    = { link = "PreProc" },
    -- int32_t is @type.builtin, which defaults to Special, and static/void
    -- are @type.qualifier, which falls through to Statement. Put both on
    -- Type so every type reads the same.
    ["@type.builtin"]      = { link = "Type" },
    ["@type.qualifier"]    = { link = "Type" },
}) do
    vim.api.nvim_set_hl(0, group, spec)
end

-- Treesitter is finer grained than Vim's syntax groups, so some captures
-- land on the wrong colour.
-- @constant is any ALL_CAPS identifier, including every macro where it is
-- used rather than defined; the parser cannot tell those from a constant.
-- Vim left them uncoloured, so clear it. @constant.builtin (NULL, true) and
-- @number keep their own links and stay Constant-coloured, as in Vim.
vim.api.nvim_set_hl(0, "@constant", {})
vim.api.nvim_set_hl(0, "@function.macro", { link = "PreProc" })

-- Treesitter highlighting wherever a parser is installed; everything else
-- falls back to the legacy syntax highlighter. Adding a language is
-- :TSInstall <lang>, no change here. Replaces after/syntax/c.vim and
-- vim-cpp-modern, which both approximate with regexes what the parser knows.
vim.treesitter.language.register("bash", "sh")

vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev) pcall(vim.treesitter.start, ev.buf) end,
})

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

-- Move by 10 lines.
vim.keymap.set("n", "<leader>j", "10j")
vim.keymap.set("n", "<leader>k", "10k")

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

-- Formatting. Each entry builds a command that reads the buffer on stdin and
-- writes the result to stdout, so a failing formatter cannot damage the file
-- the way Vim's "w !cmd > %" could: nothing is written unless it succeeds.
-- The buffer is filtered in place, which keeps the cursor and one undo step.
local formatters = {
    c          = function(f) return { "clang-format", "--style=file:" .. vim.env.HOME .. "/config/.clang-format", "--assume-filename=" .. f } end,
    python     = function() return { "autopep8", "--aggressive", "--aggressive", "--max-line-length", "100", "-" } end,
    sh         = function() return { "shfmt", "-i", "4", "-" } end,
    rust       = function() return { "rustfmt", "--emit", "stdout" } end,
    zig        = function() return { "zig", "fmt", "--stdin" } end,
    swift      = function() return { "swift-format" } end,
}
formatters.cpp = formatters.c
formatters.objc = formatters.c
formatters.objcpp = formatters.c
formatters.arduino = formatters.c

for _, ft in ipairs({ "css", "html", "json", "javascript", "typescript" }) do
    formatters[ft] = function(f)
        return { "npx", "prettier", "--config", vim.env.HOME .. "/config/.prettierrc.json", "--stdin-filepath", f }
    end
end

local function format()
    local build = formatters[vim.bo.filetype]
    if not build then
        vim.notify("Cannot format: no formatter for '" .. vim.bo.filetype .. "'", vim.log.levels.WARN)
        return
    end

    local buf = vim.api.nvim_get_current_buf()
    local input = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n") .. "\n"
    local result = vim.system(build(vim.api.nvim_buf_get_name(buf)), { stdin = input, text = true }):wait()

    if result.code ~= 0 then
        vim.notify(vim.trim(result.stderr ~= "" and result.stderr or "formatter failed"), vim.log.levels.ERROR)
        return
    end

    local view = vim.fn.winsaveview()
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split((result.stdout:gsub("\n$", "")), "\n"))
    vim.fn.winrestview(view)
end

vim.keymap.set("n", "<c-f>", format, { desc = "Format buffer" })
vim.keymap.set("i", "<c-f>", function()
    vim.cmd.stopinsert()
    format()
end, { desc = "Format buffer" })
