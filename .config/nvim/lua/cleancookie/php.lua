local nvim_lsp = require'lspconfig'
nvim_lsp.intelephense.setup({
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
        };
    }
});