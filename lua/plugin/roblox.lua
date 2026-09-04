local function is_project_marker(name)
    return name:match(".+%.project%.json$") ~= nil
end

local function roblox_project(source)
    if not source or source == "" then
        source = vim.api.nvim_buf_get_name(0)
    end
    if source == "" then
        source = vim.uv.cwd()
    end

    local ok, root = pcall(vim.fs.root, source, is_project_marker)
    if not ok then
        return nil
    end
    return root
end

vim.filetype.add({
    extension = {
        lua = function(path)
            if path:match("%.nvim%.lua$") then
                return "lua"
            end
            return roblox_project(path) and "luau" or "lua"
        end,
    },
})

return {
    "lopi-py/luau-lsp.nvim",
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("luau-lsp").setup({
            plugin = { enabled = true, port = 3667 },
            types = { plugin_security_level = "PluginSecurity" },
            platform = { type = roblox_project() and "roblox" or "standard" },
            sourcemap = {
                enabled = true,
                autogenerate = false,
                rojo_project_file = "default.project.json",
                sourcemap_file = "sourcemap.json",
            },
            fflags = {
                enable_new_solver = true,
            },
            server = { path = "luau-lsp" },
        })

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
        if ok then
            capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
        end

        vim.lsp.config("luau-lsp", {
            capabilities = capabilities,
            settings = {
                ["luau-lsp"] = {
                    completion = {
                        enabled = true,
                        autocomplete = true,
                        autocompleteEnd = true,
                        fillCallArguments = false,
                        addParentheses = true,
                        imports = { enabled = false, requireStyle = "alwaysAbsolute" },
                    },
                    inlayHints = {
                        functionReturnTypes = true,
                        parameterTypes = true,
                    },
                },
            },
            on_attach = function(client, bufnr)
                require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
            end,
        })

        local function run_sourcemap()
            local project_root = roblox_project()
            if not project_root then
                return
            end

            local scripts_dir = vim.fs.find("scripts", { path = project_root, upward = true })[1]
            local script = scripts_dir and scripts_dir .. "/sourcemap.sh"
            local command

            if script and vim.fn.filereadable(script) == 1 then
                command = { "bash", script }
            else
                command = { "rojo", "sourcemap", "default.project.json", "--output", "sourcemap.json" }
            end

            local output = {}
            local job = vim.fn.jobstart(command, {
                cwd = project_root,
                stdout_buffered = true,
                stderr_buffered = true,
                on_stdout = function(_, data)
                    vim.list_extend(output, data or {})
                end,
                on_stderr = function(_, data)
                    vim.list_extend(output, data or {})
                end,
                on_exit = function(_, code)
                    if code ~= 0 then
                        local message = table.concat(
                            vim.tbl_filter(function(line)
                                return line ~= ""
                            end, output),
                            "\n"
                        )
                        vim.notify("Sourcemap failed:\n" .. message, vim.log.levels.ERROR)
                    end
                end,
            })

            if job <= 0 then
                vim.notify("Failed to start sourcemap command", vim.log.levels.ERROR)
            end
        end

        vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = { "*.lua", "*.luau" },
            callback = function()
                run_sourcemap()
            end,
        })

        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
                run_sourcemap()
            end,
        })
    end,
}
