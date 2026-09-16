-- ============================================================================
-- BEGIN Nvim init file
-- ============================================================================
-- Requirements for this configuration to work:
-- nvim >= v0.12
-- pynvim
-- ripgrep
-- ============================================================================
-- Plugins declaration
-- ============================================================================
vim.pack.add {
    { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },        -- Nice theme
    { src = 'https://github.com/neovim/nvim-lspconfig' },                       -- Language processor
    { src = 'https://github.com/kyazdani42/nvim-tree.lua' },                    -- File explorer
    { src = 'https://github.com/tpope/vim-fugitive' },                          -- Use Git commands
    { src = 'https://github.com/lewis6991/gitsigns.nvim' },                     -- Show Git changes
    { src = 'https://github.com/nvim-lua/plenary.nvim' },                       -- Lua library for Nvim
    { src = 'https://github.com/numToStr/Comment.nvim' },                       -- Comment lines easily
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },             -- Parsing tools
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' }, -- Parsing tools
    { src = 'https://github.com/nvim-lualine/lualine.nvim' },                   -- Nice status line
    { src = 'https://github.com/lukas-reineke/indent-blankline.nvim' },         -- Visual indentations lines
    { src = 'https://github.com/tpope/vim-sleuth' },                            -- Auto-adapt shiftwidth to filetype
    { src = 'https://github.com/Shougo/deoplete.nvim' },                        -- Good autocompletion
    { src = 'https://github.com/nvim-tree/nvim-web-devicons' },                 -- File icons in Nvim-tree
    { src = 'https://github.com/romgrk/barbar.nvim' },                          -- Display buffers as tabs
    { src = 'https://github.com/nvim-telescope/telescope.nvim' },               -- Search for files or strings in projects
    { src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim' },    -- Fuzzy search in telescope
    { src = 'https://github.com/vladdoster/remember.nvim' },                    -- Reopen files at same position
 }

-- ============================================================================
-- General configuration
-- ============================================================================
-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

-- Mappings
function nmap(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, {
      noremap = true,
      silent = true
  })
end

-- Set colorscheme
require("catppuccin").setup({
    flavour = "macchiato", -- latte, frappe, macchiato, mocha
    transparent_background = true,
})
vim.cmd.colorscheme "catppuccin-nvim"

-- Global config
vim.o.encoding = utf8
vim.o.whichwrap = "<,>,[,]"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.autoread = true
vim.o.autochdir = true
vim.o.colorcolumn = "80"
vim.o.showcmd = true
vim.o.splitright = true
vim.o.smartindent = true
vim.o.cinoptions = "(0"
vim.o.number = true
vim.o.termguicolors = true

-- ============================================================================
-- Keymapping config
-- ============================================================================
-- Define leader key
vim.g.mapleader = ","
-- Use 'kj' as it is faster than reaching Esc
vim.keymap.set('i', 'kj', '<Esc>', {})
vim.keymap.set('c', 'kj', '<Esc>', {})
vim.keymap.set('v', 'kj', '<Esc>', {})
-- Ease navigation between splitted panes
vim.keymap.set('n', '<C-J>', '<C-W><C-J>', {}) 
vim.keymap.set('n', '<C-K>', '<C-W><C-K>', {}) 
vim.keymap.set('n', '<C-L>', '<C-W><C-L>', {}) 
vim.keymap.set('n', '<C-H>', '<C-W><C-H>', {}) 
-- Break line at cursor position
vim.keymap.set('n', 'L', 'i<Enter><Esc>', {})
-- in terminal mode, use Esc to go back to normal
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', {})
-- Y will copy until the end of line
vim.keymap.set('n', 'Y', 'y$', {})
-- U will act as redo
vim.keymap.set('n', 'U', '<C-r>', {})
-- Enter will disable highlighting of last searched pattern
vim.keymap.set('n', '<CR>', ':nohlsearch<CR><CR>', {})
-- Lang spelling check for french and english
vim.keymap.set('n', '<F6>', '<Esc>:silent setlocal spell! spelllang=fr<CR>', {})
vim.keymap.set('n', '<F7>', '<Esc>:silent setlocal spell! spelllang=en<CR>', {})
-- Use Alt-k / Alt-j to move a line up / down
vim.keymap.set('n', '<A-k>', 'ddkP', {})
vim.keymap.set('n', '<A-j>', 'ddp', {})

-- ============================================================================
-- Plugins config
-- ============================================================================

-- ========================
-- BEGIN Deoplete config
-- See `:help deoplete`
vim.cmd([[
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
let g:deoplete#enable_at_startup = 1
]])
-- END Deoplete config
-- ========================

-- ========================
-- BEGIN Lualine config
-- See `:help lualine.txt`
lualine = {
    all = function(colors)
        return {
            normal = {
                a = { bg = colors.lavender, gui = "italic" },
                b = { fg = colors.lavender },
            }
        }
    end,
    macchiato = {
        normal = {
            a = { bg = "#abcdef" },
        }
    },
},
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'catppuccin-nvim',
  },
}
-- END Lualine config
-- ========================

-- ========================
-- BEGIN Comment config
-- https://github.com/numToStr/Comment.nvim
-- Comment line: 'gcc' / lines: 'gc' / selected block: 'gb'
require('Comment').setup()
-- END Comment config
-- ========================

-- ========================
-- BEGIN indent-blankline
local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)
require("ibl").setup { indent = { highlight = highlight } }
-- END indent-blankline
-- ========================

-- ========================
-- BEGIN Nvim Tree config
-- See `:help nvim-tree`
-- Toggle with <leader>,
vim.keymap.set('', '<leader>t', ':NvimTreeToggle<CR>', {})
require'nvim-tree'.setup {
  renderer = {
    indent_markers = {
      enable = true,
    }
  }
}
-- END Nvim Tree
-- ========================

-- ========================
-- BEGIN Gitsigns config
-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}
-- END Gitsigns config
-- ========================

-- ========================
-- BEGIN BarBar config
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
-- Move to previous/next
map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<A-;>', '<Cmd>BufferNext<CR>', opts)
-- Re-order to previous/next
map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)
-- Pin/unpin buffer
map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
-- Close buffer
map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
-- Sort automatically by...
map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)
-- BarBar configs
require'barbar'.setup {
icons = {
    -- Configure the icons on the bufferline based on the visibility of a buffer.
    -- Supports all the base icon options, plus `modified` and `pinned`.
    alternate = {filetype = {enabled = false}},
    current = {buffer_index = true},
    inactive = {button = '×'},
    visible = {modified = {buffer_number = false}},
  },
}
-- END BarBar config
-- ========================

-- ========================
-- BEGIN Telescope config
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {
    desc = 'Telescope find files'
})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {
    desc = 'Telescope live grep'
})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {
    desc = 'Telescope buffers'
})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {
    desc = 'Telescope help tags'
})
-- END Telescope config
-- ========================

-- ========================
-- BEGIN Remember config
require'remember'.setup {}
-- END Remember config
-- ========================
--
-- ============================================================================
-- END Nvim init file
-- ============================================================================
