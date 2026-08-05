-- Karabiner 系のドライバ/カーネル拡張には依存せず、Accessibility 権限のみで動く
-- キーリマップ。
--
--   CapsLock : tap = Esc / hold = Ctrl
--
-- CapsLock -> Control のリマップ自体は nix-darwin 側
-- (system.keyboard.remapCapsLockToControl) が OS レベルで済ませているので、
-- ここは tap/hold の判定だけを担当する。
-- 参考: https://github.com/af/dotfiles/blob/master/hammerspoon/ctrl_escape.lua

hs.autoLaunch(true)
hs.menuIcon(false)

local eventTypes = hs.eventtap.event.types
local eventProps = hs.eventtap.event.properties

-- 自前で合成したイベントの目印。これを見て素通しすることで、
-- 自分が出したキーを自分で拾ってしまうのを防ぐ。
local SYNTHETIC = 0x48530001

local function isSynthetic(event)
  return event:getProperty(eventProps.eventSourceUserData) == SYNTHETIC
end

-- キーを1回叩いたことにする (down/up をまとめて合成する)
local function postKeyTap(mods, key)
  for _, isDown in ipairs({ true, false }) do
    local event = hs.eventtap.event.newKeyEvent(mods, key, isDown)
    event:setProperty(eventProps.eventSourceUserData, SYNTHETIC)
    event:post()
  end
end

-- 設定を書き換えたら Hammerspoon を再起動せずに反映されるようにする
configWatcher = hs.pathwatcher.new(hs.configdir, hs.reload)
configWatcher:start()

--------------------------------------------------------------------------------
-- CapsLock (= Control): tap = Esc / hold = Ctrl
--------------------------------------------------------------------------------

local CTRL_TAP_THRESHOLD = 0.15 -- これより長く押したら hold (Ctrl) 扱い

local ctrlSendEscape = false
local ctrlLastMods = {}

local ctrlHoldTimer = hs.timer.delayed.new(CTRL_TAP_THRESHOLD, function()
  ctrlSendEscape = false
end)

-- eventtap はグローバルに束縛しないと GC で回収されてしまう
ctrlTap = hs.eventtap.new({ eventTypes.flagsChanged }, function(event)
  local mods = event:getFlags()
  if ctrlLastMods["ctrl"] == mods["ctrl"] then
    return false
  end
  if not ctrlLastMods["ctrl"] then
    ctrlLastMods = mods
    ctrlSendEscape = true
    ctrlHoldTimer:start()
  else
    if ctrlSendEscape then
      postKeyTap({}, "escape")
    end
    ctrlLastMods = mods
    ctrlHoldTimer:stop()
  end
  return false
end)
ctrlTap:start()

-- Ctrl と一緒に他のキーが押されたら組み合わせ操作なので Esc は送らない
comboTap = hs.eventtap.new({ eventTypes.keyDown }, function(event)
  if not isSynthetic(event) then
    ctrlSendEscape = false
  end
  return false
end)
comboTap:start()
