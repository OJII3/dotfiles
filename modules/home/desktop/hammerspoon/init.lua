-- CapsLock は nix-darwin (system.keyboard.remapCapsLockToControl) により
-- OS レベルで Control にリマップ済み。ここでは「単独で素早く離されたら Esc」
-- という tap 判定だけを担当する。
-- Karabiner 系のドライバ/カーネル拡張には依存せず、Accessibility 権限のみで動く。
-- 参考: https://github.com/af/dotfiles/blob/master/hammerspoon/ctrl_escape.lua

hs.autoLaunch(true)
hs.menuIcon(false)

local TAP_THRESHOLD = 0.15 -- これより長く押したら hold (Ctrl) 扱い

local sendEscape = false
local lastMods = {}

local holdTimer = hs.timer.delayed.new(TAP_THRESHOLD, function()
  sendEscape = false
end)

-- eventtap はグローバルに束縛しないと GC で回収されてしまう
ctrlTap = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, function(event)
  local mods = event:getFlags()
  if lastMods["ctrl"] == mods["ctrl"] then
    return false
  end
  if not lastMods["ctrl"] then
    lastMods = mods
    sendEscape = true
    holdTimer:start()
  else
    if sendEscape then
      hs.eventtap.keyStroke({}, "escape", 0)
    end
    lastMods = mods
    holdTimer:stop()
  end
  return false
end)
ctrlTap:start()

-- Control と一緒に他のキーが押されたら組み合わせ操作なので Esc は送らない
comboTap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function()
  sendEscape = false
  return false
end)
comboTap:start()
