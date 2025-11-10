return {
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'LspAttach',
    priority = 1000,
    config = function()
      require('tiny-inline-diagnostic').setup {
        options = {
          -- add_messages = {
          --   display_count = true,
          -- },
          multilines = {
            enabled = true,
            always_show = true,
          },
        },
      }
      vim.diagnostic.config { virtual_text = false } -- Disable Neovim's default virtual text diagnostics
    end,
  },
}
