return {
	{
		"cormacrelf/dark-notify",
		name = "dark_notify",
		config = function()
			local dn = require("dark_notify")
			dn.run({
				shcemes = {
					dark = "kanagawa-wave",
					light = "kanagawa-dragon",
				},
			})
		end,
	},
}
