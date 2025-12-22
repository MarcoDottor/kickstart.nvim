return {
  -- Core DAP
  {
    'mfussenegger/nvim-dap',
  },

  -- Mason integration for DAP adapters
  {
    'jay-babu/mason-nvim-dap.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'mfussenegger/nvim-dap',
    },
    config = function()
      require('mason-nvim-dap').setup {
        ensure_installed = { 'codelldb' },
        automatic_installation = true,
      }
    end,
  },

  -- C++ / codelldb configuration
  {
    'mfussenegger/nvim-dap',
    config = function()
      local dap = require 'dap'

      -- Adapter: codelldb
      dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          command = vim.fn.stdpath 'data' .. '/mason/bin/codelldb',
          args = { '--port', '${port}' },
        },
      }

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
          justMyCode = true, --Cosi non entro in roba di librerie esterne
        },
      }

      -- Reuse for C
      dap.configurations.c = dap.configurations.cpp

      vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticSignError', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DiagnosticSignWarn', linehl = 'Visual', numhl = '' })
      vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticSignInfo', linehl = '', numhl = '' })

      -- Keymap “classici” tipo VSCode
      local opts = { noremap = true, silent = true }
      -- vim.keymap.set('n', '<F5>', function() dap.continue() end, opts)
      -- vim.keymap.set('n', '<F10>', function() dap.step_over() end, opts)
      -- vim.keymap.set('n', '<F11>', function() dap.step_into() end, opts)
      -- vim.keymap.set('n', '<F12>', function() dap.step_out() end, opts)
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
      end, { noremap = true, silent = true, desc = 'Debug Continue' }) -- dc = debug continue
      vim.keymap.set('n', '<leader>do', function()
        dap.step_over()
      end, { noremap = true, silent = true, desc = 'Debug step Over' }) -- do = debug over
      vim.keymap.set('n', '<leader>di', function()
        dap.step_into()
      end, { noremap = true, silent = true, desc = 'Debug step Into' }) -- di = debug into
      vim.keymap.set('n', '<leader>du', function()
        dap.step_out()
      end, { noremap = true, silent = true, desc = 'Debug step Out' })
    end,
  },
}
