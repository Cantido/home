require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = {
    'bashls',
    'dockerls',
    'elixirls',
    'erlangls',
    'graphql',
    'lua_ls',
    'nil_ls',
    'yamlls'
  }
}
local lsp = require('lsp-zero')
lsp.preset('recommended')
lsp.nvim_workspace()
lsp.setup()

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
  sources = {
    {name = 'nvim_lsp'}
  },
  mapping = {
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
  }
})

vim.cmd([[
	" TMUX
	let g:tmux_navigator_no_mappings = 1
	nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
	nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
	nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
	nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
	" Disable tmux navigator when zooming the Vim pane
	let g:tmux_navigator_disable_when_zoomed = 1
]])

vim.cmd('colorscheme rose-pine')
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
vim.keymap.set("n", "<leader>b", vim.cmd.GitBlameToggle)

vim.g.gitblame_enabled = 0

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")


vim.opt.compatible = false
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.swapfile = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showtabline = 2
vim.opt.colorcolumn = "80"

vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.scrolloff = 8

vim.g.ackprg = "ag --vimgrep"

vim.opt.filetype.syntax = true

