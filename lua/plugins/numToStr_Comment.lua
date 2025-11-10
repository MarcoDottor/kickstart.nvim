return {
  'numToStr/Comment.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    require('Comment').setup {
      --- puoi anche aggiungere qui opzioni personalizzate
      toggler = {
        line = '<C-_>', -- Ctrl + / in normal mode
      },
      opleader = {
        line = '<C-_>', -- Ctrl + / in visual mode
      },
    }
  end,
}
