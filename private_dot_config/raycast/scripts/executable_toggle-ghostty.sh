#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Ghostty
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 👻

# Documentation:
# @raycast.description Toggle Ghostty Terminal
# @raycast.author new-marty

osascript <<EOD
tell application "System Events"
    -- ghostty が起動中かどうか
    set ghosttyIsRunning to (exists process "ghostty")
end tell

if ghosttyIsRunning then
    tell application "System Events"
        -- 現在最前面のプロセス名を取得
        set frontProcessName to name of first process whose frontmost is true
        
        -- ghostty プロセスが「現在可視かどうか」も取得
        set ghosttyVisible to the visible of process "ghostty"
    end tell
    
    if frontProcessName is "ghostty" and ghosttyVisible is true then
        -- ghostty が最前面 かつ 可視 → 非表示
        tell application "System Events" to set visible of process "ghostty" to false
    else
        -- それ以外 (起動はしているが非表示 or 後ろに隠れている) → 再度アクティブ化
        tell application "Ghostty" to activate
        -- 場合によっては reopen のほうが効くアプリもある:
        -- tell application "Ghostty" to reopen
    end if
else
    -- ghostty が起動していない場合は起動
    tell application "Ghostty" to activate
end if
EOD
