----------------------------------------
-- Editor Settings
----------------------------------------
vim.opt.ignorecase = true  -- ignore Case sensitive when searching
vim.opt.title = true       -- change the terminal title

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
-- Remove latin1 and add cp949 to fencs for Korean
vim.opt.fileencodings = "ucs-bom,utf-8,default,cp949"
vim.opt.guifont = "Inconsolata Nerd Font Mono:h12"
vim.opt.guifontwide = "D2Coding:h12"
-- Warning reload files when modified externally
-- See https://neovim.discourse.group/t/a-lua-based-auto-refresh-buffers-when-they-change-on-disk-function/2482/2
vim.opt.autoread = false
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  pattern = { "*" },
  command = "checktime",
})
-- Automatically remove all trailing whitespace before saving
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

----------------------------------------
-- Keybindings
----------------------------------------
-- Space as <Leader> key
vim.g.mapleader = ' '
-- Copy to clipboard
vim.keymap.set({'n', 'x'}, '<C-Insert>', '"+y')
-- Paste from clipboard (Normal, Visual, Select and Operator-pending mode)
vim.keymap.set({'n', 'v', 'o'}, '<S-Insert>', '"+p')
-- Paste from clipboard and no auto-indent (Insert and Command-line mode)
vim.keymap.set('!', '<S-Insert>', '<C-R><C-O>+')
-- Remap 'Ctrl + h' to telescope.nvim 'find in files' menu
vim.keymap.set({'n', 'v', 'i'}, '<C-h>', '<leader>fg', { remap = true })
-- Use <Esc> to exit terminal mode
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true })

----------------------------------------
-- LSP
----------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    local root = vim.fs.dirname(
      vim.fs.find({ ".cproject", ".svn", ".git" }, {
        upward = true,
        path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
      })[1]
    )
    local client = vim.lsp.start({
      name = "clangd",
      cmd = { "clangd" },
      root_dir = root
    })
    vim.lsp.buf_attach_client(0, client)
    vim.keymap.set("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Goto Definition" })
    vim.keymap.set("n", "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { desc = "Goto Declaration" })
    vim.keymap.set("n", "<leader>gr", "<cmd>lua vim.lsp.buf.references()<cr>", { desc = "Show Reference List" })
    create_compile_flags(root)
  end
})

-- Create include directory information for clangd
function create_compile_flags(root_dir)
  -- root_dir exists and compile_flags.txt is not exists
  if root_dir and (vim.fn.filereadable(root_dir .. "/compile_flags.txt") == 0) then
    -- Get all '.h' file list
    local headers = vim.fs.find(function(name)
      return name:match('.*%.h$')
    end, {limit = math.huge, type = 'file', path = root_dir})
    -- Create a set of header directory for removing duplicated directory
    local header_dirs = {}
    for _, header in ipairs(headers) do
      header_dirs[vim.fs.dirname(header)] = true
    end
    -- Create a include path list
    local include_path = {}
    for k, _ in pairs(header_dirs) do
      table.insert(include_path, "-I")
      table.insert(include_path, k)
    end
    vim.fn.writefile(include_path, root_dir .. "/compile_flags.txt")
  end
end

----------------------------------------
-- Plugins
----------------------------------------

vim.pack.add({
  -- Colorscheme
  'https://github.com/folke/tokyonight.nvim',
  'https://github.com/EdenEast/nightfox.nvim',
  -- Statusline
  'https://github.com/nvim-lualine/lualine.nvim',
  -- Tabline
  'https://github.com/akinsho/bufferline.nvim',
  -- File Explorer
  'https://github.com/nvim-neo-tree/neo-tree.nvim',
  -- Fuzzy Finder
  'https://github.com/nvim-telescope/telescope.nvim',
  -- Keybinding
  'https://github.com/folke/which-key.nvim',
  -- Editing Support
  -- Jumps to the last position when reopening a file
  'https://github.com/ethanholz/nvim-lastplace',
  -- Syntax
  'https://github.com/nvim-treesitter/nvim-treesitter',
  -- LSP
  'https://github.com/hedyhli/outline.nvim',
  -- Misc
  --   Used for lualine.nvim, bufferline.nvim, neo-tree.nvim
  'https://github.com/nvim-tree/nvim-web-devicons',
  --   Used for bufferline.nvim
  'https://github.com/famiu/bufdelete.nvim',
  --   Used for neo-tree.nvim, telescope.nvim
  'https://github.com/nvim-lua/plenary.nvim',
  --   Used for neo-tree.nvim
  'https://github.com/MunifTanjim/nui.nvim',
})

-- Select Colorscheme
--vim.cmd.colorscheme("tokyonight")
--vim.cmd.colorscheme("tokyonight-day")
--vim.cmd.colorscheme("tokyonight-night")
--vim.cmd.colorscheme("tokyonight-moon")
--vim.cmd.colorscheme("nightfox")
vim.cmd.colorscheme("dayfox")

-- Setup lualine
require("lualine").setup({ extensions = { "neo-tree" } })

-- Setup bufferline
vim.opt.termguicolors = true
require("bufferline").setup({
  options = {
    numbers = "buffer_id",
    close_command = function(n) require("bufdelete").bufdelete(n, false) end,
    right_mouse_command = function(n) require("bufdelete").bufdelete(n, false) end,
    offsets = {
      {
        filetype = "neo-tree",
        text = "File Explorer",
        highlight = "Directory",
      },
    },
  },
})

-- Setup neo-tree
vim.keymap.set("n", "<leader>e", "<cmd>Neotree reveal_force_cwd<cr>", { desc = "Neo-tree(File Explorer)" })
require("neo-tree").setup({
  opts = {
    sources = { "filesystem", "buffers", "git_status", "document_symbols" },
  },
})

-- Setup telescope
vim.keymap.set("n", "<leader>,", "<cmd>Neotree reveal_force_cwd<cr>", { desc = "Neo-tree(File Explorer)" })
vim.keymap.set("n", "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", { desc = "Switch Buffer" })
vim.keymap.set("n", "<leader>:", "<cmd>Telescope command_history<cr>", { desc = "Command History" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Find in Files (Grep)" })
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent Files" })
require("telescope").setup()

-- Setup which-key
vim.o.timeout = true
vim.o.timeoutlen = 300
local wk = require("which-key")
wk.setup()
wk.add({
  { "<leader>f", group = "file/find" },
  { "<leader>g", group = "LSP menu" },
})

-- Setup nvim-lastplace
require("nvim-lastplace").setup()

-- Setup nvim-treesitter
require("nvim-treesitter").setup({
  highlight = { enable = true },
})

-- Setup outline
require("outline").setup()
