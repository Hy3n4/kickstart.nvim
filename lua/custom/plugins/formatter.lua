return {
	'mhartington/formatter.nvim',
	config = function()
		-- Utilities for creating configurations
		local util = require "formatter.util"

		-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
		require("formatter").setup({
			-- Enable or disable logging
			logging = true,
			-- Set the log level
			log_level = vim.log.levels.DEBUG,
			-- All formatter configurations are opt-in
			filetype = {
				go = {
					require("formatter.filetypes.go").gofmt,
				},
				lua = {
					require("formatter.filetypes.lua").stylua,
					function()
						return {
							exe = "stylua",
							args = {
								"--column-width",
								"120",
								"--indent-type",
								"Spaces",
								"--indent-width",
								"2",
								"--search-parent-directories",
								"--stdin-filepath",
								util.escape_path(util
								.get_current_buffer_file_path()),
								"--",
								"-",
							},
							stdin = true,
						}
					end
				},
				["*"] = {
					require("formatter.filetypes.any")
					    .remove_trailing_whitespace,
					function()
						vim.lsp.buf.format({ async = true })
					end,
				}
			}
		})
	end,
}
