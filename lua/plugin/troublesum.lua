return {
    "ivanjermakov/troublesum.nvim",
    config = function()
        require("troublesum").setup({
            enabled = true,
            autocmd = true,
            severity_format = { "", "", "", "" },
            severity_highlight = { "DiagnosticError", "DiagnosticWarn", "DiagnosticInfo", "DiagnosticHint" },
        })
    end,
}
