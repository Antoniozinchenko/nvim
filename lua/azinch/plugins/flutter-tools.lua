local status, fluttertools = pcall(require, "flutter-tools")
if not status then
	return
end

-- local debugger_dir = path.join(fn.stdpath("cache"), "dart-code")
-- local debugger_path = path.join(debugger_dir, "out", "dist", "debug.js")

-- enable flutter tools
fluttertools.setup({
	flutter_path = "~/development/flutter",
	fvm = true, -- takes priority over path, uses <workspace>/.fvm/flutter_sdk if enabled
	ui = {
		-- the border type to use for all floating windows, the same options/formats
		-- used for ":h nvim_open_win" e.g. "single" | "shadow" | {<table-of-eight-chars>}
		border = "rounded",
		-- This determines whether notifications are show with `vim.notify` or with the plugin's custom UI
		-- please note that this option is eventually going to be deprecated and users will need to
		-- depend on plugins like `nvim-notify` instead.
		notification_style = "plugin",
	},
	-- decorations = {
	-- 	statusline = {
	-- 		-- set to true to be able use the 'flutter_tools_decorations.app_version' in your statusline
	-- 		-- this will show the current version of the flutter app from the pubspec.yaml file
	-- 		app_version = true,
	-- 		-- set to true to be able use the 'flutter_tools_decorations.device' in your statusline
	-- 		-- this will show the currently running device if an application was started with a specific
	-- 		-- device
	-- 		device = true,
	-- 	},
	-- },
	outline = {
		open_cmd = "30vnew", -- command to use to open the outline buffer
		auto_open = false, -- if true this will open the outline automatically when it is first populated
	},
	debugger = {
		enabled = true,
		run_via_dap = true,
		register_configurations = function(_)
			local dap = require("dap")
			-- dap.adapters.dart = {
			-- 	type = "executable",
			-- 	command = "node",
			-- 	args = { debugger_path, "flutter" },
			-- }
			dap.set_log_level("TRACE")
			dap.configurations.dart = {}
			require("dap.ext.vscode").load_launchjs()
		end,
	},
	dev_log = {
		enabled = true,
		open_cmd = "tabedit", -- command to use to open the log buffer
	},
	lsp = {
		-- color = { -- show the derived colours for dart variables
		-- 	enabled = true, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
		-- 	background = false, -- highlight the background
		-- 	foreground = false, -- highlight the foreground
		-- 	virtual_text = true, -- show the highlight using virtual text
		-- 	virtual_text_str = "■■", -- the virtual text character to highlight
		-- },
		settings = {
			showTodos = true,
			completeFunctionCalls = true,
			renameFilesWithClasses = "prompt", -- "always"
			enableSnippets = true,
			enableSdkFormatter = true,
		},
	},
})
