**Changes in 7.0.5:**

- _Val Voronov (1):_
    1. core: Update units of already handled nameplates (#391)
- 1 file changed, 2 insertions(+)

**Changes in 7.0.4:**

- _Adrian L Lange (1):_
    1. utils: Pandoc is extremely picky with the prefixed spacing on sublists (#388)
- _Val Voronov (1):_
    1. classpower: Unregister all events (#387)
- 2 files changed, 5 insertions(+), 1 deletion(-)

**Changes in 7.0.3:**

- _Adrian L Lange (1):_
    1. utils: Use ordrered lists for commit messages
- _Val Voronov (1):_
    1. core: Set nameplate CVars immediately if already logged in
- 2 files changed, 15 insertions(+), 2 deletions(-)

**Changes in 7.0.2:**

- _Adrian L Lange (1):_
    1. toc: CurseForge wants IDs, not slugs (#382)
- _Val Voronov (1):_
    1. Update README
- 2 files changed, 8 insertions(+), 4 deletions(-)

**Changes in 7.0.1:**

- _Adrian L Lange (1):_
    1. Update Interface version (#380)
- 1 file changed, 1 insertion(+), 1 deletion(-)

**Changes in 7.0.0:**

- _Adrian L Lange (20):_
    1. druidmana: Rename element to "AdditionalPower"
    2. totems: TotemFrame is parented to PlayerFrame
    3. additionalpower: Remove beta client compatibility code
    4. core: There are 5 arena and boss frames
    5. core: Make sure UpdateAllElements has an event
    6. classicons: Fake unit if player is in a vehicle
    7. aura: Update returns from UnitAura (#314)
    8. core: Expose header visibility (#329)
    9. tags: Update documentation
    10. classpower: Only show active bars (#363)
    11. Convert the changelog script to output markdown formatted logs
    12. Don't count merge commits as actual changes in the changelog
    13. Use a custom changelog generated before packaging
    14. Add automatic packaging with the help of TravisCI and BigWigs' packager script
    15. Put the changelog in the cloned directory
    16. Only let travis run on master
    17. Revert "Put the changelog in the cloned directory"
    18. Only let travis run on master
    19. Don't restrict builds away from tags
    20. We need to escape the regex pattern for travis config
- _Erik Raetz (1):_
    1. Use GetCreatureDifficultyColor and fallback level 999
- _Jakub Šoustar (2):_
    1. totems: Remove priorities
    2. totems: Use actual number of totem sub-widgets instead of MAX_TOTEMS
- _Phanx (1):_
    1. health: Ignore updates with nil unit (Blizz bug in 7.1) (#319)
- _Rainrider (29):_
    1. core:  update the pet frame properly after entering/exiting a vehicle
    2. power: Allow using atlases
    3. castbar: add a .holdTime option
    4. castbar: use SetColorTexture
    5. castbar: deprecate .interrupt in favor of .notInterruptible
    6. castbar: remove some unused variables
    7. castbar: rename object to self
    8. castbar: upvalue GetNetStats
    9. castbar: update interruptible flag in UNIT_SPELLCAST(_NOT)_INTERRUPTIBLE
    10. castbar: delegate hiding the castbar to the OnUpdate script
    11. castbar: set .Text for failed and interrupted casts accordingly
    12. castbar: pass the spellid to Post* hooks where applicable
    13. castbar: add .timeToHold option
    14. range: update documentation
    15. runes: update documentation
    16. stagger: update documentation
    17. totems: update documentation
    18. additionalpower: update documentation
    19. alternativepower: update documentation
    20. classpower: update documentation
    21. auras: update documentation
    22. castbar: update documentation
    23. tags: update documentation
    24. core: update documentation
    25. portrait: check for PlayerModel instead of Model
    26. range: minor cleanup
    27. raidroleindicator: make sure all update paths trigger Pre|PostUpdate
    28. masterlooterindicator: make sure all update paths trigger Pre|PostUpdate
    29. runes: update docs
- _Sticklord (1):_
    1. core: Change the framestrata to LOW
- _Val Voronov (19):_
    1. tags: Added 'powercolor' tag.
    2. runebar: Set cooldown start time to 0 if rune was energized (#310)
    3. healthprediction: Element update (#353)
    4. runes: Min value should be 0
    5. runes: Add colouring support
    6. additionalpower: Move colour update to its own function (#360)
    7. auras: Element update (#361)
    8. stagger: Move colour update to its own function (#359)
    9. runes: Add nil and 0 spec checks (#367)
    10. classpower: Element update (#368)
    11. core: oUF.xml cleanup (#369)
    12. alternativepower: Move Hide() call to a better spot
    13. health: Add Show() call to Enable function
    14. healthprediction: Remove redundant Show() calls
    15. portrait: Move Show() call to a better spot
    16. power: Add Show() call to Enable function
    17. stagger: Move Hide() call to a better spot
    18. threatindicator: Fix UnitThreatSituation error (#371)
    19. Add README (#373)
- 65 files changed, 5536 insertions(+), 4507 deletions(-)

**Changes in 1.6.9:**

- _Adrian L Lange (46):_
    1. core: Expose the headers
    2. tags: No need to match the same string twice
    3. castbar: Kill the pet casting bar if we spawn a player castbar
    4. runebar: Bail if GetRuneCooldown returns nil values
    5. cpoints: Use UNIT_POWER_FREQUENT instead of UNIT_COMBO_POINTS
    6. tags: Use UNIT_POWER_FREQUENT instead of UNIT_COMBO_POINTS for cpoints
    7. eclipsebar: Remove element
    8. stagger: Monk stances no longer exist
    9. stagger: The default MonkStaggerBar is parented to PlayerFrame, no need to hide it manually
    10. tags: Remove 'pereclipse' tag
    11. power: Update power colors and indices for Legion
    12. power: Handle power colors from nested tables, such as the stagger colors
    13. health: Fix tapping for Legion
    14. power: Fix tapping for Legion
    15. stagger: Color indices were exposed in Legion (build 21996)
    16. runebar: RuneFrame was parented to PlayerFrame in 5.3
    17. stagger: Add fallback indices for live clients
    18. readycheck: Use the animation system for handling fading
    19. readycheck: Add support for overriding the textures
    20. readycheck: Add PreUpdate/PostUpdate/PostUpdateFadeOut hooks
    21. druidmana: Add support for other classes in Legion
    22. classicons: Chi is only used for Windwalker monks
    23. classicons: Holy Power is only used for Retribution paladins
    24. classicons: Shadow Orbs no longer exist in Legion
    25. classicons: Soul Shards are class-wide in Legion
    26. classicons: Add Arcane Chages for Arcane Mages
    27. classicons: Add Combo Points for rogues and druids
    28. classicons: Use the colors provided by the color table for the textures
    29. classicons: Only update textures if the classicons are textures
    30. classicons: Add support for vehicle combo points
    31. classicons: Pass powerType through PostUpdate
    32. classicons: Add fallback texture color for vehicles
    33. classicons: Update when max power changes
    34. tags: Add Arcane Charges tag
    35. tags: Remove Shadow Orbs tag from Legion
    36. tags: Chi is only used for Windwalker monks in Legion
    37. tags: Soul Shards are class-wide in Legion
    38. tags: Update spec check for the holypower tag
    39. classicons: Remove pre-legion compatibility checks
    40. health: Remove pre-legion compatibility checks
    41. power: Remove pre-legion compatibility checks
    42. runebar: Runes were simplified in Legion, now there's only one type
    43. runebar: Add Override support and rename the PostUpdate hook
    44. runebar: Allow PostUpdate during vehicle updates
    45. classicons: Make sure we update for talent changes for druids
    46. druidmana: Add overrides for the display pairs table
- _Chris Bannister (1):_
    1. aura: Dont have oUF aura specific logic inside CreateIcon
- _Phanx (1):_
    1. aura: Update UnitAura return values
- _Rainrider (3):_
    1. runebar: account for energized runes
    2. runebar: deactivating OnUpdate is handled in Update
    3. runebar: let the layout define the max number of runes
- _Trond A Ekseth (5):_
    1. aura: Make the previous commit backwards compatible.
    2. aura: Add missing internal state update after second createAuraIcon call.
    3. totems: Update example to include cooldown template.
    4. Bump TOC interface version to 7.0 (70000).
    5. Bump TOC version to 1.6.9.
- _Val Voronov (16):_
    1. powerprediction: Add power cost prediction widget.
    2. prestige: Add prestige widget.
    3. powerprediction: Hide bars, when element is disabled.
    4. prestige: Remove prestige element.
    5. pvp: Element revamp.
    6. powerprediction: (Un)register 'UNIT_SPELLCAST_SUCCEEDED' event.
    7. druidmana: Fixed additional power bar update process.
    8. power: Alternative power colours use 0-255 range.
    9. power: Alternative power colours use 0-1 range too.
    10. power: Better condition.
    11. power: Even better condition.
    12. powerprediction: Legion clean-up.
    13. pvp: Legion clean-up.
    14. aura: Fixed issue which was causing /fstack error.
    15. power: Added a comment.
    16. aura: A better way of getting parent frame's name.
- _Valeriy Voronov (4):_
    1. altpowerbar: Use correct UnitAlternatePowerInfo() returns.
    2. altpowerbar: Set OnLeave script only if frame doesn't have one yet.
    3. stagger: Perform an actual update on forced update event.
    4. classicons: Actually update widgets on forced update.
- 19 files changed, 634 insertions(+), 583 deletions(-)

