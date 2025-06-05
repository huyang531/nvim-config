return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"leoluz/nvim-dap-go",
		},
		config = function()
			local dap, dapui = require("dap"), require("dapui")

			-- setup dap log (use INFO in normal cases, DEBUG or TRACE for debugging)
			dap.set_log_level("INFO")

			-- setup dap keymap
			vim.keymap.set("n", "<F5>", dap.continue, {})
			vim.keymap.set("n", "<F10>", dap.step_over, {})
			vim.keymap.set("n", "<F11>", dap.step_into, {})
			vim.keymap.set("n", "<F12>", dap.step_out, {})
			vim.keymap.set("n", "<Leader>db", dap.set_breakpoint, {})
			vim.keymap.set("n", "<Leader>dB", function()
				dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end, {})
			vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, {})
			vim.keymap.set("n", "<Leader>dc", dap.continue, {})
			vim.keymap.set("n", "<Leader>dr", dap.repl.open, {})
			vim.keymap.set("n", "<Leader>dl", dap.run_last, {})
			vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
				require("dap.ui.widgets").hover()
			end)
			vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
				require("dap.ui.widgets").preview()
			end)
			vim.keymap.set("n", "<Leader>df", function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.frames)
			end)
			vim.keymap.set("n", "<Leader>ds", function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.scopes)
			end)

			-- setup dap ui
			dapui.setup()
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			-- setup cpp/c/rust debugger (lldb)
			dap.adapters.lldb = {
				type = "executable",
				command = "/Applications/Xcode.app/Contents/Developer/usr/bin/lldb-dap",
				name = "lldb",
			}

			dap.configurations.cpp = {
				{
					name = "Launch",
					type = "lldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = {},
					env = function()
						local variables = {}
						for k, v in pairs(vim.fn.environ()) do
							table.insert(variables, string.format("%s=%s", k, v))
						end
						return variables
					end,
				},
			}

			dap.configurations.c = dap.configurations.cpp

			dap.configurations.rust = {
				{
					name = "Launch",
					type = "lldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = {},
					initCommands = function()
						-- Find out where to look for the pretty printer Python module.
						local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))
						assert(
							vim.v.shell_error == 0,
							"failed to get rust sysroot using `rustc --print sysroot`: " .. rustc_sysroot
						)
						local script_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_lookup.py"
						local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"

						-- The following is a table/list of lldb commands, which have a syntax
						-- similar to shell commands.
						--
						-- To see which command options are supported, you can run these commands
						-- in a shell:
						--
						--   * lldb --batch -o 'help command script import'
						--   * lldb --batch -o 'help command source'
						--
						-- Commands prefixed with `?` are quiet on success (nothing is written to
						-- debugger console if the command succeeds).
						--
						-- Prefixing a command with `!` enables error checking (if a command
						-- prefixed with `!` fails, subsequent commands will not be run).
						--
						-- NOTE: it is possible to put these commands inside the ~/.lldbinit
						-- config file instead, which would enable rust types globally for ALL
						-- lldb sessions (i.e. including those run outside of nvim). However,
						-- that may lead to conflicts when debugging other languages, as the type
						-- formatters are merely regex-matched against type names. Also note that
						-- .lldbinit doesn't support the `!` and `?` prefix shorthands.
						return {
							([[!command script import '%s']]):format(script_file),
							([[command source '%s']]):format(commands_file),
						}
					end,
					env = function()
						local variables = {}
						for k, v in pairs(vim.fn.environ()) do
							table.insert(variables, string.format("%s=%s", k, v))
						end
						return variables
					end,
				},
			}

			-- setup go debugger
			require("dap-go").setup()
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"nvim-neotest/nvim-nio",
		},
	},
}
