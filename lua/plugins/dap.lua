return {
  -- Core DAP
  { 'mfussenegger/nvim-dap' },

  -- Mason DAP
  {
    'jay-babu/mason-nvim-dap.nvim',
    dependencies = { 'williamboman/mason.nvim', 'mfussenegger/nvim-dap' },
    config = function()
      require('mason-nvim-dap').setup {
        ensure_installed = { 'codelldb' },
        automatic_installation = true,
      }
    end,
  },

  {
    'nvim-neotest/nvim-nio',
    lazy = true, -- opzionale, lazy lo carica quando serve
  },

  -- dap-ui
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
      require('dapui').setup {
        icons = { expanded = '▾', collapsed = '▸' },
        layouts = {
          {
            elements = { 'scopes', 'breakpoints', 'stacks', 'watches' },
            size = 40,
            position = 'right',
          },
          {
            elements = { 'repl' },
            size = 10,
            position = 'bottom',
          },
        },
        floating = { border = 'rounded' },
      }
    end,
  },

  -- dap-virtual-text
  {
    'theHamsta/nvim-dap-virtual-text',
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
      require('nvim-dap-virtual-text').setup {
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = true,
        show_stop_reason = true,
        commented = false,
        virt_text_pos = 'eol',
      }
    end,
  },

  -- C++ / codelldb configuration + keymaps + highlights
  {
    'mfussenegger/nvim-dap',
    config = function()
      local dap = require 'dap'

      -- Adapter
      dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          command = vim.fn.stdpath 'data' .. '/mason/bin/codelldb',
          args = { '--port', '${port}' },
        },
      }

      -- Highlight e signs
      vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticSignError', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DiagnosticSignWarn', linehl = 'Visual', numhl = '' })
      vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticSignInfo', linehl = '', numhl = '' })

      -- Keymaps
      local opts = { noremap = true, silent = true }
      vim.keymap.set('n', '<leader>b', function()
        dap.toggle_breakpoint()
      end, { noremap = true, silent = true, desc = 'Toggle dap breakpoint' })
      vim.keymap.set('n', '<leader>B', function()
        dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end, { noremap = true, silent = true, desc = 'Breakpoint with condition' })
      vim.keymap.set('n', '<leader>dr', function()
        dap.repl.open()
      end, { noremap = true, silent = true, desc = 'Debug Run' })
      vim.keymap.set('n', '<leader>dc', function()
        dap.continue()
      end, { noremap = true, silent = true, desc = 'Debug Continue' })
      vim.keymap.set('n', '<leader>do', function()
        dap.step_over()
      end, { noremap = true, silent = true, desc = 'Debug step Over' })
      vim.keymap.set('n', '<leader>di', function()
        dap.step_into()
      end, { noremap = true, silent = true, desc = 'Debug step Into' })
      vim.keymap.set('n', '<leader>du', function()
        dap.step_out()
      end, { noremap = true, silent = true, desc = 'Debug step Out' })

      -- Listeners per UI
      dap.listeners.after.event_initialized['dapui_config'] = function()
        require('dapui').open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        require('dapui').close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        require('dapui').close()
      end

      -- C++ configuration
      dap.configurations.cpp = {
        {
          name = 'Debug C++ (build-debug)',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.getcwd() .. '/build-debug/myprogram'
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          justMyCode = true,
          termianl = 'integrated',
        },
      }

      -- Reuse for C
      dap.configurations.c = dap.configurations.cpp
    end,
  },
}
