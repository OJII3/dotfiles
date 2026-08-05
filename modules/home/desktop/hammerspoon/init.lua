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

local MODIFIER_NAMES = { "cmd", "alt", "shift", "ctrl", "fn" }

local function hasAnyModifier(flags)
  for _, name in ipairs(MODIFIER_NAMES) do
    if flags[name] then
      return true
    end
  end
  return false
end

local function newSyntheticKeyEvent(mods, key, isDown)
  local event = hs.eventtap.event.newKeyEvent(mods, key, isDown)
  event:setProperty(eventProps.eventSourceUserData, SYNTHETIC)
  return event
end

-- キーを1回叩いたことにする (down/up をまとめて合成する)
local function postKeyTap(mods, key)
  for _, isDown in ipairs({ true, false }) do
    newSyntheticKeyEvent(mods, key, isDown):post()
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
local spaceCmdEngaged = false -- Cmd を押し下げっぱなしにしているか
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

-- 修飾キーは「キーイベントに flag を混ぜる」のではなく、修飾キー自体を
-- 独立したイベントとして押し下げる。Apple のドキュメントが指定している方法で、
-- これをやらないと Cmd+C のようなショートカットが発火しない。
local function postCmd(isDown)
  -- 修飾キーは mods を省いた 2 引数形式で作る (ドキュメントの例と同じ形)
  local event = hs.eventtap.event.newKeyEvent(hs.keycodes.map.cmd, isDown)
  event:setProperty(eventProps.eventSourceUserData, SYNTHETIC)
  event:post()
end

local function releaseSpaceCmd()
  if spaceCmdEngaged then
    spaceCmdEngaged = false
    postCmd(false)
  end
end

-- リロード/終了時に Cmd を押しっぱなしのまま残さない
hs.shutdownCallback = releaseSpaceCmd

-- 閾値まで押し続けられたら本物の Cmd を押し下げる。以降のキーは一切加工せず
-- そのまま流すだけで、OS が自然に Cmd を効かせてくれる。
local spaceHoldTimer = hs.timer.delayed.new(SPACE_HOLD_THRESHOLD, function()
  if spacePressedAt and not spaceResolvedAsTap and not spaceCmdEngaged then
    spaceCmdEngaged = true
    postCmd(true)
  end
end)

local function handleSpaceKey(event, isDown)
  if isDown then
    -- Option+Space (Raycast) や Cmd+Space のように修飾キーと一緒に押された
    -- space はショートカットなので、tap-hold の対象にせずそのまま通す。
    if hasAnyModifier(event:getFlags()) then
      return false
    end
    if spacePressedAt then
      return true -- オートリピートは捨てる
    end
    spacePressedAt = hs.timer.secondsSinceEpoch()
    spaceResolvedAsTap = false
    spaceHoldTimer:start()
    return true -- tap か hold か決まるまで送出を保留する
  end

  -- 保留していない space の離しは素通しする (修飾キー付きで通したもの)
  if not spacePressedAt then
    return false
  end

  spaceHoldTimer:stop()
  local heldFor = hs.timer.secondsSinceEpoch() - spacePressedAt
  local alreadySent = spaceResolvedAsTap
  local wasCmd = spaceCmdEngaged
  spacePressedAt = nil
  spaceResolvedAsTap = false
  releaseSpaceCmd()

  -- Cmd として使ったあとはスペースを出さない。
  -- 閾値未満で単独で離されたときだけスペースを出す。
  if not wasCmd and not alreadySent and heldFor < SPACE_HOLD_THRESHOLD then
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
    return handleSpaceKey(event, isDown)
  end

  -- ここから先は space 以外のキー。
  -- Cmd 押し下げ済み、または space を押していないなら何もしない。
  if spaceCmdEngaged or not spacePressedAt or spaceResolvedAsTap then
    return false
  end

  -- Cmd がまだ入っていない = 閾値前。高速タイピングでの押し重なり
  -- (例: "the cat" の空白と次の文字) なので、スペース → そのキーの順に流す。
  if isDown then
    spaceHoldTimer:stop()
    spaceResolvedAsTap = true
    postKeyTap({}, "space")
  end
  return false
end)
spaceTap:start()
