-- Karabiner 系のドライバ/カーネル拡張には依存せず、Accessibility 権限のみで動く
-- キーリマップ。
--
--   CapsLock : tap = Esc  / hold = Ctrl
--   Space    : tap = Space / hold = Command
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
-- 自分が出したキーを自分で拾って無限ループするのを防ぐ。
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

--------------------------------------------------------------------------------
-- Space: tap = Space / hold = Command
--------------------------------------------------------------------------------

-- space を押してからこの時間を超えて押し続けたときだけ Cmd として振る舞う。
-- 短く終わったものは「押し重なりを含む通常のタイピング」として扱う。
local SPACE_HOLD_THRESHOLD = 0.2

-- space 長押しが Cmd になるとジャンプ/ホバリングができなくなるアプリ。
-- アプリ名か bundle ID の部分一致で判定する (小文字で書くこと)。
local SPACE_EXCLUDED_APPS = { "minecraft" }

local spacePressedAt = nil -- space 押下時刻 (押していなければ nil)
local spaceResolvedAsTap = false -- この押下は既にスペースとして送出済みか
local spaceDisabled = false -- 除外アプリが最前面にいるか

-- 判定を space の打鍵ごとにやると重いので、アプリ切り替え時にだけ更新する
local function refreshSpaceDisabled()
  local app = hs.application.frontmostApplication()
  if not app then
    spaceDisabled = false
    return
  end
  local name = (app:name() or ""):lower()
  local bundleID = (app:bundleID() or ""):lower()
  for _, pattern in ipairs(SPACE_EXCLUDED_APPS) do
    if name:find(pattern, 1, true) or bundleID:find(pattern, 1, true) then
      spaceDisabled = true
      return
    end
  end
  spaceDisabled = false
end

appWatcher = hs.application.watcher.new(function(_, eventType)
  if eventType == hs.application.watcher.activated then
    refreshSpaceDisabled()
  end
end)
appWatcher:start()
refreshSpaceDisabled()

local function handleSpaceKey(isDown)
  if isDown then
    if spacePressedAt then
      return true -- オートリピートは捨てる
    end
    spacePressedAt = hs.timer.secondsSinceEpoch()
    spaceResolvedAsTap = false
    return true -- tap か hold か決まるまで送出を保留する
  end

  local heldFor = spacePressedAt and (hs.timer.secondsSinceEpoch() - spacePressedAt) or 0
  local alreadySent = spaceResolvedAsTap
  spacePressedAt = nil
  spaceResolvedAsTap = false

  -- 閾値未満で単独で離されたときだけスペースを出す。
  -- 閾値を超えていたら Cmd のつもりだったとみなして何も出さない。
  if not alreadySent and heldFor < SPACE_HOLD_THRESHOLD then
    postKeyTap({}, "space")
  end
  return true
end

spaceTap = hs.eventtap.new({ eventTypes.keyDown, eventTypes.keyUp }, function(event)
  if isSynthetic(event) then
    return false
  end

  local isDown = event:getType() == eventTypes.keyDown

  if event:getKeyCode() == hs.keycodes.map.space then
    if spaceDisabled then
      return false
    end
    return handleSpaceKey(isDown)
  end

  -- ここから先は space 以外のキー
  if not spacePressedAt or spaceResolvedAsTap then
    return false
  end

  if hs.timer.secondsSinceEpoch() - spacePressedAt < SPACE_HOLD_THRESHOLD then
    -- 高速タイピングでの押し重なり (例: "the cat" の空白と次の文字)。
    -- Cmd ではなく、スペース → そのキーの順に素直に流す。
    if isDown then
      spaceResolvedAsTap = true
      postKeyTap({}, "space")
    end
    return false
  end

  -- space を閾値以上押しっぱなし = Cmd 修飾として振る舞う
  local flags = event:getFlags()
  flags.cmd = true
  event:setFlags(flags)
  return false
end)
spaceTap:start()
