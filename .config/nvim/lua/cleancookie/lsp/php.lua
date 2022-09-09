local lsp = require'lspconfig'
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
    }
}

lsp.intelephense.setup({
    capabilities = capabilities,
    settings = {
        intelephense = {
            stubs = { 
                "bcmath",
                "bz2",
                "Core",
                "curl",
                "zip",
                "zlib",
            },
            files = {
                maxSize = 5000000;
            };
        },
        volar = {}
    }
});