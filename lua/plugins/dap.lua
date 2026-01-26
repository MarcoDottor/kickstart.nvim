return {
  -- Core DAP
  { 'mfussenegger/nvim-dap' },

  -- Mason DAP
  {
    'jay-babu/mason-nvim-dap.nvim',
    dependencies = { 'williamboman/mason.nvim', 'mfussenegger/nvim-dap' },
    config = function()
      require('mason-nvim-dap').setup {
        ensure_installed = { 'codelldb', 'debugpy' }, -- Added debugpy for Python
        automatic_installation = true,
      }
    end,
  },

  {
    'nvim-neotest/nvim-nio',
    lazy = true,
  },

  -- dap-ui
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
      require('dapui').setup {
        icons = { expanded = '▾', collapsed = '▸', current_frame = '→' },
        mappings = {
          expand = { '<CR>', '<2-LeftMouse>' },
          open = 'o',
          remove = 'd',
          edit = 'e',
          repl = 'r',
          toggle = 't',
        },
        layouts = {
          {
            elements = {
              { id = 'scopes', size = 1.0 }, -- Only variables, full height
            },
            size = 50, -- Width of left sidebar (columns)
            position = 'left',
          },
          {
            elements = {
              { id = 'repl', size = 0.5 }, -- REPL/Console
              { id = 'console', size = 0.5 }, -- Output
            },
            size = 12, -- Height of bottom panel (lines)
            position = 'bottom',
          },
        },
        controls = {
          enabled = true,
          element = 'repl',
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = '⏪',
            run_last = '↻',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
        floating = {
          max_height = 0.9,
          max_width = 0.9,
          border = 'rounded',
          mappings = {
            close = { 'q', '<Esc>' },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil,
          max_value_lines = 100,
        },
        -- Filter out unwanted variable scopes
        element_mappings = {},
        expand_lines = true,
        force_buffers = true,
        scopes = {
          -- Only show Locals, hide Statics, Globals, Registers
          show = { 'Locals' },
        },
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
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        clear_on_continue = false,

        -- Display callback
        display_callback = function(variable)
          return ' = ' .. variable.value
        end,

        -- Text config
        virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',

        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil,
      }

      -- Better colors
      vim.api.nvim_set_hl(0, 'NvimDapVirtualText', { fg = '#61afef', italic = true })
      vim.api.nvim_set_hl(0, 'NvimDapVirtualTextChanged', { fg = '#e5c07b', italic = true, bold = true })
    end,
  },

  -- C++ / codelldb configuration + keymaps + highlights
  {
    'mfussenegger/nvim-dap',
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      -- Enable logging
      dap.set_log_level 'TRACE'

      -- Adapter
      dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          command = vim.fn.stdpath 'data' .. '/mason/bin/codelldb',
          args = { '--port', '${port}' },
        },
      }

      -- Nicer signs and highlights
      vim.fn.sign_define('DapBreakpoint', {
        text = '●',
        texthl = 'DapBreakpoint',
        linehl = '',
        numhl = 'DapBreakpoint',
      })
      vim.fn.sign_define('DapBreakpointCondition', {
        text = '◆',
        texthl = 'DapBreakpoint',
        linehl = '',
        numhl = 'DapBreakpoint',
      })
      vim.fn.sign_define('DapBreakpointRejected', {
        text = '○',
        texthl = 'DapBreakpoint',
        linehl = '',
        numhl = 'DapBreakpoint',
      })
      vim.fn.sign_define('DapStopped', {
        text = '→',
        texthl = 'DapStopped',
        linehl = 'DapStoppedLine',
        numhl = 'DapStopped',
      })
      vim.fn.sign_define('DapLogPoint', {
        text = '◆',
        texthl = 'DapLogPoint',
        linehl = '',
        numhl = 'DapLogPoint',
      })

      -- Colors
      vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#e51400' })
      vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#98c379' })
      vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg = '#2d3139' })

      -- Keymaps
      vim.keymap.set('n', '<leader>b', function()
        dap.toggle_breakpoint()
      end, { noremap = true, silent = true, desc = 'Toggle breakpoint' })

      vim.keymap.set('n', '<leader>B', function()
        dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end, { noremap = true, silent = true, desc = 'Conditional breakpoint' })

      vim.keymap.set('n', '<F5>', function()
        dap.continue()
      end, { noremap = true, silent = true, desc = 'Debug: Continue' })

      vim.keymap.set('n', '<F10>', function()
        dap.step_over()
      end, { noremap = true, silent = true, desc = 'Debug: Step Over' })

      vim.keymap.set('n', '<F11>', function()
        dap.step_into()
      end, { noremap = true, silent = true, desc = 'Debug: Step Into' })

      vim.keymap.set('n', '<F12>', function()
        dap.step_out()
      end, { noremap = true, silent = true, desc = 'Debug: Step Out' })

      vim.keymap.set('n', '<leader>dc', function()
        dap.continue()
      end, { noremap = true, silent = true, desc = 'Debug: Continue' })

      vim.keymap.set('n', '<leader>do', function()
        dap.step_over()
      end, { noremap = true, silent = true, desc = 'Debug: Step Over' })

      vim.keymap.set('n', '<leader>di', function()
        dap.step_into()
      end, { noremap = true, silent = true, desc = 'Debug: Step Into' })

      vim.keymap.set('n', '<leader>du', function()
        dap.step_out()
      end, { noremap = true, silent = true, desc = 'Debug: Step Out' })

      vim.keymap.set('n', '<leader>dt', function()
        dap.terminate()
      end, { noremap = true, silent = true, desc = 'Debug: Terminate' })

      vim.keymap.set('n', '<leader>dr', function()
        dap.repl.toggle()
      end, { noremap = true, silent = true, desc = 'Debug: Toggle REPL' })

      -- Close file tree and open DAP UI when debugging starts
      dap.listeners.after.event_initialized['dapui_config'] = function()
        -- Try to close common file tree plugins
        local ok, nvim_tree = pcall(require, 'nvim-tree.api')
        if ok then
          nvim_tree.tree.close()
        end

        -- Try neo-tree
        local ok_neo, _ = pcall(vim.cmd, 'Neotree close')

        dapui.open()
      end

      dap.listeners.after.event_stopped['dapui_config'] = function()
        -- Force refresh virtual text when stopped
        vim.schedule(function()
          local vtext = require 'nvim-dap-virtual-text'
          vtext.refresh()
          print 'Virtual text refreshed'
        end)
      end

      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end

      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end

      -- C++ configuration
      dap.configurations.cpp = {
        {
          name = 'Debug C++ (build-debug)',
          type = 'codelldb',
          request = 'launch',
          program = '${workspaceFolder}/build-debug/myprogram',
          cwd = '${workspaceFolder}/build-debug',
          stopOnEntry = false,
          justMyCode = true,
          terminal = 'integrated',
        },
      }

      -- Reuse for C
      dap.configurations.c = dap.configurations.cpp

      -- local dap_python = require 'dap-python'
      local dap = require 'dap'
      local mip_python = vim.fn.expand '~/mip_env/bin/python'

      -- 1. Definiamo l'Adapter (il bridge tra nvim e debugpy)
      dap.adapters.python = {
        type = 'executable',
        command = mip_python,
        args = { '-m', 'debugpy.adapter' },
      }

      -- 2. Definiamo le Configurazioni (cosa appare quando premi F5)
      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = 'Launch File (mip_env)',
          program = '${file}',
          pythonPath = mip_python,
          console = 'integratedTerminal',
        },
        {
          type = 'python',
          request = 'launch',
          name = 'Launch File with Arguments',
          program = '${file}',
          args = function()
            local args_string = vim.fn.input 'Arguments: '
            return vim.split(args_string, ' +')
          end,
          pythonPath = mip_python,
          console = 'integratedTerminal',
        },
        {
          type = 'python',
          request = 'launch',
          name = 'Pytest: Current File',
          module = 'pytest',
          args = { '${file}' },
          pythonPath = mip_python,
          console = 'integratedTerminal',
        },
      }
      --
      -- -- Espandiamo il percorso del tuo venv
      -- local mip_python_path = vim.fn.expand '~/mip_env/bin/python'
      --
      -- -- Logica di fallback: Priorità a mip_env, poi venv attivo, poi sistema
      -- local python_executable = ''
      -- if vim.fn.executable(mip_python_path) == 1 then
      --   python_executable = mip_python_path
      -- elseif vim.env.VIRTUAL_ENV then
      --   python_executable = vim.env.VIRTUAL_ENV .. '/bin/python'
      -- else
      --   python_executable = 'python3'
      -- end
      --
      -- -- Importante: nvim-dap-python configura da solo sia l'adapter che le configurazioni.
      -- -- Passiamo direttamente la stringa del percorso.
      -- dap_python.setup(python_executable)
      --
      -- -- Se vuoi aggiungere una configurazione specifica con argomenti
      -- table.insert(dap.configurations.python, {
      --   type = 'python',
      --   request = 'launch',
      --   name = 'Launch file with arguments',
      --   program = '${file}',
      --   args = function()
      --     local args_string = vim.fn.input 'Arguments: '
      --     return vim.split(args_string, ' +')
      --   end,
      --   -- Non serve ridefinire pythonPath qui, nvim-dap-python usa quello dello setup
      -- })
    end, -- fine della funzione config di nvim-dap
  },
}
