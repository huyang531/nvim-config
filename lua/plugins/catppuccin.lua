return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 10,
        config = function()
            require("catppuccin").setup()
            -- vim.cmd.colorscheme "catppuccin"
        end
    },
}
