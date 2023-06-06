----------------------------------------
-- Editor Settings
----------------------------------------
vim.opt.ignorecase = true  -- ignore Case sensitive when searching
vim.opt.title = true       -- change the terminal title

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
-- Prevent '#symbol'(e.g. #if) reindenting of the current line when typed in Insert mode (remove '0#' from default)
vim.opt.cinkeys = "0{,0},0),0],:,!^F,o,O,e"
--vim.opt.guifont = "MesloLGM Nerd Font Mono:h14"
--vim.opt.guifont = "D2Coding Nerd Font:h14"

----------------------------------------
-- Keybindings
----------------------------------------
-- Copy to clipboard 
vim.keymap.set({'n', 'x'}, '<C-Insert>', '"+y')
-- Paste from clipboard (Normal, Visual, Select and Operator-pending mode)
vim.keymap.set({'n', 'v', 'o'}, '<S-Insert>', '"+p')
-- Paste from clipboard and no auto-indent (Insert and Command-line mode)
vim.keymap.set('!', '<S-Insert>', '<C-R><C-O>+')
-- Space as <Leader> key
vim.g.mapleader = ' '

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

require("lazy").setup({
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
      { "<leader>e", "<cmd>Neotree reveal<cr>", desc = "Neo-tree(File Explorer)" },
    },
  },
  -- Fuzzy Finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
      { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader>g", "<cmd>Telescope live_grep<cr>", desc = "Find in Files (Grep)" },
      { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>r", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
    }
  },
  -- Keybinding
  {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup()
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
  -- Switch Input Method automatically depends on NeoVim's edit mode
  {
    "keaising/im-select.nvim",
    config = function()
      require("im_select").setup({
        set_default_events = { "InsertLeave" },
        set_previous_events = { "InsertEnter", "FocusLost", "CmdlineEnter" },
      })
    end,
  },
})

-- Select Colorscheme
vim.cmd.colorscheme("tokyonight")
--vim.cmd.colorscheme("tokyonight-day")
--vim.cmd.colorscheme("tokyonight-night")
--vim.cmd.colorscheme("tokyonight-moon")
--vim.cmd.colorscheme("nightfox")
--vim.cmd.colorscheme("dayfox")
