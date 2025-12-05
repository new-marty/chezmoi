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
    -- Check if ghostty is running
    set ghosttyIsRunning to (exists process "ghostty")
end tell

if ghosttyIsRunning then
    tell application "System Events"
        -- Get the name of the frontmost process
        set frontProcessName to name of first process whose frontmost is true
        
        -- Check if ghostty process is currently visible
        set ghosttyVisible to the visible of process "ghostty"
    end tell
    
    if frontProcessName is "ghostty" and ghosttyVisible is true then
        -- ghostty is frontmost and visible -> hide it
        tell application "System Events" to set visible of process "ghostty" to false
    else
        -- Otherwise (running but hidden or in background) -> activate it
        tell application "Ghostty" to activate
        -- For some apps, reopen may work better:
        -- tell application "Ghostty" to reopen
    end if
else
    -- ghostty is not running -> launch it
    tell application "Ghostty" to activate
end if
EOD
