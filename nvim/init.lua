--vim.opt.scrolloff = 26
vim.opt.scrolloff = 10

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.cmd [[set undofile]]
vim.cmd [[set undodir=$HOME/.undodir]]
vim.cmd [[set mouse=]]

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- all plugins are in ~/.config/nvim/lua/plugins/*.lua
require("lazy").setup("plugins")
require("nvim-lastplace").setup {}

vim.cmd [[colorscheme tokyonight-moon]]
vim.cmd [[set number]]
vim.cmd [[set relativenumber]]
vim.cmd [[    autocmd BufRead * autocmd FileType <buffer> ++once
      \ if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif
]]
vim.cmd [[noremap! <C-BS> <C-w>]]
vim.cmd [[noremap! <C-h> <C-w>]]
vim.cmd [[xnoremap Y "+y]]
--vim.cmd[[set clipboard=unnamedplus]]

-- Setup language servers.
local lspconfig = require('lspconfig')
lspconfig.ruff.setup {
    init_options = {
        settings = {
            -- Any extra CLI arguments for `ruff` go here.
            args = { importStrategy = 'useBundled' },
        }
    }
}
-- https://docs.google.com/spreadsheets/d/1Of-wqgZc4htqWn_V5QVPjQW5ozppDE4Chcm-EIS-gUY/edit?gid=0#gid=0
lspconfig.pyright.setup {
    settings = {
        python = {
            venvPath = '/home/sweijen/anaconda3/',
            pythonVersion = 3.12,
            pythonPlatform = "Linux",
            analysis = { diagnosticMode = 'openFilesOnly', disableTaggedHints = true },
            --analysis = { ignore = { "*" } },
        },
        pyright = {
            -- Disable to use Ruff's import organiser.
            disableOrganizeImports = true,
            disableTaggedHints = true,
        },
    }
}

--lspconfig.basedpyright.setup {
--    settings = {
--        basedpyright = {
--            openFilesOnly = true,
--            analysis = {
--                diagnosticMode = "openFilesOnly"
--            }
--        }
--    }
--}

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = false,
    signs = true,
    update_in_insert = false,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
            return
        end
        if client.name == 'ruff' then
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
        end
    end,
    desc = 'LSP: Disable hover capability from Ruff',
})

lspconfig.rust_analyzer.setup {
    -- Server-specific settings. See `:help lspconfig-setup`
    settings = {
        ['rust-analyzer'] = {},
    },
}
lspconfig.lua_ls.setup {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
}

-- Make line numbers more readable
vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = '#51B3EC', bold = true })
vim.api.nvim_set_hl(0, 'LineNr', { fg = 'white', bold = true })
vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = '#FB508F', bold = true })

-- Indentation
vim.o.tabstop = 4      -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4  -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4   -- Number of spaces inserted when indenting

-- Global mappings.
--local builtin = require('telescope.builtin')
--vim.keymap.set('n', '<C-A-T>', function () builtin.builtin() end)
vim.keymap.set('v', 'Y', '"+y')
vim.keymap.set({ 'n', 'i' }, '<C-BS>', '<C-W>')

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

vim.keymap.set('n', '<a-I>', ":! isort " .. vim.fn.expand("%") .. "<cr><cr>")

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})
