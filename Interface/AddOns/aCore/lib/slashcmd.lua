
  -- // slashcmd functionality
  -- // zork - 2012

  -----------------------------
  -- GLOBAL FUNCTIONS
  -----------------------------

  --add some global functions

  local defaultColor = "00FFFFFF"

  --rCreateSlashCmdFunction func
  function rCreateSlashCmdFunction(addon, shortcut, dragFrameList, color)
    if not addon or not shortcut or not dragFrameList then return end
    local slashCmdFunction = function(cmd)
      if (cmd:match"unlock") then
        rUnlockAllFrames(dragFrameList, "Frames unlocked")
      elseif (cmd:match"lock") then
        rLockAllFrames(dragFrameList, "Frames locked")
      elseif (cmd:match"reset") then
        rResetAllFramesToDefault(dragFrameList, "Frames reseted")
      else
        print("|c"..(color or defaultColor).." Command List:|r")
        print("|c"..(color or defaultColor).."\/"..shortcut.." lock|r, to lock all frames")
        print("|c"..(color or defaultColor).."\/"..shortcut.." unlock|r, to unlock all frames")
        print("|c"..(color or defaultColor).."\/"..shortcut.." reset|r, to reset all frames")
      end
    end
    return slashCmdFunction
  end

