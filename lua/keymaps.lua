-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

local map = vim.keymap.set

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic Config & Keymaps
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  -- Can switch between these as you prefer
  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = { float = true },
}

map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- map('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- map('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- map('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- map('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- map("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- map("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- map("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- map("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- Move through buffers with Tab and Shift+Tab
map('n', '<Tab>', ':bnext<CR>', { desc = 'Next Buffer' })
map('n', '<S-Tab>', ':bprevious<CR>', { desc = 'Previous Buffer' })

-- Close current buffer with Space+x
map('n', '<leader>x', ':bdelete<CR>', { desc = 'Close Buffer' })

map({ 'n', 'i', 'v' }, '<C-s>', '<cmd> w <cr>')
map({ 'n', 'i', 'v' }, '<C-q>', '<cmd> q <cr>')

-- MATLAB
-- Inizializza una variabile globale per ricordare "dove" sta girando MATLAB
_G.matlab_terminal_channel = nil

-- 1. Comando per aprire MATLAB in una finestra laterale
vim.api.nvim_create_user_command('MatlabOpen', function()
  -- Apre uno split verticale
  vim.cmd 'botright 15split'
  -- Avvia MATLAB senza interfaccia grafica e senza splash screen
  vim.cmd 'terminal env _JAVA_AWT_WM_NONREPARENTING=1 GDK_BACKEND=x11 LD_PRELOAD="/usr/lib/libstdc++.so.6:/usr/lib/libgcc_s.so.1:/usr/lib/libfreetype.so.6:/usr/lib/libglib-2.0.so.0" /opt/MATLAB/R2023a/bin/matlab -nodesktop -nosplash'
  -- Salva l'ID del canale del terminale per potergli inviare testo dopo
  _G.matlab_terminal_channel = vim.b.terminal_job_id
  -- Torna alla finestra del codice
  vim.cmd 'wincmd p'
end, { desc = 'Open MATLAB Terminal' })

-- 2. Scorciatoia per "sparare" lo script corrente dentro il terminale aperto
vim.keymap.set('n', '<leader>r', function()
  if _G.matlab_terminal_channel then
    -- Prende il percorso assoluto del file che stai modificando
    local filepath = vim.fn.expand '%:p'
    -- Invia il comando run() al terminale nascosto, simulando la pressione di Invio (\n)
    vim.api.nvim_chan_send(_G.matlab_terminal_channel, "run('" .. filepath .. "')\n")
  else
    print "Error: MATLAB isn't open. Run :MatlabOpen before."
  end
end, { desc = 'Run script in the REPL' })

-- Autosave
vim.api.nvim_create_autocmd({ 'InsertLeave', 'FocusLost' }, {
  pattern = '*',
  callback = function() vim.cmd 'silent! update' end,
})

-- vim: ts=2 sts=2 sw=2 et
