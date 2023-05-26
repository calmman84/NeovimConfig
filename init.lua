----------------------------------------
-- Keybindings
----------------------------------------
-- Copy to clipboard 
vim.keymap.set({'n', 'x'}, '<C-Insert>', '"+y')
-- Paste from clipboard (Normal, Visual, Select and Operator-pending mode)
vim.keymap.set({'n', 'v', 'o'}, '<S-Insert>', '"+p')
-- Paste from clipboard and no auto-indent (Insert and Command-line mode)
vim.keymap.set('!', '<S-Insert>', '<C-R><C-O>+')

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
  {
    "EdenEast/nightfox.nvim",
    config = function()
      -- load the colorscheme here
      --vim.cmd.colorscheme("nightfox")
      vim.cmd.colorscheme("dayfox")
    end,
  },
  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup()
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
  },
  -- Fuzzy Finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
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
})

