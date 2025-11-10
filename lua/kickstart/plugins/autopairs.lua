-- autopairs
-- https://github.com/windwp/nvim-autopairs

--return {
--  'windwp/nvim-autopairs',
--  event = 'InsertEnter',
--  opts = {},
--}

return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function()
    local npairs = require 'nvim-autopairs'

    npairs.setup {
      check_ts = true, -- usa treesitter per gestire meglio le coppie
      enable_check_bracket_line = false,
      disable_filetype = { 'TelescopePrompt', 'vim' },
    }

    -- 🔹 Forza l’attivazione su C e C++
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'c', 'cpp', 'h', 'hpp' },
      callback = function()
        npairs.enable()
      end,
    })
  end,
}
