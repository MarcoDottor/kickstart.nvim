vim.keymap.set({ 'n', 'v' }, '<leader>rc', ':w<CR> :! python %<CR>', { desc = '[R]un [C]ode of current py file' })

vim.keymap.set('i', '<Tab>', function()
  -- Get the current line string and cursor column position
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]

  -- Get the character exactly under/after the cursor
  local next_char = string.sub(line, col + 1, col + 1)

  -- Define closing characters you want to jump over
  local closing_chars = { [')'] = true, [']'] = true, ['}'] = true, ['"'] = true, ["'"] = true, ['`'] = true }

  if closing_chars[next_char] then
    -- Move cursor forward by one character
    return '<Right>'
  else
    -- Fallback to standard tab insertion
    return '<Tab>'
  end
end, { expr = true, noremap = true, silent = true })
