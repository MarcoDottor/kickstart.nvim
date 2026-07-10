-- autopairs
-- https://github.com/windwp/nvim-autopairs

--return {
--  'windwp/nvim-autopairs',
--  event = 'InsertEnter',
--  opts = {},
--}

-- return {
--   'windwp/nvim-autopairs',
--   event = 'InsertEnter',
--   config = function()
--     local npairs = require 'nvim-autopairs'
--
--     npairs.setup {
--       check_ts = true, -- usa treesitter per gestire meglio le coppie
--       enable_check_bracket_line = false,
--       disable_filetype = { 'TelescopePrompt', 'vim' },
--     }
--
--     -- 🔹 Forza l’attivazione su C e C++
--     vim.api.nvim_create_autocmd('FileType', {
--       pattern = { 'c', 'cpp', 'h', 'hpp' },
--       callback = function()
--         npairs.enable()
--       end,
--     })
--   end,
-- }
--

return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function()
    local npairs = require 'nvim-autopairs'
    local Rule = require 'nvim-autopairs.rule'
    local cond = require 'nvim-autopairs.conds'

    npairs.setup {
      check_ts = true,
      enable_check_bracket_line = false,
      disable_filetype = { 'TelescopePrompt', 'vim' },
    }

    npairs.add_rules {
      Rule('$', '$', 'tex'):with_pair(cond.not_after_text '$'),
    }

    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'c', 'cpp', 'h', 'hpp' },
      callback = function()
        npairs.enable()
      end,
    })

    vim.keymap.set('i', '<Tab>', function()
      local line = vim.api.nvim_get_current_line()
      local col = vim.api.nvim_win_get_cursor(0)[2]
      local next_char = line:sub(col + 1, col + 1)
      if next_char == '$' or next_char == ')' or next_char == '}' or next_char == ']' or next_char == '"' or next_char == "'" then
        return '<Right>'
      else
        return '<Tab>'
      end
    end, { expr = true })
  end,
}
