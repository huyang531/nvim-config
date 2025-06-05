return {
    "nvim-neo-tree/neo-tree.nvim",
    name = "neo-tree",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- {"3rd/image.nvim", opts = {}}, – Optional image support in preview window: See `# Preview Mode` for more information
    },
    lazy = false, -- neo-tree will lazily load itself
    ---@module "neo-tree"
    ---@type neotree.Config?
    opts = {
        -- fill any relevant options here
    },
    config = function()
        require("neo-tree").setup({
            filesystem = {
                bind_to_cwd = true,
                follow_current_file = {
                    enabled = true,
                    leave_dirs_open = true,
                },
            },
        })
        -- vim.keymap.set(
        -- 			"n",
        -- 			"<leader>fe",
        -- 			":Neotree filesystem reveal left<CR>",
        -- 			{ desc = "Open Neotree Filesystem on the Left", noremap = true, silent = true }
        -- 		)
        vim.keymap.set(
            "n",
            "<leader>fe",
            ":Neotree toggle<CR>",
            { desc = "Toggle Neotree Filesystem on the Left", noremap = true, silent = true }
        )
        -- vim.keymap.set('n', '<leader>neo', ':Neotree focus<CR>', { desc = "Focus on Neotree" })
    end,
}
