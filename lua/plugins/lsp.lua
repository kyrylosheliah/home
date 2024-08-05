return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			{ "folke/neodev.nvim", opts = {} },
		},
		config = function()
      --    every time a new file is opened that is associated with an lsp
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.clear_references,
						})
					end
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
			local servers = {
				-- clangd = {},
				-- gopls = {},
				-- pyright = {},
				-- rust_analyzer = {},
				-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
				--
				-- Some languages (like typescript) have entire language plugins that can be useful:
				--    https://github.com/pmizio/typescript-tools.nvim
				--
				-- But for many setups, the LSP (`tsserver`) will work just fine
				-- tsserver = {},
				--

				lua_ls = {
					-- cmd = {...},
					-- filetypes = { ...},
					-- capabilities = {},
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							-- diagnostics = { disable = { 'missing-fields' } },
						},
					},
				},
			}

			require("mason").setup()
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})

      require('lspconfig').unocss.setup({
        filetypes = { "html", "javascriptreact", "rescript", "typescriptreact", "vue", "svelte", "typescript" },
        root_dir = require('lspconfig').util.root_pattern('unocss.config.js', 'unocss.config.ts', 'uno.config.js', 'uno.config.ts'),
      })
		end,
	},

	{ -- Autoformat
		"stevearc/conform.nvim",
		lazy = false,
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			--[[format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,]]
			--
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform can also run multiple formatters sequentially
				-- python = { "isort", "black" },
				--
				-- You can use a sub-list to tell conform to run *until* a formatter
				-- is found.
				-- javascript = { { "prettierd", "prettier" } },
			},
		},
	},

	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					-- `friendly-snippets` contains a variety of premade snippets.
					--    See the README about individual language/framework/plugin snippets:
					--    https://github.com/rafamadriz/friendly-snippets
					-- {
					--   'rafamadriz/friendly-snippets',
					--   config = function()
					--     require('luasnip.loaders.from_vscode').lazy_load()
					--   end,
					-- },
				},
			},
			"saadparwaiz1/cmp_luasnip",

			-- Adds other completion capabilities.
			--  nvim-cmp does not ship with all sources by default. They are split
			--  into multiple repos for maintenance purposes.
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
		},
		config = function()
			-- See `:help cmp`
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },

				-- For an understanding of why these mappings were
				-- chosen, you will need to read `:help ins-completion`
				--
				-- No, but seriously. Please read `:help ins-completion`, it is really good!
				mapping = cmp.mapping.preset.insert({
					-- Select the [n]ext item
					["<C-n>"] = cmp.mapping.select_next_item(),
					-- Select the [p]revious item
					["<C-p>"] = cmp.mapping.select_prev_item(),

					-- Scroll the documentation window [b]ack / [f]orward
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),

					-- Accept ([y]es) the completion.
					--  This will auto-import if your LSP supports it.
					--  This will expand snippets if the LSP sent a snippet.
					["<C-y>"] = cmp.mapping.confirm({ select = true }),

					-- Manually trigger a completion from nvim-cmp.
					--  Generally you don't need this, because nvim-cmp will display
					--  completions whenever it has completion options available.
					["<C-Space>"] = cmp.mapping.complete({}),

					-- Think of <c-l> as moving to the right of your snippet expansion.
					--  So if you have a snippet that's like:
					--  function $name($args)
					--    $body
					--  end
					--
					-- <c-l> will move you to the right of each of the expansion locations.
					-- <c-h> is similar, except moving you backwards.
					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),

					-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
					--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
				},
			})
		end,
	},
}

