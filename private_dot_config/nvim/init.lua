-- ~/.config/nvim/init.lua (the "nvim" opt-in switch)
--
-- Neovim for learning Vim keys that also work in vi on a bare server. The
-- plugins only show hints; none of them changes what a key does:
--   which-key.nvim    after d, y, c, g, z, ", ', Ctrl-w and the like, lists
--                     the keys that can follow
--   precognition.nvim marks where w, b, e, ^, $ and friends would land;
--                     :Precognition toggle hides it
--   hardtime.nvim     suggests a better motion after jjjj or similar; hints
--                     only, nothing is blocked; :Hardtime toggle turns it off
-- lazy-lock.json is written next to this file and is not managed by chezmoi.

vim.opt.number = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.scrolloff = 5
vim.opt.termguicolors = true

-- lazy.nvim installs the plugins from GitHub on the first start. Where that
-- clone fails (no network, or git blocked), Neovim starts without them.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.notify("lazy.nvim could not be installed; starting without plugins\n" .. out, vim.log.levels.WARN)
    return
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    {
      "olivercederborg/poimandres.nvim",
      priority = 1000,
      config = function()
        require("poimandres").setup({})
        vim.cmd.colorscheme("poimandres")
      end,
    },
    { "folke/which-key.nvim", event = "VeryLazy", opts = {} },
    { "tris203/precognition.nvim", event = "VeryLazy", opts = {} },
    {
      "m4xshen/hardtime.nvim",
      lazy = false,
      dependencies = { "MunifTanjim/nui.nvim" },
      opts = {
        restriction_mode = "hint",
        disable_mouse = false,
        -- Arrow keys stay usable; hardtime still suggests the better motion.
        disabled_keys = { ["<Up>"] = false, ["<Down>"] = false, ["<Left>"] = false, ["<Right>"] = false },
      },
    },
  },
  install = { colorscheme = { "poimandres", "habamax" } },
  checker = { enabled = false },
  change_detection = { notify = false },
})
