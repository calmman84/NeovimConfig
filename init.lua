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
-- Prevent '#symbol'(e.g. #if) reindenting of the current line when typed in Insert mode (remove '0#' from default)
vim.opt.cinkeys = "0{,0},0),0],:,!^F,o,O,e"
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
-- Install Plugin manager
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

-- require("lazy").setup(plugins, opts)
require("lazy").setup(
  -- plugins
  {
    -- Colorscheme
    { "folke/tokyonight.nvim" },
    { "EdenEast/nightfox.nvim" },
    -- Statusline
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("lualine").setup({ extensions = { "neo-tree" } })
      end,
    },
    -- Tabline
    {
      "akinsho/bufferline.nvim",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
        "famiu/bufdelete.nvim",
      },
      opts = {
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
      },
    },
    -- File Explorer
    {
      "nvim-neo-tree/neo-tree.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      },
      keys = {
        { "<leader>e", "<cmd>Neotree reveal_force_cwd<cr>", desc = "Neo-tree(File Explorer)" },
      },
      opts = {
        sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      },
    },
    -- Fuzzy Finder
    {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      keys = {
        { "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
        { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Find in Files (Grep)" },
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
        { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
      }
    },
    -- Keybinding
    {
      "folke/which-key.nvim",
      config = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
        local wk = require("which-key")
        wk.setup()
        wk.add({
          { "<leader>f", group = "file/find" },
          { "<leader>g", group = "LSP menu" },
        })
      end,
    },
    -- Editing Support
    -- Jumps to the last position when reopening a file
    {
      "ethanholz/nvim-lastplace",
      config = function()
        require("nvim-lastplace").setup()
      end,
    },
    -- Syntax
    {
      'nvim-treesitter/nvim-treesitter',
      config = function()
        require("nvim-treesitter.configs").setup({
          highlight = { enable = true },
        })
      end,
    },
    -- LSP
    {
      'simrat39/symbols-outline.nvim',
      config = function()
        require("symbols-outline").setup()
      end,
    },
  },
  -- opts for Neovim Qt
  { performance = { rtp = { reset = false }, }, }
)

-- Select Colorscheme
vim.cmd.colorscheme("tokyonight")
--vim.cmd.colorscheme("tokyonight-day")
--vim.cmd.colorscheme("tokyonight-night")
--vim.cmd.colorscheme("tokyonight-moon")
--vim.cmd.colorscheme("nightfox")
--vim.cmd.colorscheme("dayfox")
