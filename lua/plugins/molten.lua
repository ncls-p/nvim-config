return {
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    pin = true,  -- Prevent updates due to local modifications
    frozen = true,  -- Ignore this plugin completely during updates
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    init = function()
      -- I find auto open annoying, keep in mind setting this option will require setting
      -- a keybind for `:noautocmd MoltenEnterOutput` to open the output again
      vim.g.molten_auto_open_output = false

      -- this guide will be using image.nvim
      -- Don't forget to setup and install the plugin if you want to view image outputs
      vim.g.molten_image_provider = "image.nvim"

      -- optional, I like wrapping. works for virt text and the output window
      vim.g.molten_wrap_output = true

      -- Output as virtual text. Allows outputs to always be shown, works with images, but can
      -- be buggy with longer images
      vim.g.molten_virt_text_output = true

      -- this will make it so the output shows up below the ``` cell delimiter
      vim.g.molten_virt_lines_off_by_1 = false
      
      -- show more lines of output in virtual text (default is 12)
      -- vim.g.molten_virt_text_max_lines = 12  -- uncomment to change from default
      
      -- show "x more lines" in window footer when output is truncated
      vim.g.molten_output_show_more = true
      
      -- configure how to enter output window
      vim.g.molten_enter_output_behavior = "open_and_enter"
    end,
    config = function()
      vim.keymap.set("n", "<localleader>e", ":MoltenEvaluateOperator<CR>", { desc = "evaluate operator", silent = true })
      vim.keymap.set("n", "<localleader>os", ":noautocmd MoltenEnterOutput<CR>", { desc = "open output window", silent = true })
      vim.keymap.set("n", "<localleader>rr", ":MoltenReevaluateCell<CR>", { desc = "re-eval cell", silent = true })
      vim.keymap.set("v", "<localleader>r", ":<C-u>MoltenEvaluateVisual<CR>gv", { desc = "execute visual selection", silent = true })
      vim.keymap.set("n", "<localleader>oh", ":MoltenHideOutput<CR>", { desc = "close output window", silent = true })
      vim.keymap.set("n", "<localleader>md", ":MoltenDelete<CR>", { desc = "delete Molten cell", silent = true })
      vim.keymap.set("n", "<localleader>mx", ":MoltenOpenInBrowser<CR>", { desc = "open output in browser", silent = true })
    end,
  },
  {
    "quarto-dev/quarto-nvim",
    ft = {"quarto", "markdown"},
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter"
    },
    config = function()
      local quarto = require("quarto")
      quarto.setup({
          lspFeatures = {
              -- NOTE: put whatever languages you want here:
              languages = { "r", "python", "rust" },
              chunks = "all",
              diagnostics = {
                  enabled = true,
                  triggers = { "BufWritePost" },
              },
              completion = {
                  enabled = true,
              },
          },
          keymap = {
              -- NOTE: setup your own keymaps:
              hover = "H",
              definition = "gd",
              rename = "<leader>rn",
              references = "gr",
              format = "<leader>gf",
          },
          codeRunner = {
              enabled = true,
              default_method = "molten",
          },
      })
      
      local runner = require("quarto.runner")
      vim.keymap.set("n", "<localleader>rc", runner.run_cell,  { desc = "run cell", silent = true })
      vim.keymap.set("n", "<localleader>ra", runner.run_above, { desc = "run cell and above", silent = true })
      vim.keymap.set("n", "<localleader>rA", runner.run_all,   { desc = "run all cells", silent = true })
      vim.keymap.set("n", "<localleader>rl", runner.run_line,  { desc = "run line", silent = true })
      vim.keymap.set("v", "<localleader>r",  runner.run_range, { desc = "run visual range", silent = true })
      vim.keymap.set("n", "<localleader>RA", function()
        runner.run_all(true)
      end, { desc = "run all cells of all languages", silent = true })
    end,
  },
  {
    "GCBallesteros/jupytext.nvim",
    pin = true,  -- Prevent updates due to local modifications
    frozen = true,  -- Ignore this plugin completely during updates
    config = function()
      require("jupytext").setup({
          style = "markdown",
          output_extension = "md",
          force_ft = "markdown",
      })
      
      -- automatically import output chunks from a jupyter notebook
      -- tries to find a kernel that matches the kernel in the jupyter notebook
      -- falls back to a kernel that matches the name of the active venv (if any)
      local imb = function(e) -- init molten buffer
          vim.schedule(function()
              local kernels = vim.fn.MoltenAvailableKernels()
              
              -- Check if any kernels are available
              if #kernels == 0 then
                  vim.notify("No Jupyter kernels found. Install kernels with 'python -m ipykernel install --user'", vim.log.levels.WARN)
                  return
              end
              
              local try_kernel_name = function()
                  local metadata = vim.json.decode(io.open(e.file, "r"):read("a"))["metadata"]
                  return metadata.kernelspec.name
              end
              
              local ok, kernel_name = pcall(try_kernel_name)
              if not ok or not vim.tbl_contains(kernels, kernel_name) then
                  kernel_name = nil
                  local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
                  if venv ~= nil then
                      kernel_name = string.match(venv, "/.+/(.+)")
                  end
              end
              
              -- Only initialize and import if we have a valid kernel
              if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
                  local success = pcall(vim.cmd, ("MoltenInit %s"):format(kernel_name))
                  if success then
                      vim.cmd("MoltenImportOutput")
                  else
                      vim.notify(string.format("Failed to initialize kernel '%s'", kernel_name), vim.log.levels.ERROR)
                  end
              else
                  -- Inform user about kernel mismatch
                  local available = table.concat(kernels, ", ")
                  vim.notify(string.format("No matching kernel found. Available: %s. Use :MoltenInit to manually select.", available), vim.log.levels.WARN)
              end
          end)
      end

      -- automatically import output chunks from a jupyter notebook
      vim.api.nvim_create_autocmd("BufAdd", {
          pattern = { "*.ipynb" },
          callback = imb,
      })

      -- we have to do this as well so that we catch files opened like nvim ./hi.ipynb
      vim.api.nvim_create_autocmd("BufEnter", {
          pattern = { "*.ipynb" },
          callback = function(e)
              if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then
                  imb(e)
              end
          end,
      })

      -- automatically export output chunks to a jupyter notebook on write
      vim.api.nvim_create_autocmd("BufWritePost", {
          pattern = { "*.ipynb" },
          callback = function()
              if require("molten.status").initialized() == "Molten" then
                  vim.cmd("MoltenExportOutput!")
              end
          end,
      })
      
      -- Provide a command to create a blank new Python notebook
      -- note: the metadata is needed for Jupytext to understand how to parse the notebook.
      -- if you use another language than Python, you should change it in the template.
      local default_notebook = [[
        {
          "cells": [
           {
            "cell_type": "markdown",
            "metadata": {},
            "source": [
              ""
            ]
           }
          ],
          "metadata": {
           "kernelspec": {
            "display_name": "Python 3",
            "language": "python",
            "name": "python3"
           },
           "language_info": {
            "codemirror_mode": {
              "name": "ipython"
            },
            "file_extension": ".py",
            "mimetype": "text/x-python",
            "name": "python",
            "nbconvert_exporter": "python",
            "pygments_lexer": "ipython3"
           }
          },
          "nbformat": 4,
          "nbformat_minor": 5
        }
      ]]

      local function new_notebook(filename)
        local path = filename .. ".ipynb"
        local file = io.open(path, "w")
        if file then
          file:write(default_notebook)
          file:close()
          vim.cmd("edit " .. path)
        else
          print("Error: Could not open new notebook file for writing.")
        end
      end

      vim.api.nvim_create_user_command('NewNotebook', function(opts)
        new_notebook(opts.args)
      end, {
        nargs = 1,
        complete = 'file'
      })
    end,
  },
}