--[[
return {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v3.x',
  lazy = false,
  dependencies = {
    -- LSP Support
    'neovim/nvim-lspconfig',

    --- Manage the language servers from neovim
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',

    -- Autocompletion
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',

    --'saadparwaiz1/cpm_luasnip',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',

    -- Snippets
    'L3MON4D3/LuaSnip',
    'rafamadriz/friendly-snippets',
  },
  config = function()
    local lsp_zero = require('lsp-zero')
    --lsp_zero.preset('recommended')
    --lsp_zero.set_preferences({
    --    --suggest_lsp_servers = false,
    --    sign_icons = {
    --        error = 'E',
    --        warn = 'W',
    --        hint = 'H',
    --        info = 'I'
    --    }
    --})
    lsp_zero.on_attach(function(client, bufnr)
      local opts = { buffer = bufnr, remap = false }
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
      vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
      vim.keymap.set("n", "<F3>", vim.lsp.buf.format, opts)
      vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
      vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
      vim.keymap.set("n", "<F5>", vim.lsp.buf.workspace_symbol, opts)
    end)
    lsp_zero.setup()
         -- -- Jump to the definition. To jump back, press <C-t>.
         -- map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
         -- map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
         -- map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
         -- map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
         -- -- Fuzzy find all the symbols in your current document.
         -- map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
         -- map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
         -- map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
         -- -- Usually your cursor needs to be on top of an error or a suggestion from your LSP
         -- map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
         -- map('K', vim.lsp.buf.hover, 'Hover Documentation')
         -- map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

         -- -- Highlight references of the hovered word. Moving cursor clears it.
         -- local client = vim.lsp.get_client_by_id(event.data.client_id)
         -- if client and client.server_capabilities.documentHighlightProvider then
         --   vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
         --     buffer = event.buf,
         --     callback = vim.lsp.buf.document_highlight,
         --   })
         --   vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
         --     buffer = event.buf,
         --     callback = vim.lsp.buf.clear_references,
         --   })
         -- end

    require('mason').setup()
    require('mason-lspconfig').setup({
      handlers = {
        lsp_zero.default_setup,
        --lua_ls = function()
        --  -- (Optional) configure lua language server
        --  local lua_opts = lsp_zero.nvim_lua_ls()
        --  require('lspconfig').lua_ls.setup(lua_opts)
        --end,
      },
      ensure_installed = {
        'tsserver',
        'eslint',
        'html',
        'cssls',
      }
    })
    require('lspconfig').unocss.setup({
      filetypes = { "html", "javascriptreact", "rescript", "typescriptreact", "vue", "svelte", "typescript" },
      root_dir = require('lspconfig').util.root_pattern('unocss.config.js', 'unocss.config.ts', 'uno.config.js', 'uno.config.ts'),
    })

    vim.diagnostic.config({
      virtual_text = true
    })

    local cmp = require('cmp')
    local cmp_action = lsp_zero.cmp_action()
    --local cmp_select = {behavior = cmp.SelectBehavior.Select}
    cmp.setup({
      experimental = {
        ghost_text = { hl_group = { "Whitespace" } },
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
       -- -- For an understanding of why these mappings were
       -- -- chosen, you will need to read `:help ins-completion`
       -- mapping = cmp.mapping.preset.insert {
       --   ['<C-b>'] = cmp.mapping.scroll_docs(-4), -- [b]ack
       --   ['<C-f>'] = cmp.mapping.scroll_docs(4), -- [f]orward
       --   ['<C-l>'] = cmp.mapping(function()
       --     if luasnip.expand_or_locally_jumpable() then
       --       luasnip.expand_or_jump()
       --     end
       --   end, { 'i', 's' }),
       --   ['<C-h>'] = cmp.mapping(function()
       --     if luasnip.locally_jumpable(-1) then
       --       luasnip.jump(-1)
       --     end
       --   end, { 'i', 's' }),
      mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-f>'] = cmp_action.luasnip_jump_forward(),
        ['<C-b>'] = cmp_action.luasnip_jump_backward(),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<S-Tab>'] = nil,
        ['<S>'] = nil,
      }),
      sources = {
        --{ name = "codeium" },
        { name = 'nvim_lsp' },
        { name = "path" },
        --{ name = "buffer" },
        --{ name = "luasnip" },
        ----{ name = "lua_ls" },
        --{ name = "vimls" },
        --{ name = "nvim_lua" },
        --{ name = "css-lsp" },
        --{ name = "css-variables-language-server" },
        { name = "emmet_language_server" },
        { name = "html" },
        { name = "unocss" },
      }
    })
    --vim.api.nvim_create_autocmd('FileType', { callback = function()
    --    require('cmp').setup.buffer({
    --
    --    })
    --  end,
    --})
  end
}
]]
--
