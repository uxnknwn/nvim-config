return {
    "ravitemer/mcphub.nvim",
    cmd = "MCPHub",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    build = "npm install -g mcp-hub@latest",
    config = function()
        require("mcphub").setup()
    end,
}
