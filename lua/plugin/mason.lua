local TOOLS = {
    "stylua",
    "black",
    "isort",
    "rustfmt",
    "prettier",
    "prettierd",
    "clang-format",
    "taplo",
    "ocamlformat",

    "luau-lsp",
    "pyright",
    "rust-analyzer",
    "clangd",
    "json-lsp",

    "flake8",
    "luacheck",
}

return {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
        require("mason").setup()

        local registry = require("mason-registry")

        for _, tool in ipairs(TOOLS) do
            if not registry.is_installed(tool) then
                local pkg = registry.get_package(tool)
                pkg:install()
            end
        end
    end,
}
