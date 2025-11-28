return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup {
      modules = {}, -- default richiesto dal nuovo schema
      sync_install = false,
      ignore_install = {},
      auto_install = false,
      ensure_installed = { 'html', 'javascript', 'typescript', 'tsx', 'lua' },
      highlight = { enable = true },
    }
  end,
}
