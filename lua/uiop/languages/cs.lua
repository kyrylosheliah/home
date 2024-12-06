return {}

--[[
-- LOOK IN CURRENT DIRECTORY FOR csproj FILE using glob
-- IF NO FILE IN CURRENT DIRECTORY, LOOK IN PARENT DIRECTORY recursively
local function find_closest_csproj(directory)
  -- print("currentFileDirectory: " .. directory)
  local csproj = vim.fn.glob(directory .. "/*.csproj", true, false)
  if csproj == "" then
    csproj = vim.fn.glob(directory .. "/*.vbproj", true, false)
  end
  if csproj == "" then
    -- IF NO FILE IN CURRENT DIRECTORY, LOOK IN PARENT DIRECTORY recursively
    local parent_directory = vim.fn.fnamemodify(directory, ":h")
    if parent_directory == directory then
      return nil
    end
    return find_closest_csproj(parent_directory)
    -- elseif there are multiple csproj files, then return the first one
  elseif string.find(csproj, "\n") ~= nil then
    local first_csproj = string.sub(csproj, 0, string.find(csproj, "\n") - 1)
    print("Found multiple csproj files, using: " .. first_csproj)
    return first_csproj
  else
    return csproj
  end
end

-- CHECK CSPROJ FILE TO SEE IF ITS .NET CORE OR .NET FRAMEWORK
local function getFrameworkType()
  local currentFileDirectory = vim.fn.expand("%:p:h")
  -- print("currentFileDirectory file: " .. currentFileDirectory)
  local csproj = find_closest_csproj(currentFileDirectory)
  -- print("csproj file: " .. csproj)
  if csproj == nil then
    return false
  end
  local f = io.open(csproj, "rb")
  local content = f:read("*all")
  f:close()
  -- return string.find(content, "<TargetFramework>netcoreapp") ~= nil
  local frameworkType = ""
  -- IF FILE CONTAINS <TargetFrameworkVersion> THEN IT'S .NET FRAMEWORK
  if string.find(content, "<TargetFrameworkVersion>") ~= nil then
    frameworkType = "netframework"
    -- IF FILE CONTAINS <TargetFramework>net48 THEN IT'S .NET FRAMEWORK
  elseif string.find(content, "<TargetFramework>net48") ~= nil then
    frameworkType = "netframework"
    -- ELSE IT'S .NET CORE
  else
    frameworkType = "netcore"
  end
  return frameworkType
end

return {

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "c_sharp"
      },
    },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      ensure_installed = {
        "omnisharp",
        "omnisharp_mono",
        "csharpier",
        --"coreclr",
        "netcoredbg",
      },
    },
  },

  {
    "Decodetalkers/csharpls-extended-lsp.nvim",
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "Hoffs/omnisharp-extended-lsp.nvim",
      'Issafalcon/lsp-overloads.nvim'
    },
    opts = {
      ensure_installed = {
        "omnisharp",
        "omnisharp_mono",
      },
      handlers = {
        ["omnisharp"] = function()

          if vim.g.dotnetlsp then
            -- print("dotnetlsp is already set: " .. vim.g.dotnetlsp)
            return
          end

          local on_attach = function (client, bufnr)
            --- Guard against servers without the signatureHelper capability
            if client.server_capabilities.signatureHelpProvider then
              require('lsp-overloads').setup(client, { })
              -- ...
              -- keymaps = {
              -- 		next_signature = "<C-j>",
              -- 		previous_signature = "<C-k>",
              -- 		next_parameter = "<C-l>",
              -- 		previous_parameter = "<C-h>",
              -- 		close_signature = "<A-s>"
              -- 	},
              -- ...
            end
          end

          -- SEE: https://github.com/omnisharp/omnisharp-roslyn
          local settings = {
            FormattingOptions = {
              -- Enables support for reading code style, naming convention and analyzer
              -- settings from .editorconfig.
              EnableEditorConfigSupport = true,
              -- Specifies whether 'using' directives should be grouped and sorted during
              -- document formatting.
              OrganizeImports = true,
            },
            MsBuild = {
              -- If true, MSBuild project system will only load projects for files that
              -- were opened in the editor. This setting is useful for big C# codebases
              -- and allows for faster initialization of code navigation features only
              -- for projects that are relevant to code that is being edited. With this
              -- setting enabled OmniSharp may load fewer projects and may thus display
              -- incomplete reference lists for symbols.
              LoadProjectsOnDemand = nil,
            },
            RoslynExtensionsOptions = {
              -- Enables support for roslyn analyzers, code fixes and rulesets.
              EnableAnalyzersSupport = false, -- THIS ADED FIX FORMATTING ON EVERY SINGLE LINE IN CS FILES!
              -- Enables support for showing unimported types and unimported extension
              -- methods in completion lists. When committed, the appropriate using
              -- directive will be added at the top of the current file. This option can
              -- have a negative impact on initial completion responsiveness,
              -- particularly for the first few completion sessions after opening a
              -- solution.
              EnableImportCompletion = nil,
              -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
              -- true
              AnalyzeOpenDocumentsOnly = nil,
              enableDecompilationSupport = true,
            },
            Sdk = {
              -- Specifies whether to include preview versions of the .NET SDK when
              -- determining which version to use for project loading.
              IncludePrereleases = true,
            },
          }

          -- CHECK THE CSPROJ OR SOMETHING ELSE TO CONFIRM IT'S .NET FRAMEWORK OR .NET CORE PROJECT
          local frameworkType = getFrameworkType()
          if frameworkType == "netframework" then
            print("Found a .NET Framework project, starting .NET Framework OmniSharp")
            vim.g.dotnetlsp = "omnisharp_mono"
          elseif frameworkType == "netcore" then
            print("Found a .NET Core project, starting .NET Core OmniSharp")
            vim.g.dotnetlsp = "omnisharp"
          else
            return
          end

          require("lspconfig")[vim.g.dotnetlsp].setup({
            -- enable_decompilation_support = true,
            handlers = {
              --["textDocument/definition"] = require('omnisharp_extended').handler,
              ["textDocument/definition"] = require('omnisharp_extended').definition_handler,
              ["textDocument/typeDefinition"] = require('omnisharp_extended').type_definition_handler,
              ["textDocument/references"] = require('omnisharp_extended').references_handler,
              ["textDocument/implementation"] = require('omnisharp_extended').implementation_handler,
            },
            -- organize_imports_on_format = true,
            settings = settings,
            on_attach = on_attach,
          })
          vim.cmd("LspStart " .. vim.g.dotnetlsp)
        end,
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        cs = { "csharpier" },
      },
      --formatters = {
      --  csharpier = {
      --    command = "dotnet-csharpier",
      --    args = { "--write-stdout" },
      --  },
      --},
    },
  },

  {
    "nvim-neotest/neotest",
    dependencies = { "Issafalcon/neotest-dotnet" },
    opts = function(_, opts)
      local neotest_dotnet = require("neotest-dotnet")
      local dotnet_adapter = neotest_dotnet({
        --dap = {
        --  -- Extra arguments for nvim-dap configuration
        --  -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
        --  args = {justMyCode = false },
        --  -- Enter the name of your dap adapter, the default value is netcoredbg
        --  adapter_name = "netcoredbg"
        --},
        ---- Let the test-discovery know about your custom attributes (otherwise tests will not be picked up)
        ---- Note: Only custom attributes for non-parameterized tests should be added here. See the support note about parameterized tests
        --custom_attributes = {
        --  xunit = { "MyCustomFactAttribute" },
        --  nunit = { "MyCustomTestAttribute" },
        --  mstest = { "MyCustomTestMethodAttribute" }
        --},
        ---- Provide any additional "dotnet test" CLI commands here. These will be applied to ALL test runs performed via neotest. These need to be a table of strings, ideally with one key-value pair per item.
        --dotnet_additional_args = {
        --  "--verbosity detailed"
        --},
        ---- Tell neotest-dotnet to use either solution (requires .sln file) or project (requires .csproj or .fsproj file) as project root
        ---- Note: If neovim is opened from the solution root, using the 'project' setting may sometimes find all nested projects, however,
        ----       to locate all test projects in the solution more reliably (if a .sln file is present) then 'solution' is better.
        --discovery_root = "project" -- Default
      })
      opts.adapters = opts.adapters or {}
      opts.adapters = vim.tbl_deep_extend("force", opts.adapters, {
        dotnet_adapter,
      })
      return opts
    end,
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = {
      },
      handlers = {
        netcoredbg = function(config)
          config.adapters = {
            type = "executable",
            command = vim.fn.exepath("netcoredbg"),
            args = { "--interpreter=vscode" },
            options = {
              detached = false,
            },
          }
          require('mason-nvim-dap').default_setup(config) -- don't forget this!
        end,
      },
    },
  },

}
]]

--[[
for _, lang in ipairs({ "cs", "fsharp", "vb" }) do
        if not dap.configurations[lang] then
          dap.configurations[lang] = {
            {
              type = "netcoredbg",
              name = "Launch file",
              request = "launch",
              ---@diagnostic disable-next-line: redundant-parameter
              program = function()
                return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/", "file")
              end,
              cwd = "${workspaceFolder}",
            },
          }
        end
      end
--]]
