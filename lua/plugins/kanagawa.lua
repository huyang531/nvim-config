return {
    {
        "rebelot/kanagawa.nvim",
        name = "kanagawa",
        priority = 1000,
        config = function()
            require("kanagawa").setup({
                colors = {
                    palette = {
                        lotusWhite3 = "#fffdf0",
                    },
                },
            })
            vim.cmd("colorscheme kanagawa")
        end
    },
}
