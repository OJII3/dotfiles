-- fcitx5 の IME を Neovim のモードに連動させる (vi 協調モード)。
-- insert mode を抜けたら IME を止め、戻ったら直前の状態に戻す。
-- cmdline を抜けたときも止める。
-- fcitx5 がない環境 (macOS や SSH 先) では何もしない。
local available = vim.fn.executable("fcitx5-remote") == 1
local ime_was_active = false

local function fcitx5_remote(...)
	return vim.system({ "fcitx5-remote", ... }):wait()
end

local function is_active()
	local result = fcitx5_remote()
	return result.code == 0 and vim.trim(result.stdout) == "2"
end

if available then
	local group = vim.api.nvim_create_augroup("ime", { clear = true })

	vim.api.nvim_create_autocmd("InsertLeave", {
		group = group,
		callback = function()
			ime_was_active = is_active()
			if ime_was_active then
				fcitx5_remote("-c")
			end
		end,
	})

	vim.api.nvim_create_autocmd("InsertEnter", {
		group = group,
		callback = function()
			if ime_was_active then
				fcitx5_remote("-o")
			end
		end,
	})

	vim.api.nvim_create_autocmd("CmdlineLeave", {
		group = group,
		callback = function()
			if is_active() then
				fcitx5_remote("-c")
			end
		end,
	})
end

return {
	-- skkeleton などアプリ側の IME を使うときに fcitx5 を止める。
	disable = function()
		if available then
			fcitx5_remote("-c")
			ime_was_active = false
		end
	end,
}
