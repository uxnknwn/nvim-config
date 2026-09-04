return {
    "catgoose/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        filetypes = { "*" },
        user_default_options = {
            names = false,
            rgb_fn = true,
            hsl_fn = true,
            css = true,
            mode = "background",
        },
    },
}
