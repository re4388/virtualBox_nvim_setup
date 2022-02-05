local present, cosmic_packer = pcall(require, 'cosmic.packer')

if not present then
  return false
end

local packer = cosmic_packer.packer
local use = packer.use

local ok, user_config = pcall(require, 'cosmic.config')
if not ok then
  user_config = {
    add_plugins = {},
    disable_builtin_plugins = {},
  }
end

local config = require('cosmic.config')

return packer.startup(function()
  use({
    'wbthomason/packer.nvim',
    'lewis6991/impatient.nvim',
    'nathom/filetype.nvim',
    'nvim-lua/plenary.nvim',
     -- my newly added
    'andymass/vim-matchup',
    'Julian/vim-textobj-variable-segment',
    'kana/vim-textobj-entire',
    'haya14busa/vim-textobj-function-syntax',
    'kana/vim-textobj-line',
    'michaeljsmith/vim-indent-object',
    'wellle/targets.vim',
    'kana/vim-textobj-user',
    'kana/vim-textobj-function',
    'vim-scripts/ReplaceWithRegister',
    'tpope/vim-surround',
    'tpope/vim-repeat',
    'AndrewRadev/switch.vim'
  })

  -- initialize theme plugins
  require('cosmic.theme.plugins').init(use, config)

  use({
    'rcarriga/nvim-notify',
    config = function()
      require('cosmic.plugins.notify')
    end,
    after = config.theme,
    disable = vim.tbl_contains(user_config.disable_builtin_plugins, 'notify'),
  })

  -- theme stuff
  use({ -- statusline
    'NTBBloodbath/galaxyline.nvim',
    branch = 'main',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require('cosmic.plugins.galaxyline')
    end,
    after = config.theme,
    disable = vim.tbl_contains(user_config.disable_builtin_plugins, 'galaxyline'),
  })

  -- file explorer
  use({
    'kyazdani42/nvim-tree.lua',
    config = function()
      require('cosmic.plugins.nvim-tree')
    end,
    opt = true,
    cmd = {
      'NvimTreeClipboard',
      'NvimTreeClose',
      'NvimTreeFindFile',
      'NvimTreeOpen',
      'NvimTreeRefresh',
      'NvimTreeToggle',
    },
    disable = vim.tbl_contains(user_config.disable_builtin_plugins, 'nvim-tree'),
  })

  use({
    'CosmicNvim/cosmic-ui',
    requires = {
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require('cosmic.plugins.cosmic-ui')
    end,
  })

  use({
    'neovim/nvim-lspconfig',
    config = function()
      require('cosmic.lsp')
    end,
    requires = {
      { 'b0o/SchemaStore.nvim' },
      { 'williamboman/nvim-lsp-installer' },
      { 'jose-elias-alvarez/nvim-lsp-ts-utils' },
      {
        'jose-elias-alvarez/null-ls.nvim',
        config = function()
          require('cosmic.lsp.providers.null_ls')
        end,
        disable = vim.tbl_contains(user_config.disable_builtin_plugins, 'null-ls'),
        after = 'nvim-lspconfig',
      },
      {
        'ray-x/lsp_signature.nvim',
        config = function()
          require('cosmic.plugins.lsp-signature')
        end,
        after = 'nvim-lspconfig',
        disable = vim.tbl_contains(user_config.disable_builtin_plugins, 'lsp_signature'),
      },
    },
  })

  -- autocompletion
  use({
    'hrsh7th/nvim-cmp',
    config = function()
      require('cosmic.plugins.nvim-cmp')
    end,
    requires = {
      {
        'L3MON4D3/LuaSnip',
        config = function()
          require('cosmic.plugins.luasnip')
        end,
        requires = {
          'rafamadriz/friendly-snippets',
        },
      },
      { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' },
      { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
      {
        'windwp/nvim-autopairs',
        config = function()
          require('cosmic.plugins.auto-pairs')
        end,
        after = 'nvim-cmp',
      },
    },
    event = 'InsertEnter',
    disable = vim.tbl_contains(user_config.disable_builtin_plugins, 'nvim-cmp'),
  })

  -- git commands
  use({
    'tpope/vim-fugitive',
    opt = true,
    cmd = 'Git',
    disable = vim.tbl_contains(user_config.disable_builtin_plugins, 'fugitive'),
  })

  -- git column signs
  use({
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    opt = true,
    event = 'BufRead',
    config = function()
      require('cosmic.plugins.gitsigns')
    end,
    disable = vim.tbl_contains(user_config.disable_builtin_plugins, 'gitsigns'),
  })

  -- floating terminal
  use({
    'voldikss/vim-floaterm',
    opt = true,
    event = 'BufWinEnter',
    config = function()
      require('cosmic.plugins.terminal')
    end,
    disable = vim.tbl_contains(user_config.disable_builtin_plugins, 'terminal'),
  })

  -- file navigation
  use({
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make',
      },
    },
    config = function()
      require('cosmic.plugins.telescope.mappings').init()
      require('cosmic.plugins.telescope')
    end,
    event = 'BufWinEnter',
    disable = vim.tbl_contains(user_config.disable_builtin_plugins, 'telescope'),
  })

  -- session/project management
  use({
    'glepnir/dashboard-nvim',
    config = function()
      require('cosmic.plugins.dashboard')
    end,
    disable = vim.tbl_contains(user_config.disable_builtin_plugins, 'dashboard'),
  })

  use({
    'rmagatti/auto-session',
    config = function()
      require('cosmic.plugins.auto-session')
    end,
    disable = vim.tbl_contains(user_config.disable_builtin_plugins, 'auto-session'),
  })

  -- lang/syntax stuff
  use({
    'nvim-treesitter/nvim-treesitter',
    requires = {
      'windwp/nvim-ts-autotag',
      'JoosepAlviste/nvim-ts-context-commentstring',
      'nvim-treesitter/nvim-treesitter-refactor',
    },
    run = ':TSUpdate',
    config = function()
      require('cosmic.plugins.treesitter')
    end,
    disable = vim.tbl_contains(user_config.disable_builtin_plugins, 'treesitter'),
  })

  -- comments and stuff
  use({
    'numToStr/Comment.nvim',
    config = function()
      require('cosmic.plugins.comments')
    end,
    event = 'BufWinEnter',
    disable = vim.tbl_contains(user_config.disable_builtin_plugins, 'comment-nvim'),
  })

  -- todo highlights
  use({
    'folke/todo-comments.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('cosmic.plugins.todo-comments')
    end,
    event = 'BufWinEnter',
    disable = vim.tbl_contains(user_config.disable_builtin_plugins, 'todo-comments'),
  })
  -- colorized hex codes
  use({
    'norcalli/nvim-colorizer.lua',
    opt = true,
    cmd = { 'ColorizerToggle' },
    config = function()
      require('colorizer').setup()
    end,
    disable = vim.tbl_contains(user_config.disable_builtin_plugins, 'colorizer'),
  })


  use {
  'abecodes/tabout.nvim',
  config = function()
    require('tabout').setup {
    tabkey = '<Tab>', -- key to trigger tabout, set to an empty string to disable
    -- backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
    act_as_tab = true, -- shift content if tab out is not possible
    act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
    enable_backwards = true, -- well ...
    completion = true, -- if the tabkey is used in a completion pum
    tabouts = {
      {open = "'", close = "'"},
      {open = '"', close = '"'},
      {open = '`', close = '`'},
      {open = '(', close = ')'},
      {open = '[', close = ']'},
      {open = '{', close = '}'}
    },
    ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
    exclude = {} -- tabout will ignore these filetypes
}
  end,
	wants = {'nvim-treesitter'}, -- or require if not used so far
	after = {'completion-nvim'} -- if a completion plugin is using tabs load it before
 }

  if user_config.add_plugins and not vim.tbl_isempty(user_config.add_plugins) then
    for _, plugin in pairs(user_config.add_plugins) do
      use(plugin)
    end
  end

  if cosmic_packer.first_install then
    packer.sync()
  end
end)
