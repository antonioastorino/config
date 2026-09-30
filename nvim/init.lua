-- Neovim configuration.
-- Ported from ../.vimrc one piece at a time.

-- Leader. Must come before any mapping that uses it.
vim.g.mapleader = " "

-- Every autocmd below belongs to this group, which is cleared each time the
-- file is sourced. Without it a reload stacks a second copy of every handler.
local augroup = vim.api.nvim_create_augroup("init", { clear = true })

-- Plugins live in ~/.local/share/nvim/site/pack/plugins/start and are only
-- added to 'runtimepath' at startup, so one cloned mid-session is missing
-- until nvim is restarted. Without this guard that aborts the whole file and
-- everything below the failing require silently stops working.
local function setup(name, opts)
    local ok, module = pcall(require, name)
    if not ok then
        vim.notify(name .. " not found; restart nvim if you just installed it", vim.log.levels.WARN)
        return
    end
    module.setup(opts)
end

-- Reload / edit this configuration.
vim.keymap.set("n", "<leader>sv", function()
    vim.cmd.source(vim.env.MYVIMRC)
    -- A plugin's setup() re-runs, but its per-buffer on_attach does not, so
    -- mappings defined there would be missing until a restart.
    local ok, gs = pcall(require, "gitsigns")
    if ok then
        gs.detach_all()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) then
                gs.attach(buf)
            end
        end
    end
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
    -- Control flow, otherwise indistinguishable from every other keyword:
    -- do/while/for, then if/else. The legacy Repeat and Conditional groups
    -- have no effect here, the captures route straight to @keyword.
    ["@keyword.repeat"]      = { fg = "#e5a06a" }, -- Orange
    ["@keyword.conditional"] = { fg = "#e5a06a" }, -- Orange
    ["@keyword.return"]      = { fg = "#6cc7b8" }, -- Teal
    -- sizeof and friends: keyword grey, italic to mark them as operators
    -- rather than spending another hue on them.
    ["@keyword.operator"]    = { fg = "#c5c8c6", italic = true },
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
    group = augroup,
    callback = function(ev) pcall(vim.treesitter.start, ev.buf) end,
})

-- Save / quit.
vim.keymap.set("n", "<leader><leader>w", "<cmd>w<cr>", { desc = "Write buffer" })
vim.keymap.set("n", "<leader><leader>q", "<cmd>q<cr>", { desc = "Quit window" })

-- The jumplist is restored from the shada file, so <c-o> walked back into a
-- previous session's history. Setting '0 in 'shada' does not stop it:
-- including the ' item at all is what stores the jumplist, and it cannot be
-- left out while 'shada' is non-empty. Clearing the list once nvim has
-- started is the way; marks, registers and history keep working.
vim.api.nvim_create_autocmd("VimEnter", {
    group = augroup,
    callback = function()
        -- VimEnter fires before the shada file is read, so clear on the
        -- next tick of the loop, once startup has actually finished.
        vim.schedule(function() vim.cmd("clearjumps") end)
    end,
})

-- Line numbers.
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation: four spaces, two for the web-ish filetypes.
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = { "html", "javascript", "typescript", "swift" },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.shiftwidth = 2
    end,
})

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

    -- In a terminal, a click would position the cursor and so drop out of
    -- Terminal-Job mode. Swallow it and keep typing.
    vim.keymap.set("t", click, "<nop>")
end

-- Leave insert mode with jk; <esc> is disabled so the habit sticks.
vim.keymap.set("i", "jk", "<esc>")
vim.keymap.set("i", "<esc>", "<nop>")

-- Cursor line, shown only in the focused window.
vim.api.nvim_set_hl(0, "CursorLine", { ctermbg = 236, bg = "#303030" })

vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter", "FocusGained" }, {
    group = augroup,
    callback = function() vim.wo.cursorline = true end,
})
vim.api.nvim_create_autocmd({ "WinLeave", "FocusLost" }, {
    group = augroup,
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

-- Tags. Regenerated on write and at startup, but only in projects that opt
-- in by having a .keep-tags file. vim.system() runs it without blocking,
-- which is what .vimrc used job_start() for.
vim.opt.tags = "./tags;,tags;"

vim.api.nvim_create_autocmd({ "BufWritePost", "VimEnter" }, {
    group = augroup,
    callback = function()
        if vim.fn.filereadable(".keep-tags") == 1 and vim.fn.executable("ctags") == 1 then
            vim.system({ "ctags", "-R", "." })
        end
    end,
})

vim.keymap.set("n", "gd", function()
    local ok, err = pcall(vim.cmd, "tag " .. vim.fn.expand("<cword>"))
    if not ok then
        vim.notify(err:gsub("^.-:%s*", ""), vim.log.levels.WARN)
    end
end, { silent = true, desc = "Jump to tag" })

-- Arrows resize the window instead of moving the cursor.
vim.keymap.set("n", "<Up>", "<cmd>resize +2<cr>", { desc = "Taller" })
vim.keymap.set("n", "<Down>", "<cmd>resize -2<cr>", { desc = "Shorter" })
vim.keymap.set("n", "<Right>", "<cmd>vertical resize +2<cr>", { desc = "Wider" })
vim.keymap.set("n", "<Left>", "<cmd>vertical resize -2<cr>", { desc = "Narrower" })

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

-- The shell's working directory, which is not nvim's once you cd in the
-- terminal. Linux exposes it as a symlink under /proc; macOS and the BSDs
-- have no /proc, so ask lsof for the process's cwd descriptor instead.
local function shell_cwd(pid)
    if not pid then
        return nil
    end

    local link = "/proc/" .. pid .. "/cwd"
    if vim.uv.fs_stat(link) then
        return vim.uv.fs_readlink(link)
    end

    local ok, out = pcall(function()
        return vim.system({ "lsof", "-a", "-p", tostring(pid), "-d", "cwd", "-Fn" }, { text = true }):wait()
    end)
    if not ok or out.code ~= 0 then
        return nil
    end
    for line in out.stdout:gmatch("[^\n]+") do
        local dir = line:match("^n(.+)")
        if dir then
            return dir
        end
    end
end

vim.api.nvim_create_autocmd("TermOpen", {
    group = augroup,
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        -- Pasting leaves you in normal mode; go straight back to the prompt.
        vim.keymap.set("n", "p", "p<cmd>startinsert<cr>", { buffer = true })

        -- Plain gf would open the file in this window and destroy the
        -- terminal. Open it in a split of the window we came from instead,
        -- and honour the file:line:col that compilers and grep print --
        -- <cfile> stops at the colon, so the position is read off the line.
        vim.keymap.set("n", "gf", function()
            local file = vim.fn.expand("<cfile>")
            if file == "" then
                return
            end

            local text, cursor = vim.api.nvim_get_current_line(), vim.fn.col(".")
            local lnum, cnum
            local from = 1
            while true do
                local first, last = text:find(file, from, true)
                if not first then
                    break
                end
                if cursor >= first and cursor <= last + 1 then
                    lnum, cnum = text:match("^:(%d+):?(%d*)", last + 1)
                    break
                end
                from = last + 1
            end

            if not vim.startswith(file, "/") then
                local dir = shell_cwd(vim.b.terminal_job_pid)
                if dir then
                    file = dir .. "/" .. file
                end
            end

            local term = vim.api.nvim_get_current_win()
            vim.cmd("wincmd p")
            if vim.api.nvim_get_current_win() == term then
                vim.cmd("wincmd w")
            end
            vim.cmd("split")
            vim.cmd.edit(file)
            if lnum then
                vim.api.nvim_win_set_cursor(0, { tonumber(lnum), math.max((tonumber(cnum) or 1) - 1, 0) })
            end
        end, { buffer = true, desc = "Open file under cursor" })
        vim.cmd.startinsert()
    end,
})

-- Re-entering a terminal window restores the mode it was last left in.
-- Entering Terminal-Job mode by any means marks it as the state to restore;
-- only <c-n> above clears it. The window navigation maps pass through
-- <c-\><c-n>, which must not count as leaving insert on purpose.
vim.api.nvim_create_autocmd("TermEnter", {
    group = augroup,
    callback = function() vim.b.term_insert = true end,
})

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    group = augroup,
    callback = function()
        if vim.bo.buftype == "terminal" and vim.b.term_insert ~= false then
            vim.cmd.startinsert()
        end
    end,
})

-- File browsing, replacing netrw. A directory is an ordinary buffer: rename
-- by editing the line, delete with dd, create by adding a line, then :w to
-- apply. "-" goes to the parent directory, g? lists the keys.
setup("oil", {
    default_file_explorer = true,
    delete_to_trash = true,
    view_options = { show_hidden = true },
})

-- In a floating window, so it never occupies a real window: opening a file
-- closes the float and leaves the layout untouched, and the browser never
-- enters the jumplist. q closes it.
vim.keymap.set("n", "<leader>l", function()
    require("oil").open_float()
end, { desc = "Browse files" })

-- <bs> goes up a directory, alongside oil's own "-".
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = "oil",
    callback = function(ev)
        vim.keymap.set("n", "<bs>", require("oil.actions").parent.callback,
            { buffer = ev.buf, desc = "Parent directory" })
    end,
})

-- <c-t> toggles a terminal in its own full-height column on the right.
-- The buffer is tagged rather than held in a local, so a <leader>sv reload
-- does not lose track of a terminal that is already open.
local function toggle_terminal()
    local term
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.b[buf].toggle_term then
            term = buf
            break
        end
    end

    if term then
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_buf(win) == term then
                if #vim.api.nvim_list_wins() > 1 then
                    vim.api.nvim_win_close(win, false)
                end
                return
            end
        end
    end

    vim.cmd("vsplit")
    vim.cmd("wincmd L")
    if term then
        vim.api.nvim_win_set_buf(0, term)
    else
        vim.cmd("terminal")
        vim.b[vim.api.nvim_get_current_buf()].toggle_term = true
    end
    vim.cmd.startinsert()
end

vim.keymap.set({ "n", "t" }, "<c-t>", toggle_terminal, { desc = "Toggle terminal" })

-- Git signs, replacing vim-gitgutter. Same sign text and mappings; the
-- preview toggles itself, so ToggleHunkPreview() is not needed.
vim.opt.updatetime = 100

setup("gitsigns", {
    signs = {
        add          = { text = "++" },
        change       = { text = "~~" },
        delete       = { text = "__" },
        topdelete    = { text = "^^" },
        changedelete = { text = "~_" },
    },
    on_attach = function(buf)
        local gs = require("gitsigns")
        local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
        end
        map("<leader>hp", gs.preview_hunk, "Preview hunk")
        map("<leader>hu", gs.reset_hunk, "Undo hunk")
        map("<leader>hn", function() gs.nav_hunk("next") end, "Next hunk")
        map("<leader>hN", function() gs.nav_hunk("prev") end, "Previous hunk")
    end,
})

vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#00ff00", bg = "#0000ff" })
vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#ffff00", bg = "#008000" })
vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#ff0000", bg = "#ffff00" })

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
