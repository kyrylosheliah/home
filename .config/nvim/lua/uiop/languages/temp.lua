if true then return {} end


    --[[
    "html",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "css",
    "Makefile",
    "c",
    "cpp",
    "cs",
]]


M.get_cpp_capabilities = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem["snippetSupport"] = true
    capabilities.textDocument.completion.completionItem["resolveSupport"] = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    }
    local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if status_ok then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end
    capabilities["offsetEncoding"] = "utf-16"
    capabilities.experimental = {
        workspaceWillRename = true,
    }
    return capabilities
end












-- C++ only

    if not disable.signature_help  then
      require("lsp-overloads").setup(client, {
        keymaps = {
          next_signature = "<A-j>",
          previous_signature = "<A-k>",
          next_parameter = "<A-l>",
          previous_parameter = "<A-h>",
          close_signature = "<A-n>"
        },
      })
    end





















M.default_config = function(file_types)
    return {
        flags = {
            debounce_text_changes = default_debouce_time,
        },
        autostart = true,
        filetypes = file_types,
        on_attach = function(client, bufnr)
            setup_diagnostics.keymaps(client, bufnr)
            setup_diagnostics.omni(client, bufnr)
            setup_diagnostics.tag(client, bufnr)
            setup_diagnostics.document_highlight(client, bufnr)
            setup_diagnostics.document_formatting(client, bufnr)
            setup_diagnostics.inlay_hint(client, bufnr)
            if client.server_capabilities.documentSymbolProvider then
                navic.attach(client, bufnr)
            end
        end,
        capabilities = setup_diagnostics.get_capabilities(),
        root_dir = function(fname)
            return nvim_lsp_util.find_git_ancestor(fname) or vim.fn.getcwd()
        end,
    }
end

M.without_formatting = function(file_types)
    return {
        flags = {
            debounce_text_changes = default_debouce_time,
        },
        autostart = true,
        filetypes = file_types,
        on_attach = function(client, bufnr)
            setup_diagnostics.keymaps(client, bufnr)
            setup_diagnostics.omni(client, bufnr)
            setup_diagnostics.tag(client, bufnr)
            setup_diagnostics.document_highlight(client, bufnr)
            setup_diagnostics.inlay_hint(client, bufnr)
            if client.server_capabilities.documentSymbolProvider then
                navic.attach(client, bufnr)
            end
        end,
        capabilities = setup_diagnostics.get_capabilities(),
        root_dir = function(fname)
            return nvim_lsp_util.find_git_ancestor(fname) or vim.fn.getcwd()
        end,
    }
end

M.without_winbar_config = function(file_types)
    return {
        flags = {
            debounce_text_changes = default_debouce_time,
        },
        autostart = true,
        filetypes = file_types,
        root_dir = function(fname)
            return nvim_lsp_util.find_git_ancestor(fname) or vim.fn.getcwd()
        end,
    }
end

M.cpp_config = function(file_types)
    return {
        flags = {
            debounce_text_changes = default_debouce_time,
        },
        autostart = true,
        filetypes = file_types,
        on_attach = function(client, bufnr)
            client.offset_encoding = "utf-16"
            setup_diagnostics.keymaps(client, bufnr)
            setup_diagnostics.omni(client, bufnr)
            setup_diagnostics.tag(client, bufnr)
            setup_diagnostics.document_highlight(client, bufnr)
            setup_diagnostics.document_formatting(client, bufnr)
            setup_diagnostics.inlay_hint(client, bufnr)
            if client.server_capabilities.documentSymbolProvider then
                navic.attach(client, bufnr)
            end
        end,
        capabilities = setup_diagnostics.get_cpp_capabilities(),
        root_dir = function(fname)
            return nvim_lsp_util.find_git_ancestor(fname) or vim.fn.getcwd()
        end,
    }
end

M.omnisharp_config = function(file_types)
    return {
        cmd = { "dotnet", global.mason_path .. "/packages/omnisharp/OmniSharp.dll" },
        flags = {
            debounce_text_changes = default_debouce_time,
        },
        autostart = true,
        filetypes = file_types,
        on_attach = function(client, bufnr)
            setup_diagnostics.keymaps(client, bufnr)
            setup_diagnostics.omni(client, bufnr)
            setup_diagnostics.tag(client, bufnr)
            setup_diagnostics.document_highlight(client, bufnr)
            setup_diagnostics.document_formatting(client, bufnr)
            setup_diagnostics.inlay_hint(client, bufnr)
            if client.server_capabilities.documentSymbolProvider then
                navic.attach(client, bufnr)
            end
        end,
        capabilities = setup_diagnostics.get_capabilities(),
        root_dir = function(fname)
            return nvim_lsp_util.find_git_ancestor(fname) or vim.fn.getcwd()
        end,
    }
end
