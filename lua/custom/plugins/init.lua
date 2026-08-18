-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

---@module 'lazy'
---@type LazySpec
return {
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function() require('bufferline').setup {} end,
  },

  -- {
  --   'kaarmu/typst.vim',
  -- },

  {
    'chomosuke/typst-preview.nvim',
    -- Carica il plugin solo quando apri un file Typst
    ft = 'typst',
    version = '1.*',
    -- Scarica e aggiorna le dipendenze esterne necessarie per la preview
    build = function() require('typst-preview').update() end,
    opts = {
      -- Di default apre il browser predefinito del sistema.
      -- Se vuoi forzarne uno specifico (es. Firefox), decommenta e modifica la riga sotto:
      -- open_cmd = "firefox %s -P default --class typst-preview",
    },
    keys = {
      -- Premi Spazio + t + p per aprire/chiudere l'anteprima
      { '<leader>tp', '<cmd>TypstPreviewToggle<cr>', desc = 'Toggle Typst Preview' },
      -- Premi Spazio + t + s per forzare la sincronizzazione (se dovesse servire)
      { '<leader>ts', '<cmd>TypstPreviewSync<cr>', desc = 'Sync Typst Preview' },
    },
  },

  {
    'chrisgrieser/nvim-spider',
    lazy = true,
    keys = {
      { 'w', "<cmd>lua require('spider').motion('w')<cr>", mode = { 'n', 'o', 'x' }, desc = 'Spider-w' },
      { 'e', "<cmd>lua require('spider').motion('e')<cr>", mode = { 'n', 'o', 'x' }, desc = 'Spider-e' },
      { 'b', "<cmd>lua require('spider').motion('b')<cr>", mode = { 'n', 'o', 'x' }, desc = 'Spider-b' },
      { 'ge', "<cmd>lua require('spider').motion('ge')<cr>", mode = { 'n', 'o', 'x' }, desc = 'Spider-ge' },
    },
  },
}
