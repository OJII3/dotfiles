return {
	"williamboman/mason.nvim",
	init = function()
		local mason = require("mason")
		local mason_lsp = require("mason-lspconfig")

		-- Make mason packages work with nixos
		-- We're using patchelf to mathe that work
		-- Thanks to: https://github.com/williamboman/mason.nvim/issues/428#issuecomment-1357192515
		local function return_exe_value(cmd)
			local handle = io.popen(cmd)
			local result = handle:read("*a")
			handle:close()

			return result
		end

		local mason_registry = require("mason-registry")
		if is_linux and vim.api.nvim_exec("!cat /etc/os-release | grep '^NAME'", true):find("NixOS") ~= nil then
			mason_registry:on("package:install:success", function(pkg)
				pkg:get_receipt():if_present(function(receipt)
					-- Figure out the interpreter inspecting nvim itself
					-- This is the same for all packages, so compute only once
					-- Set the interpreter on the binary
					local nvim = return_exe_value("nix path-info -r /run/current-system | grep neovim-unwrapped"):sub(1, -2)
					local interpreter =
						return_exe_value(("patchelf --print-interpreter %q" .. "/bin/nvim"):format(nvim)):sub(1, -2)
					for _, rel_path in pairs(receipt.links.bin) do
						local bin_abs_path = pkg:get_install_path() .. "/" .. rel_path
						if pkg.name == "lua-language-server" then
							bin_abs_path = pkg:get_install_path() .. "/extension/server/bin/lua-language-server"
							os.execute(("patchelf --set-interpreter %s %s"):format(interpreter, bin_abs_path))
						elseif pkg.name == "marksman" then
							bin_abs_path = pkg:get_install_path() .. "/marksman"
							local libstdcpp = return_exe_value(
								"nix path-info -r /run/current-system | grep gcc | grep lib | head -n1"
							):sub(1, -2) .. "/lib"
							local zlib = return_exe_value("nix path-info -r /run/current-system | grep zlib | head -n1"):sub(1, -2)
								.. "/lib"
							local icu4c = return_exe_value("nix path-info -r /run/current-system | grep icu4c | head -n1"):sub(1, -2)
								.. "/lib"
							os.execute(
								("patchelf --set-interpreter %s --set-rpath %s:%s:%s %s"):format(
									interpreter,
									libstdcpp,
									zlib,
									icu4c,
									bin_abs_path
								)
							)
						elseif pkg.name == "stylua" then
							bin_abs_path = pkg:get_install_path() .. "/stylua"
							os.execute(("patchelf --set-interpreter %s %s"):format(interpreter, bin_abs_path))
						elseif pkg.name == "texlab" then
							bin_abs_path = pkg:get_install_path() .. "/texlab"
							os.execute(("patchelf --set-interpreter %s %s"):format(interpreter, bin_abs_path))
						end
					end
				end)
			end)
		end
	end,
}
