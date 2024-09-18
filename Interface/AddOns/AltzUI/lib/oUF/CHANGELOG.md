**Changes in 12.0.1:**

- _Val Voronov (1):_
    1. range: Register updater
- 1 file changed, 1 insertion(+), 1 deletion(-)

**Changes in 12.0.0:**

- _Adrian L Lange (9):_
    1. colors: We like fallback values
    2. Update source comments
    3. classpower: Update docs to match implementation
    4. auras: Link directly to symbol
    5. colors: Use provided enum
    6. Point links to warcraft.wiki.gg
    7. Update README and links for Discussions ([#681](https://github.com/oUF-wow/oUF/issues/681))
    8. castbar: Add override for unit checks ([#677](https://github.com/oUF-wow/oUF/issues/677))
    9. castbar: Don't force using frames for pips ([#675](https://github.com/oUF-wow/oUF/issues/675))
- _Val Voronov (15):_
    1. healthprediction: Add showRawAbsorb option
    2. health: Update docs
    3. healthprediction: Add missing docs
    4. powerprediction: Add dynamic size adjustment
    5. core: Only update visible eventless frames
    6. healthprediction: Add dynamic size adjustment
    7. healthprediction: Remove dynamic size adjustment
    8. healthprediction: Use legit events
    9. health: Keep max hp reduction event registered
    10. powerprediction: Update API
    11. Make linter happy
    12. healthprediction: Add optional element size adjustment
    13. range: Use events to drive updates
    14. grouproleindicator: Update API
    15. health: Add temp max health loss sub-widget
- 23 files changed, 310 insertions(+), 134 deletions(-)

**Changes in 11.3.0:**

- _Adrian L Lange (1):_
    1. core: Use new ping template and add support for nameplates ([#670](https://github.com/oUF-wow/oUF/issues/670))
- _Val Voronov (6):_
    1. tags: Fix threatcolor tag ([#674](https://github.com/oUF-wow/oUF/issues/674))
    2. classpower: Use UPU ([#625](https://github.com/oUF-wow/oUF/issues/625))
    3. colors: Update color fetching ([#667](https://github.com/oUF-wow/oUF/issues/667))
    4. healthprediction: Remove unnecessary hack ([#669](https://github.com/oUF-wow/oUF/issues/669))
    5. auras: Update element ([#668](https://github.com/oUF-wow/oUF/issues/668))
    6. healthprediction: Fix unwanted statusbar behaviour ([#664](https://github.com/oUF-wow/oUF/issues/664))
- _dependabot[bot] (1):_
    1. build(deps): bump peter-evans/create-pull-request from 5 to 6 ([#672](https://github.com/oUF-wow/oUF/issues/672))
- _p3lim (1):_
    1. Update license
- 8 files changed, 32 insertions(+), 38 deletions(-)

**Changes in 11.2.3:**

- _Adrian L Lange (2):_
    1. Update Interface version ([#663](https://github.com/oUF-wow/oUF/issues/663))
    2. colors: Update stagger logic to upstream ([#660](https://github.com/oUF-wow/oUF/issues/660))
- 2 files changed, 13 insertions(+), 3 deletions(-)

**Changes in 11.2.2:**

- _Adrian L Lange (5):_
    1. core: Fix contextual ping on header children ([#661](https://github.com/oUF-wow/oUF/issues/661))
    2. core: Fix contextual ping on suffix units ([#659](https://github.com/oUF-wow/oUF/issues/659))
    3. Update Interface version ([#657](https://github.com/oUF-wow/oUF/issues/657))
    4. core: Support contextual pings ([#656](https://github.com/oUF-wow/oUF/issues/656))
    5. blizzard: Hide the new compact arena frames ([#653](https://github.com/oUF-wow/oUF/issues/653))
- _Val Voronov (6):_
    1. castbar: Improve empowered cast handling ([#654](https://github.com/oUF-wow/oUF/issues/654))
    2. readycheckindicator: Hardcode icon textures
    3. Update Interface version
    4. powerprediction: Update vars
    5. additionalpower: Update vars
    6. Make linter happy
- _dependabot[bot] (2):_
    1. build(deps): bump actions/checkout from 3 to 4 ([#658](https://github.com/oUF-wow/oUF/issues/658))
    2. build(deps): bump actions/checkout from 2 to 3
- 12 files changed, 97 insertions(+), 35 deletions(-)

**Changes in 11.2.1:**

- _Val Voronov (1):_
    1. core: Update API
- 2 files changed, 2 insertions(+), 2 deletions(-)

**Changes in 11.2.0:**

- _Adrian L Lange (2):_
    1. Add dependabot to help out
    2. Update Interface version
- _Val Voronov (8):_
    1. core: Clean up nameplate hooks
    2. core: Reparent soft target and widget containers
    3. tags: Adjust eventTimerThreshold ([#638](https://github.com/oUF-wow/oUF/issues/638))
    4. core: Fix nameplate code ([#637](https://github.com/oUF-wow/oUF/issues/637))
    5. tags: Update element ([#635](https://github.com/oUF-wow/oUF/issues/635))
    6. core: Update nameplate hook ([#636](https://github.com/oUF-wow/oUF/issues/636))
    7. auras: Take numTotal into account when adding gap ([#632](https://github.com/oUF-wow/oUF/issues/632))
    8. auras: Process subtables in proper order ([#634](https://github.com/oUF-wow/oUF/issues/634))
- _dependabot[bot] (2):_
    1. build(deps): bump p3lim/license-year-updater from 1 to 2
    2. build(deps): bump peter-evans/create-pull-request from 3 to 5
- _github-actions[bot] (1):_
    1. Update license ([#631](https://github.com/oUF-wow/oUF/issues/631))
- 8 files changed, 296 insertions(+), 232 deletions(-)

**Changes in 11.1.1:**

- _Adrian L Lange (1):_
    1. Update Interface version
- 1 file changed, 1 insertion(+), 1 deletion(-)

**Changes in 11.1.0:**

- _Adrian L Lange (2):_
    1. blizzard: Disable PlayerFrame.classPowerBar
    2. blizzard: Remove legacy code that is now causing problems
- _Val Voronov (8):_
    1. events: Remove unnecessary workaround ([#629](https://github.com/oUF-wow/oUF/issues/629))
    2. auras: Update element ([#624](https://github.com/oUF-wow/oUF/issues/624))
    3. blizzard: Better way of disabling unit frames ([#623](https://github.com/oUF-wow/oUF/issues/623))
    4. blizzard: Properly disable unit frames ([#619](https://github.com/oUF-wow/oUF/issues/619))
    5. castbar: Fix element disabling ([#618](https://github.com/oUF-wow/oUF/issues/618))
    6. blizzard: Properly disable unit frames ([#617](https://github.com/oUF-wow/oUF/issues/617))
    7. auras: Add isPlayerAura to data ([#616](https://github.com/oUF-wow/oUF/issues/616))
    8. classpower: All classes can have charged points ([#615](https://github.com/oUF-wow/oUF/issues/615))
- 6 files changed, 381 insertions(+), 282 deletions(-)

**Changes in 11.0.0:**

- _Adrian L Lange (19):_
    1. colors: Document CreateColor
    2. colors: Use pre-generated hex color
    3. colors: Use existing methods of ColorMixin
    4. auras: Linting fix
    5. castbar: Update docs
    6. auras: Update docs
    7. leaderindicator: Rename variable to be more descriptive
    8. auras: Linting pass
    9. auras: Rename Icon -> Button to be consistent
    10. Update Interface version
    11. castbar: Fix linting
    12. castbar: Fix error with empowered casts on nameplates
    13. castbar: Fix empowering holding "stage"
    14. castbar: Fix error in docs
    15. castbar: Fix error in pips updater
    16. castbar: Follow styleguide
    17. elements: StatusBar:GetStatusBarAtlas() method removed
    18. castbar: Fix linting
    19. castbar: Add untested/unfinished empowering stages
- _Rainrider (3):_
    1. elements: reference color components by index instead of name ([#605](https://github.com/oUF-wow/oUF/issues/605))
    2. core: use ColorMixin for colors ([#604](https://github.com/oUF-wow/oUF/issues/604))
    3. tags: look for args in the suffix only ([#602](https://github.com/oUF-wow/oUF/issues/602))
- _Val Voronov (18):_
    1. colors: Override Blizz SetRGBA
    2. blizzard: Update arena frame handling
    3. castbar: Update pip code
    4. auras: Update sub-element name capitalisation
    5. leaderindicator: Revamp element
    6. auras: Fix UpdateAuras flow
    7. castbar: Fix more errors
    8. core: Fix eventless object handling
    9. auras: Remove registration for clicks
    10. auras: Element revamp
    11. castbar: Add basic empowerment support
    12. castbar: Fix errors
    13. classpower: Add Evoker Essence support
    14. auras: SetText now only accepts strings and nil
    15. portrait: Update element ([#609](https://github.com/oUF-wow/oUF/issues/609))
    16. castbar: Use proper spell names ([#610](https://github.com/oUF-wow/oUF/issues/610))
    17. core: Run UAE on UEV ([#606](https://github.com/oUF-wow/oUF/issues/606))
    18. core: Rework how eventless units are handled ([#603](https://github.com/oUF-wow/oUF/issues/603))
- 20 files changed, 968 insertions(+), 464 deletions(-)

**Changes in 10.1.1:**

- _Adrian L Lange (5):_
    1. core: Delay arena prep if in combat ([#598](https://github.com/oUF-wow/oUF/issues/598))
    2. core: Check if event is unitless ([#599](https://github.com/oUF-wow/oUF/issues/599))
    3. Bump packager version ([#597](https://github.com/oUF-wow/oUF/issues/597))
    4. Update Interface version ([#596](https://github.com/oUF-wow/oUF/issues/596))
    5. Disable color output from luacheck ([#591](https://github.com/oUF-wow/oUF/issues/591))
- _Rainrider (1):_
    1. Add linting configuration ([#557](https://github.com/oUF-wow/oUF/issues/557))
- _Val Voronov (3):_
    1. core: Evaluate units on PEW ([#601](https://github.com/oUF-wow/oUF/issues/601))
    2. threatindicator: Fix docs
    3. tags: Use UnitEffectiveLevel instead of UnitLevel
- _github-actions[bot] (1):_
    1. Update license ([#595](https://github.com/oUF-wow/oUF/issues/595))
- 26 files changed, 276 insertions(+), 76 deletions(-)

**Changes in 10.1.0:**

- _Adrian L Lange (7):_
    1. Add workflow to automatically update license ([#588](https://github.com/oUF-wow/oUF/issues/588))
    2. Update LICENSE ([#587](https://github.com/oUF-wow/oUF/issues/587))
    3. Update packager version ([#586](https://github.com/oUF-wow/oUF/issues/586))
    4. Update Interface version ([#569](https://github.com/oUF-wow/oUF/issues/569))
    5. tags: Fix typo ([#567](https://github.com/oUF-wow/oUF/issues/567))
    6. tags: Untag fontstrings correctly ([#566](https://github.com/oUF-wow/oUF/issues/566))
    7. Add issue templates ([#558](https://github.com/oUF-wow/oUF/issues/558))
- _Rainrider (3):_
    1. core: add a combat log event system
    2. core: make element's update optional
    3. core: signify all AddElement args as mandatory
- _Thatmemedk (1):_
    1. auras: Allow separate width and height of icons ([#582](https://github.com/oUF-wow/oUF/issues/582))
- _Val Voronov (15):_
    1. tags: Streamline code
    2. tags: Leave invalid tags in as text
    3. Add Private.nierror method
    4. classpower: Fix chargedPoints unpacking
    5. Update Interface version
    6. classpower: Add support for multiple charged power points
    7. tags: Add missing unitless event
    8. tags: Remove unnecessary escapes
    9. tags: Fix suffix extraction
    10. auras: Bail out if GameTooltip is forbidden
    11. auras: Update workaround for restricted frames
    12. classpower: Hardcode powerType for UPPC
    13. Replace wrapped register*Event with validateEvent
    14. Add validateEvent method
    15. Wrap event registration to check event validity ([#563](https://github.com/oUF-wow/oUF/issues/563))
- 15 files changed, 301 insertions(+), 99 deletions(-)

**Changes in 10.0.3:**

- _Rainrider (1):_
    1. alternativepower: remove the realUnit check from the visibility condition
- _Val Voronov (5):_
    1. phaseindicator: Check phase only for player units
    2. powerprediction: Avoid resetting while casting
    3. powerprediction: Make it player-only
    4. powerprediction: Add support for mutating spells
    5. phaseindicator: Pass phaseReason to PostUpdate
- 3 files changed, 46 insertions(+), 34 deletions(-)

**Changes in 10.0.2:**

- _Adrian L Lange (2):_
    1. Replace Travis with GitHub Actions ([#532](https://github.com/oUF-wow/oUF/issues/532))
    2. Update README
- _Rainrider (1):_
    1. stagger: hide the element in Enable
- 4 files changed, 40 insertions(+), 30 deletions(-)

**Changes in 10.0.1:**

- _Adrian L Lange (1):_
    1. Update Interface version
- _Val Voronov (2):_
    1. tags: Update powercolor tag
    2. power: Fix colouring by power type logic
- 3 files changed, 10 insertions(+), 7 deletions(-)

**Changes in 10.0.0:**

- _Adrian L Lange (3):_
    1. Update LICENSE
    2. Bump Interface version
    3. tags: Make the suffix symmetric with the prefix
- _Rainrider (11):_
    1. additionalpower: fix documentation
    2. classpower: allow layouts to handle charged combo points ([#540](https://github.com/oUF-wow/oUF/issues/540))
    3. stagger: Add missing unit
    4. Update the docs
    5. alternativepower: replace deprecated UnitAlternatePowerInfo ([#537](https://github.com/oUF-wow/oUF/issues/537))
    6. runes: fix for death knights without specialization in Shadowlands ([#539](https://github.com/oUF-wow/oUF/issues/539))
    7. classpower: make holy power available in all specs
    8. classpower: expose the element's visibility through a PostVisibility callback ([#534](https://github.com/oUF-wow/oUF/issues/534))
    9. phaseindicator: Add tooltip support ([#529](https://github.com/oUF-wow/oUF/issues/529))
    10. pvpclassificationindicator: update enum casing
    11. castbar: Update safezone position according to the castbar orientation ([#527](https://github.com/oUF-wow/oUF/issues/527))
- _Val Voronov (39):_
    1. power: Don't cache unit's connection status
    2. health: Don't cache unit's connection status
    3. Update docs
    4. runes: Use AllPath for forced internal updates
    5. power: Add GetDisplayPower overridable method
    6. Check for atlases before setting our textures
    7. classpower: Add PostUpdateColor callback
    8. runes: Use ForceUpdate for forced internal updates
    9. Fix trailing ands and ors
    10. Remove useAtlas option
    11. additionalpower: Remove unit from Posts
    12. power: Pass atlas to PostUpdateColor
    13. stagger: Enabled stagger only for player
    14. alternativepower: Move colouring to its own method
    15. additionalpower: Update visibility handler
    16. additionalpower: Move colouring to its own method
    17. power: Move colouring to its own method
    18. Add alternative power to oUF.colors
    19. health: Move colouring to its own method
    20. runes: Move colouring to its own method
    21. stagger: Move colouring to its own method
    22. threat: Add threat colours to the oUF.colors table
    23. Remove UNIT_HEALTH_FREQUENT event ([#517](https://github.com/oUF-wow/oUF/issues/517))
    24. castbar: Element revamp ([#480](https://github.com/oUF-wow/oUF/issues/480))
    25. tags: Update docs
    26. tags: Pass additional args only if there's any
    27. tags: Remove 1/2/3 static cases
    28. tags: Fix ifs
    29. tags: Remove an option to adjust output length
    30. tags: Add UTF-8 support to string shortening
    31. tags: Use ' instead of "
    32. tags: Escape magic chars in tag names
    33. tags: Pass custom arguments to tag functions
    34. tags: Avoid unnecessary string operations
    35. tags: Bail out on empty strings
    36. tags: Fix tag function constructors
    37. tags: Update tag syntax
    38. tags: Fix getTagName method
    39. core: Add oUF:GetActiveStyle() method
- _Wetxius (1):_
    1. castbar: Add fallback icon ([#519](https://github.com/oUF-wow/oUF/issues/519))
- 18 files changed, 1162 insertions(+), 818 deletions(-)

**Changes in 9.3.1:**

- _Val Voronov (2):_
    1. auras: Add comments regarding anchoring restrictions
    2. auras: Fix copypasta
- 1 file changed, 10 insertions(+), 1 deletion(-)

**Changes in 9.3.0:**

- _Val Voronov (1):_
    1. auras: Add .tooltipAnchor option ([#511](https://github.com/oUF-wow/oUF/issues/511))
- 1 file changed, 21 insertions(+), 1 deletion(-)

**Changes in 9.2.2:**

- _Val Voronov (1):_
    1. blizzard: Do not hook nameplates' scripts more than once ([#508](https://github.com/oUF-wow/oUF/issues/508))
- 1 file changed, 4 insertions(+), 1 deletion(-)

**Changes in 9.2.1:**

- _Adrian L Lange (1):_
    1. Use upstream version of the packager
- _Val Voronov (2):_
    1. Bump TOC for 8.2 ([#507](https://github.com/oUF-wow/oUF/issues/507))
    2. blizzard: Do not re-parent nameplates ([#506](https://github.com/oUF-wow/oUF/issues/506))
- 3 files changed, 13 insertions(+), 6 deletions(-)

**Changes in 9.2.0:**

- _Val Voronov (1):_
    1. tags: Update the system ([#501](https://github.com/oUF-wow/oUF/issues/501))
- 1 file changed, 151 insertions(+), 102 deletions(-)

**Changes in 9.1.3:**

- _Rainrider (1):_
    1. stagger: fix visibility toggling
- 1 file changed, 2 insertions(+)

**Changes in 9.1.2:**

- _Rainrider (1):_
    1. core: handle pass-through events for eventless frames as unitless
- _Val Voronov (5):_
    1. Renamed Private.UnitSelectionType to Private.unitSelectionType
    2. Renamed Private.UnitExists to Private.unitExists
    3. runes: Updated docs ([#494](https://github.com/oUF-wow/oUF/issues/494))
    4. powerprediction: Use next instead of pairs
    5. powerprediction: Fixed a typo
- 10 files changed, 26 insertions(+), 26 deletions(-)

**Changes in 9.1.1:**

- _Rainrider (1):_
    1. elements: do not toggle visibility on enable in elements where it is part of the update process
- _Val Voronov (2):_
    1. core: Prevent multiple instances of the nameplate driver ([#492](https://github.com/oUF-wow/oUF/issues/492))
    2. core: Greatly reduced the number of UAE calls for the nameplates ([#491](https://github.com/oUF-wow/oUF/issues/491))
- 4 files changed, 19 insertions(+), 15 deletions(-)

**Changes in 9.1.0:**

- _Val Voronov (5):_
    1. core: Use _initialAttribute-* to set attributes
    2. Add .colorSelection option to health and power elements ([#484](https://github.com/oUF-wow/oUF/issues/484))
    3. threatindicator: Use a better default texture ([#486](https://github.com/oUF-wow/oUF/issues/486))
    4. pvpclassificationindicator: Add the element ([#482](https://github.com/oUF-wow/oUF/issues/482))
    5. core: Update the event system ([#483](https://github.com/oUF-wow/oUF/issues/483))
- 9 files changed, 287 insertions(+), 39 deletions(-)

**Changes in 9.0.2:**

- _Rainrider (3):_
    1. core: unregister the event when unit validation fails
    2. core: do not use table.remove as it alters the index which also breaks the loop in the __call meta method
    3. core: keep the event table even with one handler left
- 2 files changed, 12 insertions(+), 17 deletions(-)

**Changes in 9.0.1:**

- _Rainrider (1):_
    1. Update toc interface and a happy new year everyone
- 2 files changed, 5 insertions(+), 5 deletions(-)

**Changes in 9.0.0:**

- _Adrian L Lange (17):_
    1. core: Add a flag to toggle arena prep support, defaulting to enabled
    2. tags: Don't attempt to update tags if there's none on the frame
    3. units: Disable .colorPower option until a solution presents itself
    4. units: Remove dependency on original overrides for arena prep
    5. core: Add callbacks to arena prep and adjust docs accordingly
    6. core: Add documentation for PreUpdate and PostUpdate
    7. units: Move arena-specific code to the other unit-specific file
    8. arena: Add support for the UpdateColor override on Health and Power
    9. tags: Add 'arenaspec' tag
    10. tags: Add support for arena preperation in the 'raidcolor' tag
    11. arena: Add callbacks to the health/power element pseudo updating
    12. arena: Don't try to apply pseudo values to overridden elements
    13. arena: Hide the fake frame if the opponent leaves
    14. arena: Update all elements with pseudo values to appear as normal
    15. core: Add basic support for arena preperation frames
    16. tags: Add UpdateTags method
    17. additionalpower: Add option to override the display pairs table ([#450](https://github.com/oUF-wow/oUF/issues/450))
- _Rainrider (10):_
    1. core: re-work the event system ([#472](https://github.com/oUF-wow/oUF/issues/472))
    2. readycheckindicator: fix the match pattern
    3. readycheckindicator: prevent enabling the element on party and raid pets
    4. tags: fix missing end
    5. tags: sort the tag functions
    6. tags: update 'cpoints'
    7. tags: tune the 'difficulty' tag a bit
    8. tags: use PLAYER_TALENT_UPDATE for class power resources
    9. tags: add events for 'faction' and 'deficit:name'
    10. colors: fix non-existent self in HCYColorGradient ([#466](https://github.com/oUF-wow/oUF/issues/466))
- _Sean Baildon (1):_
    1. auras: Display count text above cooldown spiral ([#451](https://github.com/oUF-wow/oUF/issues/451))
- _Val Voronov (25):_
    1. Add SetFrequentUpdates method to health and power elements ([#476](https://github.com/oUF-wow/oUF/issues/476))
    2. Add SummonIndicator element ([#471](https://github.com/oUF-wow/oUF/issues/471))
    3. classpower: Use UnitPower* APIs for vehicles ([#464](https://github.com/oUF-wow/oUF/issues/464))
    4. core: Update oUF-enableArenaPrep docs
    5. tags: Don't attempt to unregister tags if there's none on the frame
    6. core: Remove remaining old vehicle hack code ([#463](https://github.com/oUF-wow/oUF/issues/463))
    7. core: Remove UpdateAllElements call from DisableElement ([#462](https://github.com/oUF-wow/oUF/issues/462))
    8. pvpindicator: Default factionGroup to 'Neutral' ([#461](https://github.com/oUF-wow/oUF/issues/461))
    9. Use custom UnitExists method ([#460](https://github.com/oUF-wow/oUF/issues/460))
    10. core: Fix elements' updates for non interactive boss units ([#459](https://github.com/oUF-wow/oUF/issues/459))
    11. phaseindicator: Show the indicator only for online players ([#454](https://github.com/oUF-wow/oUF/issues/454))
    12. tags: Add [runes] tag ([#453](https://github.com/oUF-wow/oUF/issues/453))
    13. core: Nameplate code refactoring
    14. core: Update nameplate docs
    15. core: Call the callback on PLAYER_TARGET_CHANGED if there's no nameplate
    16. additionalpower: Update unit checks
    17. classpower: Remove unnecessary unit checks
    18. classpower: Update unit checks
    19. additionalpower: Update unit checks
    20. alternativepower: Update unit checks
    21. classpower: Update unit checks
    22. combatindicator: Update unit checks
    23. power: Remove unnecessary unit checks
    24. restingindicator: Update unit checks
    25. runes: Update unit checks
- 27 files changed, 744 insertions(+), 360 deletions(-)

**Changes in 8.0.2:**

- _Val Voronov (1):_
    1. phaseindicator: Fix logic ([#446](https://github.com/oUF-wow/oUF/issues/446))
- 1 file changed, 1 insertion(+), 1 deletion(-)

**Changes in 8.0.1:**

- _Val Voronov (1):_
    1. phaseindicator: Add war mode support
- 1 file changed, 1 insertion(+), 1 deletion(-)

**Changes in 8.0.0:**

- _Adrian L Lange (5):_
    1. tags: Add extra units support
    2. core: Further enforce global uniqueness
    3. core: Add a fallback to global for PetBattleFrameHider
    4. portrait: Add new event for updates
    5. core: Declare PetBattleFrameHider in Lua
- _Rainrider (22):_
    1. ToC bump for 8.0
    2. castbar: fix documentation copy/pasta
    3. castbar: make the spellID an attribute and remove it from the list of PostUpdate arguments
    4. castbar: document the element attributes meant for external use
    5. castbar: don't pass the castID to PostUpdate
    6. castbar: remove the cast name PostUpdate argument for *_STOP, *_FAILED and *_INTERRUPTED
    7. core: fix header names generation ([#422](https://github.com/oUF-wow/oUF/issues/422))
    8. power: use Enum.PowerType.Alternate instead of the global constant
    9. alternativepower: use Enum.PowerType.Alternate instead of the global constant
    10. tags: fix typo
    11. runes: fix documentation typo
    12. tags: update SPELL_POWER_* constants
    13. classpower: update SPELL_POWER_* constants
    14. castbar: remove rank returns from UnitCastingInfo and UnitChannelInfo
    15. castbar: update for changed signature of UNIT_SPELLCAST_* events
    16. powerprediction: UnitCastingInfo does not return spell ranks anymore
    17. auras: UnitAura does not return spell ranks anymore
    18. tags: UNIT_POWER is now named UNIT_POWER_UPDATE
    19. power: UNIT_POWER is now named UNIT_POWER_UPDATE
    20. alternativepower: UNIT_POWER is now named UNIT_POWER_UPDATE
    21. stagger: take one more stock UI event into account
    22. stagger: fix wrong event name and re-register stock UI events on disable
- _Val Voronov (11):_
    1. core: Proper vehicle fix
    2. pvpindicator: Fix .Badge visibility logic
    3. pvpindicator: Hide .Badge on disable
    4. pvpindicator: Add honour level icon support
    5. runes: Change var name
    6. runes: Avoid unnecessary sorts if sorting isn't active
    7. runes: Add sorting
    8. auras: Remove aura count nil check
    9. pvpindicator: Remove prestige
    10. masterlooterindicator: Remove element
    11. auras: Add aura count nil check
- 15 files changed, 257 insertions(+), 416 deletions(-)

**Changes in 7.0.16:**

- _Rainrider (1):_
    1. masterlooterindicator: fix for eventual nil masterlooter
- _jukx (1):_
    1. Update wowprogramming.com links in documentation
- 9 files changed, 13 insertions(+), 15 deletions(-)

**Changes in 7.0.15:**

- _Val Voronov (3):_
    1. Update interface version ([#429](https://github.com/oUF-wow/oUF/issues/429))
    2. Update LICENSE ([#428](https://github.com/oUF-wow/oUF/issues/428))
    3. core: Add frame:IsEnabled() method ([#427](https://github.com/oUF-wow/oUF/issues/427))
- 3 files changed, 11 insertions(+), 5 deletions(-)

**Changes in 7.0.14:**

- _Adrian L Lange (1):_
    1. changelog: Fix link markup ([#416](https://github.com/oUF-wow/oUF/issues/416))
- _Rainrider (4):_
    1. changelog: show newest commits on top
    2. auras: use oUF's colors table for debuff types
    3. colors: add debuff to the colors table
    4. auras: Add more arguments to PostUpdateIcon ([#418](https://github.com/oUF-wow/oUF/issues/418))
- _Val Voronov (1):_
    1. core: Update raid vehicle handling hack ([#424](https://github.com/oUF-wow/oUF/issues/424))
- 4 files changed, 38 insertions(+), 23 deletions(-)

**Changes in 7.0.13:**

- _Adrian L Lange (1):_
    1. changelog: Add links to issues mentioned in commit messages ([#414](https://github.com/oUF-wow/oUF/issues/414))
- _Rainrider (1):_
    1. core: update arena frames on ARENA_OPPONENT_UPDATE
- _Val Voronov (1):_
    1. healthprediction: Maths update
- 3 files changed, 26 insertions(+), 24 deletions(-)

**Changes in 7.0.12:**

- _Adrian L Lange (1):_
    1. castbar: Account for orientation and reverse fill for Spark repositioning ([#408](https://github.com/oUF-wow/oUF/issues/408))
- 1 file changed, 19 insertions(+), 2 deletions(-)

**Changes in 7.0.11:**

- _Val Voronov (1):_
    1. core: Disable raid frames vehicle handling in Antorus raid ([#404](https://github.com/oUF-wow/oUF/issues/404))
- 1 file changed, 70 insertions(+), 3 deletions(-)

**Changes in 7.0.10:**

- _Adrian L Lange (1):_
    1. core: Let the packager set a static version ([#401](https://github.com/oUF-wow/oUF/issues/401))
- 1 file changed, 1 insertion(+), 1 deletion(-)

**Changes in 7.0.9:**

- _Val Voronov (1):_
    1. portrait: Use both UNIT_PORTRAIT_UPDATE and UNIT_MODEL_CHANGED ([#400](https://github.com/oUF-wow/oUF/issues/400))
- 2 files changed, 5 insertions(+), 2 deletions(-)

**Changes in 7.0.8:**

- _Val Voronov (1):_
    1. portrait: Fix updates for *target units ([#399](https://github.com/oUF-wow/oUF/issues/399))
- 2 files changed, 26 insertions(+), 23 deletions(-)

**Changes in 7.0.7:**

- _Adrian L Lange (1):_
    1. Update README ([#397](https://github.com/oUF-wow/oUF/issues/397))
- _Rainrider (1):_
    1. core: update the frame units upon UNIT_EXITING_VEHICLE
- 2 files changed, 16 insertions(+), 8 deletions(-)

**Changes in 7.0.6:**

- _Belzaru (3):_
    1. Remove unnecessary Show.
    2. Remove unnecessary code and rename variable.
    3. Change units and percent calculation to be relative to maximum cast duration.
- _Rainrider (2):_
    1. stagger: add a nil check for UnitStagger ([#392](https://github.com/oUF-wow/oUF/issues/392))
    2. threatindicator: asure the element has SetVertexColor before using it
- 3 files changed, 12 insertions(+), 14 deletions(-)

**Changes in 7.0.5:**

- _Val Voronov (1):_
    1. core: Update units of already handled nameplates ([#391](https://github.com/oUF-wow/oUF/issues/391))
- 1 file changed, 2 insertions(+)

**Changes in 7.0.4:**

- _Adrian L Lange (1):_
    1. utils: Pandoc is extremely picky with the prefixed spacing on sublists ([#388](https://github.com/oUF-wow/oUF/issues/388))
- _Val Voronov (1):_
    1. classpower: Unregister all events ([#387](https://github.com/oUF-wow/oUF/issues/387))
- 2 files changed, 5 insertions(+), 1 deletion(-)

**Changes in 7.0.3:**

- _Adrian L Lange (1):_
    1. utils: Use ordrered lists for commit messages
- _Val Voronov (1):_
    1. core: Set nameplate CVars immediately if already logged in
- 2 files changed, 15 insertions(+), 2 deletions(-)

**Changes in 7.0.2:**

- _Adrian L Lange (1):_
    1. toc: CurseForge wants IDs, not slugs ([#382](https://github.com/oUF-wow/oUF/issues/382))
- _Val Voronov (1):_
    1. Update README
- 2 files changed, 8 insertions(+), 4 deletions(-)

**Changes in 7.0.1:**

- _Adrian L Lange (1):_
    1. Update Interface version ([#380](https://github.com/oUF-wow/oUF/issues/380))
- 1 file changed, 1 insertion(+), 1 deletion(-)

**Changes in 7.0.0:**

- _Adrian L Lange (169):_
    1. We need to escape the regex pattern for travis config
    2. Don't restrict builds away from tags
    3. Only let travis run on master
    4. Revert "Put the changelog in the cloned directory"
    5. Only let travis run on master
    6. Put the changelog in the cloned directory
    7. Add automatic packaging with the help of TravisCI and BigWigs' packager script
    8. Use a custom changelog generated before packaging
    9. Don't count merge commits as actual changes in the changelog
    10. Convert the changelog script to output markdown formatted logs
    11. classpower: Only show active bars ([#363](https://github.com/oUF-wow/oUF/issues/363))
    12. tags: Update documentation
    13. range: Make sure we actually have and send the correct object
    14. core: Add documentation for oUF header attributes
    15. totems: Update Override documentation
    16. threatindicator: Update Override documentation
    17. stagger: Update Override documentation
    18. runes: Update Override documentation
    19. resurrectindicator: Update Override documentation
    20. restingindicator: Update Override documentation
    21. readycheckindicator: Update Override documentation
    22. range: Update Override documentation
    23. raidtargetindicator: Update Override documentation
    24. raidroleindicator: Update Override documentation
    25. questindicator: Update Override documentation
    26. pvpindicator: Update Override documentation
    27. powerprediction: Update Override documentation
    28. power: Update Override documentation
    29. portrait: Update Override documentation
    30. phaseindicator: Update Override documentation
    31. masterlooterindicator: Update Override documentation
    32. leaderindicator: Update Override documentation
    33. healthprediction: Update Override documentation
    34. health: Update Override documentation
    35. grouproleindicator: Update Override documentation
    36. combatindicator: Update Override documentation
    37. classpower: Update Override documentation
    38. assistantindicator: Update Override documentation
    39. alternativepower: Update Override documentation
    40. additionalpower: Update Override documentation
    41. core: Further documentation updates for oUF:SpawnNamePlates
    42. core: Update oUF:SpawnNamePlates documentation
    43. core: Fix visibility documentation
    44. blizzard: Use already defined constants (with fallbacks)
    45. totems: Fix Path documentation
    46. threatindicator: Fix Path documentation
    47. stagger: Fix Path documentation
    48. runes: Fix Path documentation
    49. resurrectindicator: Fix Path documentation
    50. restingindicator: Fix Path documentation
    51. readycheckindicator: Fix Path documentation
    52. raidtargetindicator: Fix Path documentation and a space
    53. raidroleindicator: Fix Path documentation
    54. questindicator: Fix Path documentation
    55. pvpindicator: Fix Path documentation
    56. powerprediction: Fix Path documentation
    57. power: Fix Path documentation
    58. portrait: Fix Path documentation
    59. phaseindicator: Fix Path documentation
    60. masterlooterindicator: Fix Path documentation
    61. leaderindicator: Fix Path documentation
    62. healthprediction: Fix Path documentation
    63. health: Fix Path documentation
    64. grouproleindicator: Fix Path documentation
    65. combatindicator: Fix Path documentation
    66. classpower: Fix Path documentation
    67. assistantindicator: Fix Path documentation
    68. alternativepower: Fix Path documentation
    69. additionalpower: Fix Path documentation
    70. range: Add proper Overrides and ForceUpdate
    71. core: Update oUF:SpawnHeader docs
    72. power: Fix documentation and UpdateColor params
    73. health: Fix documentation
    74. health: Separate the color updating to its own, overridable method
    75. power: Separate the color updating to its own, overridable method
    76. resurrectindicator: INCOMING_RESURRECT_CHANGED is not unitless
    77. threatindicator: Update docs
    78. stagger: Update docs
    79. runes: Update docs
    80. resurrectindicator: Update docs
    81. restingindicator: Update docs
    82. readycheckindicator: Update docs
    83. range: Update docs
    84. raidtargetindicator: Update docs
    85. raidroleindicator: Update docs
    86. questindicator: Update docs
    87. pvpindicator: Update docs
    88. powerprediction
    89. power: Update docs
    90. portrait: Update docs
    91. phaseindicator: Update docs
    92. masterlooterindicator: Update docs
    93. leaderindicator: Update docs
    94. healthprediction: Update docs
    95. health: Update docs
    96. grouproleindicator: Update docs
    97. combatindicator: Update docs
    98. classpower: Update docs
    99. castbar: Update docs
    100. auras: Update docs
    101. assistantindicator: Update docs
    102. alternativepower: Update docs
    103. additionalpower: Update docs
    104. totems: Update override docs
    105. threatindicator: Update override docs
    106. stagger: Update override and PostUpdate docs
    107. runes: Update override docs
    108. resurrectindicator: Update override docs
    109. restingindicator: Update override docs
    110. readycheckindicator: Update override docs
    111. raidtargetindicator: Update override docs
    112. raidroleindicator: Update override docs
    113. questindicator: Update override docs
    114. pvpindicator: Update override docs
    115. powerprediction: Update override docs
    116. power: Update override docs
    117. portrait: Update override docs
    118. phaseindicator: Update override docs
    119. masterlooterindicator: Update override docs
    120. leaderindicator: Update override docs
    121. healthprediction: Update override docs
    122. health: Update override docs
    123. grouproleindicator: Update override docs
    124. combatindicator: Update override docs
    125. classpower: Update override docs
    126. assistantindicator: Update override docs
    127. alternativepower: Update override docs
    128. additionalpower: Update override docs
    129. combatindicator: Fix typo in docs
    130. power: Remove unneccesary newline
    131. health: Fix comment
    132. Update TOC metadata
    133. Add CurseForge packager support
    134. threatindicator: Register necessary events for nameplates support ([#344](https://github.com/oUF-wow/oUF/issues/344))
    135. Update LICENSE ([#342](https://github.com/oUF-wow/oUF/issues/342))
    136. portraits: Misc changes ([#338](https://github.com/oUF-wow/oUF/issues/338))
    137. power: Reorder PostUpdate args ([#339](https://github.com/oUF-wow/oUF/issues/339))
    138. core: Expose header visibility ([#329](https://github.com/oUF-wow/oUF/issues/329))
    139. classpower: Denote that this comment represents a bug with the API
    140. auras: Remove backwards compatibility code for layouts overriding internal behaviors
    141. auras: Rename the visible offset to something sane
    142. threat: Rename to ThreatIndicator
    143. runebar: Rename file to Runes
    144. ricons: Rename to RaidTargetIndicator
    145. resurrect: Rename to ResurrectIndicator
    146. resting: Rename to RestingIndicator
    147. readycheck: Rename to ReadyCheckIndicator
    148. raidrole: Rename to RaidRoleIndicator
    149. qicon: Rename to QuestIndicator
    150. pvp: Rename to PvPIndicator
    151. picon: Rename to PhaseIndicator
    152. masterlooter: Rename to MasterLooterIndicator
    153. lfdrole: Rename to GroupRoleIndicator
    154. leader: Rename to LeaderIndicator
    155. healprediction: Rename to HealthPrediction
    156. combat: Rename to CombatIndicator
    157. aura: Rename file to auras
    158. classicons: Rename to ClassPower
    159. assistant: Rename to AssistantIndicator
    160. altpowerbar: Rename to AlternativePower
    161. cpoints: Remove element
    162. Linting
    163. aura: Update returns from UnitAura ([#314](https://github.com/oUF-wow/oUF/issues/314))
    164. classicons: Fake unit if player is in a vehicle
    165. core: Make sure UpdateAllElements has an event
    166. core: There are 5 arena and boss frames
    167. additionalpower: Remove beta client compatibility code
    168. totems: TotemFrame is parented to PlayerFrame
    169. druidmana: Rename element to "AdditionalPower"
- _Erik Raetz (1):_
    1. Use GetCreatureDifficultyColor and fallback level 999
- _Gethe (1):_
    1. Add support for reverse fill statusbars
- _Jakub Šoustar (2):_
    1. totems: Use actual number of totem sub-widgets instead of MAX_TOTEMS
    2. totems: Remove priorities
- _Phanx (1):_
    1. health: Ignore updates with nil unit (Blizz bug in 7.1) ([#319](https://github.com/oUF-wow/oUF/issues/319))
- _Rainrider (112):_
    1. runes: update docs
    2. masterlooterindicator: make sure all update paths trigger Pre|PostUpdate
    3. raidroleindicator: make sure all update paths trigger Pre|PostUpdate
    4. range: minor cleanup
    5. portrait: check for PlayerModel instead of Model
    6. core: update documentation
    7. tags: update documentation
    8. castbar: update documentation
    9. auras: update documentation
    10. classpower: update documentation
    11. alternativepower: update documentation
    12. additionalpower: update documentation
    13. totems: update documentation
    14. stagger: update documentation
    15. runes: update documentation
    16. range: update documentation
    17. powerprediction: update documentation
    18. power: update documentation
    19. portrait: update documentation
    20. healprediction: update documentation
    21. health: update documentation
    22. masterlooterindicator: remove unneeded IsShown() calls
    23. pvpindicator: remove unneeded hasPrestige
    24. range: set default alpha values
    25. readycheckindicator: set default textures in Enable
    26. threatindicator: update documentation
    27. resurrectindicator: update documentation
    28. restingindicator: update documentation
    29. readycheckindicator: update documentation
    30. range: update documentation
    31. raidtargetindicator: update documentation
    32. raidroleindicator: update documentation
    33. questindicator: update documentation
    34. pvpindicator: update documentation
    35. phaseindicator: update documentation
    36. masterlooterindicator: update documentation
    37. leaderindicator: update documentation
    38. grouproleindicator: update documentation
    39. combarindicator: update documentation
    40. castbar: update documentation
    41. assistantindicator: update documentation
    42. alternativepower: update documentation
    43. additionalpower: update documentation
    44. Remove unused parent variable
    45. Pass on constant upvalues
    46. Adhere to code style guidelines
    47. tags: adhere to code style guidelines
    48. docs: tags
    49. docs: address nameplates feedback
    50. docs: colors.lua
    51. docs: yep
    52. docs: add nameplates documentation
    53. docs: Address feedback on ouf.lua
    54. docs: ouf.lua
    55. Gimme some brackets
    56. docs: factory.lua
    57. docs: events.lua
    58. alternativepower: fix Update when called from Visibility on hide
    59. alternativepower: add a Path call in Visibility on hide
    60. healthprediction: more thorough documentation on .maxOverflow
    61. healthprediction: hide over(Heal)Absorb on disable
    62. auras: hide on disable
    63. alternativepower: apply the default statusbar texture if needed
    64. alternativepower: remove the .colorTexture option
    65. alternativepower: fix the visibility and update path
    66. range: fix Range.Override documentation
    67. healthprediction: pass the amount of overheal to :PostUpdate
    68. healthprediction: handle textures for over-absorb and overheal-absorb
    69. castbar: remove deprecated element.interrupt
    70. healthprediction: provide a saner example
    71. docs: some small fixes for consistency
    72. totems: update the documentation
    73. threatindicator: update the documentation
    74. stagger: update the documentation
    75. runes: update the documentation
    76. resurrectionindicator: update the documentation
    77. restingindicator: update the documentation
    78. readycheckindicator: update the documentation
    79. range: update the documentation
    80. raidtargetindicator: update the documentation
    81. raidroleindicator: update the documentation
    82. questindicator: update the documentation
    83. pvpindicator: update the documentation
    84. powerprediction: update the documentation
    85. power: update the documentation
    86. portraits: update the documentation
    87. phaseindicator: update the documentation
    88. masterlooterindicator: update the documentation
    89. leaderindicator: update the documentation
    90. healthprediction: update the documentation
    91. health: update the documentation
    92. grouproleindicator: update the documentation
    93. combatindicator: update the documentation
    94. classpower: update the documentation
    95. castbar: update the documentation
    96. auras: update the documentation
    97. assistantindicator: update the documentation
    98. alternativepower: update the documentation
    99. additionalpower: update the documentation
    100. castbar: add .timeToHold option
    101. castbar: pass the spellid to Post* hooks where applicable
    102. castbar: set .Text for failed and interrupted casts accordingly
    103. castbar: delegate hiding the castbar to the OnUpdate script
    104. castbar: update interruptible flag in UNIT_SPELLCAST(_NOT)_INTERRUPTIBLE
    105. castbar: upvalue GetNetStats
    106. castbar: rename object to self
    107. castbar: remove some unused variables
    108. castbar: deprecate .interrupt in favor of .notInterruptible
    109. castbar: use SetColorTexture
    110. castbar: add a .holdTime option
    111. power: Allow using atlases
    112. core:  update the pet frame properly after entering/exiting a vehicle
- _Sticklord (1):_
    1. core: Change the framestrata to LOW
- _Val Voronov (39):_
    1. Add README ([#373](https://github.com/oUF-wow/oUF/issues/373))
    2. threatindicator: Fix UnitThreatSituation error ([#371](https://github.com/oUF-wow/oUF/issues/371))
    3. stagger: Move Hide() call to a better spot
    4. power: Add Show() call to Enable function
    5. portrait: Move Show() call to a better spot
    6. healthprediction: Remove redundant Show() calls
    7. health: Add Show() call to Enable function
    8. alternativepower: Move Hide() call to a better spot
    9. core: oUF.xml cleanup ([#369](https://github.com/oUF-wow/oUF/issues/369))
    10. classpower: Element update ([#368](https://github.com/oUF-wow/oUF/issues/368))
    11. runes: Add nil and 0 spec checks ([#367](https://github.com/oUF-wow/oUF/issues/367))
    12. stagger: Move colour update to its own function ([#359](https://github.com/oUF-wow/oUF/issues/359))
    13. auras: Element update ([#361](https://github.com/oUF-wow/oUF/issues/361))
    14. additionalpower: Move colour update to its own function ([#360](https://github.com/oUF-wow/oUF/issues/360))
    15. runes: Add colouring support
    16. runes: Min value should be 0
    17. healthprediction: Element update ([#353](https://github.com/oUF-wow/oUF/issues/353))
    18. threatindicator: Add .feedbackUnit option
    19. classpower: Element revamp ([#347](https://github.com/oUF-wow/oUF/issues/347))
    20. Move all colors to colors.lua.
    21. Make code a bit more flexible.
    22. additionalpower: Docs review.
    23. additionalpower: Fix upvalues.
    24. additionalpower: Docs review.
    25. assistantindicator: Fix code style.
    26. assistantindicator: Docs review.
    27. alternativepower: Docs review.
    28. additionalpower: Docs review.
    29. additionalpower: Fix upvalues.
    30. additionalpower: Review docs.
    31. core: Fix code style.
    32. core: Remove redundant arg.
    33. auras: Reuse existing aura buttons, if any, and show widget on enable ([#341](https://github.com/oUF-wow/oUF/issues/341))
    34. alternativepower: Add unit to PostUpdate args ([#337](https://github.com/oUF-wow/oUF/issues/337))
    35. core: Add nameplate support ([#335](https://github.com/oUF-wow/oUF/issues/335))
    36. stagger: Revamp Update function ([#334](https://github.com/oUF-wow/oUF/issues/334))
    37. pvpindicator: Swap factionGroup only for player unit ([#331](https://github.com/oUF-wow/oUF/issues/331))
    38. runebar: Set cooldown start time to 0 if rune was energized ([#310](https://github.com/oUF-wow/oUF/issues/310))
    39. tags: Added 'powercolor' tag.
- 65 files changed, 5536 insertions(+), 4507 deletions(-)

**Changes in 1.6.9:**

- _Adrian L Lange (46):_
    1. druidmana: Add overrides for the display pairs table
    2. classicons: Make sure we update for talent changes for druids
    3. runebar: Allow PostUpdate during vehicle updates
    4. runebar: Add Override support and rename the PostUpdate hook
    5. runebar: Runes were simplified in Legion, now there's only one type
    6. power: Remove pre-legion compatibility checks
    7. health: Remove pre-legion compatibility checks
    8. classicons: Remove pre-legion compatibility checks
    9. tags: Update spec check for the holypower tag
    10. tags: Soul Shards are class-wide in Legion
    11. tags: Chi is only used for Windwalker monks in Legion
    12. tags: Remove Shadow Orbs tag from Legion
    13. tags: Add Arcane Charges tag
    14. classicons: Update when max power changes
    15. classicons: Add fallback texture color for vehicles
    16. classicons: Pass powerType through PostUpdate
    17. classicons: Add support for vehicle combo points
    18. classicons: Only update textures if the classicons are textures
    19. classicons: Use the colors provided by the color table for the textures
    20. classicons: Add Combo Points for rogues and druids
    21. classicons: Add Arcane Chages for Arcane Mages
    22. classicons: Soul Shards are class-wide in Legion
    23. classicons: Shadow Orbs no longer exist in Legion
    24. classicons: Holy Power is only used for Retribution paladins
    25. classicons: Chi is only used for Windwalker monks
    26. druidmana: Add support for other classes in Legion
    27. readycheck: Add PreUpdate/PostUpdate/PostUpdateFadeOut hooks
    28. readycheck: Add support for overriding the textures
    29. readycheck: Use the animation system for handling fading
    30. stagger: Add fallback indices for live clients
    31. runebar: RuneFrame was parented to PlayerFrame in 5.3
    32. stagger: Color indices were exposed in Legion (build 21996)
    33. power: Fix tapping for Legion
    34. health: Fix tapping for Legion
    35. power: Handle power colors from nested tables, such as the stagger colors
    36. power: Update power colors and indices for Legion
    37. tags: Remove 'pereclipse' tag
    38. stagger: The default MonkStaggerBar is parented to PlayerFrame, no need to hide it manually
    39. stagger: Monk stances no longer exist
    40. eclipsebar: Remove element
    41. tags: Use UNIT_POWER_FREQUENT instead of UNIT_COMBO_POINTS for cpoints
    42. cpoints: Use UNIT_POWER_FREQUENT instead of UNIT_COMBO_POINTS
    43. runebar: Bail if GetRuneCooldown returns nil values
    44. castbar: Kill the pet casting bar if we spawn a player castbar
    45. tags: No need to match the same string twice
    46. core: Expose the headers
- _Chris Bannister (1):_
    1. aura: Dont have oUF aura specific logic inside CreateIcon
- _Phanx (1):_
    1. aura: Update UnitAura return values
- _Rainrider (3):_
    1. runebar: let the layout define the max number of runes
    2. runebar: deactivating OnUpdate is handled in Update
    3. runebar: account for energized runes
- _Trond A Ekseth (5):_
    1. Bump TOC version to 1.6.9.
    2. Bump TOC interface version to 7.0 (70000).
    3. totems: Update example to include cooldown template.
    4. aura: Add missing internal state update after second createAuraIcon call.
    5. aura: Make the previous commit backwards compatible.
- _Val Voronov (16):_
    1. aura: A better way of getting parent frame's name.
    2. power: Added a comment.
    3. aura: Fixed issue which was causing /fstack error.
    4. pvp: Legion clean-up.
    5. powerprediction: Legion clean-up.
    6. power: Even better condition.
    7. power: Better condition.
    8. power: Alternative power colours use 0-1 range too.
    9. power: Alternative power colours use 0-255 range.
    10. druidmana: Fixed additional power bar update process.
    11. powerprediction: (Un)register 'UNIT_SPELLCAST_SUCCEEDED' event.
    12. pvp: Element revamp.
    13. prestige: Remove prestige element.
    14. powerprediction: Hide bars, when element is disabled.
    15. prestige: Add prestige widget.
    16. powerprediction: Add power cost prediction widget.
- _Valeriy Voronov (4):_
    1. classicons: Actually update widgets on forced update.
    2. stagger: Perform an actual update on forced update event.
    3. altpowerbar: Set OnLeave script only if frame doesn't have one yet.
    4. altpowerbar: Use correct UnitAlternatePowerInfo() returns.
- 19 files changed, 634 insertions(+), 583 deletions(-)

**Changes in 1.6.8:**

- _Adrian L Lange (5):_
    1. tags: Only show spec-specific tags when the resource is both usable and available
    2. classicons: Keep the overrides consistent with the rest of the elements
    3. eclipsebar: arg1 of ECLIPSE_DIRECTION_CHANGE is a string now
    4. eclipsebar: Use UNIT_POWER_FREQUENT since the astral phases has sped up significantly
    5. eclipsebar: Use the correct spellIDs for eclipse peaks
- _Trond A Ekseth (10):_
    1. Bump TOC version to 1.6.8.
    2. classicons: On enable, set the old max to the current total of icons.
    3. healprediction: Rewrap docs.
    4. stagger: Rewrap docs.
    5. range :Set file mode -x.
    6. classicons: Set file mode -x.
    7. classicons: Rewrap doc text.
    8. classicons: Run ClassPowerDisable on unsupported clases/specs.
    9. classicons: Fix declaraction of Visibility function.
    10. eclipsebar: Re-add .directionIsLunar.
- 7 files changed, 56 insertions(+), 50 deletions(-)

**Changes in 1.6.7:**

- _Adirelle (2):_
    1. colors: fixed HCYtoRGB that was returning values greater than 1.
    2. stagger: hide element in Enable.
- _Adrian L Lange (4):_
    1. castbar: Show the castbar for original units' spells as well
    2. events: Register the event with realUnit as well to allow elements to use both units while in a vehicle
    3. runebar: Hide while in a vehicle
    4. eclipsebar: Hide while in a vehicle
- _Ivan (1):_
    1. core: Remove hidden attribute.
- _Phanx (3):_
    1. EclipseBar: - Check the two eclipse buffs by name instead of looping over all active buffs. - Also call ECLIPSE_DIRECTION_CHANGE in Update.
    2. - EclipseBar: Don't call PostUnitAura if the eclipse state didn't change
    3. EclipseBar: - Added power, maxPower, powerType to arguments passed to PostUpdatePower callback. - Updated example in header comments to show that 'EclipseBar' must be a frame, not a plain table.
- _Rainrider (18):_
    1. power: account for a possible non-zero altpower min value
    2. power: pass only the unit to GetDisplayPower
    3. power: min is actually the current power
    4. power: don't call UnitIsConnected twice
    5. classicons: allow for Visibility to be overridden
    6. classicons: do trigger an update on ClassPower{Enable|Disable}
    7. classicons: let the layout deside how many widgets they define
    8. classicons: DARK_FORCE is not used anymore
    9. power: allow for coloring if the altpowerbar is being displayed instead
    10. classicons: add the UpdateTexture hook to the documentation
    11. classicons: left over print removed
    12. classicons: do not re-show segments after disabling the update
    13. classicons: remove the PostVisibility hook and call an update on disable so layouts can hide additional stuff
    14. classicon: aaaaaand ... whitespaces again
    15. classicons: fix indentation
    16. classicon: use SPELLS_CHANGED only if in the required spec or the required spell is unknown
    17. classicons: call for an update from ClassPowerEnable
    18. classicons: bug fixes and optimization
- _Trond A Ekseth (4):_
    1. Bump TOC version to 1.6.7.
    2. Bump TOC interface version to 6.0 (60000).
    3. power: Fix indentation in power docs.
    4. LICENSE: I don't even...
- _Valeriy Voronov (1):_
    1. aura: Fixed cooldown animation.
- 12 files changed, 227 insertions(+), 186 deletions(-)

**Changes in 1.6.6:**

- _Adirelle (38):_
    1. stagger: small optimization.
    2. stagger: added a hook to override the internal visibility function.
    3. stagger: stance-based visibility.
    4. stagger: update on UNIT_AURA instead of using an OnUpdate script.
    5. stagger: minor optimization.
    6. altpowerbar: fixed visibility.
    7. core: register UNIT_ENTERED_VEHICLE, UNIT_EXITED_VEHICLE and UNIT_PET as unitless to properly get the updates.
    8. events: do not register events for self.realUnit anymore.
    9. altpowerbar: allow .Override.
    10. colors: added a global toggle, namely oUF.useHCYColorGradient, to select which algorithm oUF.ColorGradient uses.
    11. colors: provides the original ColorGradient as RGBColorGradient as well.
    12. colors: provides a color gradient in (hue, chroma, luma) (HCY') space.
    13. events: use RegisterUnitEvent to replace our home-brew event dispatcher.
    14. healprediction: show the widget when enabled, hide it when disabled.
    15. totems: hide the totem widgets when disabled.
    16. threat: hide the widget when disabled.
    17. ricons: hide the widget when disabled.
    18. resting: hide the widget when disabled.
    19. readycheck: : hide the widget when disabled.
    20. range: restore opacity when disabled.
    21. qicon: hide the widget when disabled.
    22. pvp: hide the widget when disabled.
    23. portraits: show the widget when enabled, hide it when disabled.
    24. picon: hide the widget when disabled.
    25. masterlooter: hide the widget when disabled.
    26. lfdrole: hide the widget when disabled.
    27. leader: hide the widget when disabled.
    28. health: hide the widget when disabled.
    29. eclipsebar: hide the widget when disabled.
    30. cpoints: hide the widgets when disabled.
    31. combat: hide the widget when disabled.
    32. castbar: hide the widget when disabled.
    33. assistant: hide the widget when disabled.
    34. altpowerbar: hide the widget when disabled.
    35. classicons: refactored class enable/disable code.
    36. altpowerbar: add a .showOthersAnyway option to show it for other players.
    37. altpowerbar: enforce the lower and upper bounds on :SetValue.
    38. healprediction: add a .frequentUpdates option to update on UNIT_HEALTH_FREQUENT.
- _Clamsoda (1):_
    1. altpowerbar: Change HasScript to GetScript
- _Erik Raetz (1):_
    1. units: Adding two generic boss events.
- _Rainrider (5):_
    1. stagger: add monk's stagger bar
    2. power: optimize a bit
    3. power: UNUSED is now called CHI
    4. threat: don't hide the element in Enable
    5. aura: fix auras.visibleBuffs being off by 1 if auras.gap and debuffs are present
- _Trond A Ekseth (5):_
    1. Bump TOC version to 1.6.6.
    2. Bump TOC interface version to 5.4 (50400).
    3. Bump TOC version to 1.6.5.
    4. Bump TOC interface version to 5.3 (50300).
    5. Revert "core: Fall-back to pre-5.2 menus for raid frames."
- _Valeriy Voronov (1):_
    1. classicons: fixed ClassPowerEnable/Disable for Monk and Paladin
- _budha (2):_
    1. totems: export a copy of the (STANDARD|SHAMAN)_TOTEM_PRIORITIES table
    2. totems: expose TOTEM_PRIORITIES to oUF Layouts
- _freebaser (4):_
    1. healpredication: fix show/hide statusbars
    2. healprediction: support for healAbsorbBar
    3. healprediction: New absorb amount event
    4. healprediction: absorbBar support
- 31 files changed, 512 insertions(+), 189 deletions(-)

**Changes in 1.6.5:**

- _Rainrider (1):_
    1. tags: eliterare -> rareelite
- _Trond A Ekseth (4):_
    1. Bump TOC version to 1.6.5.
    2. Bump TOC interface version to 5.3 (50300).
    3. Revert "core: Fall-back to pre-5.2 menus for raid frames."
    4. core: Fall-back to pre-5.2 menus for raid frames.
- 2 files changed, 6 insertions(+), 4 deletions(-)

**Changes in 1.6.4:**

- _Erik Raetz (1):_
    1. core: Adding togglemenu to header units
- _Trond A Ekseth (1):_
    1. Bump TOC version to 1.6.4.
- 2 files changed, 2 insertions(+), 2 deletions(-)

**Changes in 1.6.3:**

- _Trond A Ekseth (4):_
    1. TOC: Bump version to 1.6.3.
    2. core: Ues the 5.2 secure unit dropdown.
    3. tags: LIGHT_FORCE was renamed CHI.
    4. units: Don't poll on boss unitids.
- 5 files changed, 4 insertions(+), 15 deletions(-)

**Changes in 1.6.2:**

- _Adrian L Lange (1):_
    1. tags: Support battle pets' level
- _Phanx (1):_
    1. aura: icon indices start at 1, not 0.
- _Rainrider (1):_
    1. altpowerbar: allow layouts to position the tooltip
- _Trond A Ekseth (5):_
    1. TOC: Bump version to 1.6.2.
    2. TOC: Bump interface version to 50200 (5.2).
    3. totem: Destroy the OnClick handler.
    4. power: Correctly display tapping.
    5. health: Correctly display tapping.
- 7 files changed, 19 insertions(+), 20 deletions(-)

**Changes in 1.6.1:**

- _Manriel (1):_
    1. TOC: Add notes in ruRU locale
- _Rainrider (2):_
    1. classicons: allow layouts to properly size and position on initial update
    2. tags: account for the new 'minus' return of UnitClassification()
- _Trond A Ekseth (8):_
    1. TOC: Bump version to 1.6.1.
    2. TOC: Bump interface version to 50100 (5.1).
    3. altpowerbar: Support tooltip.
    4. aura: Make :ForceUpdate call Update instead of UpdateAuras.
    5. altpowerbar: Make coloring function like the other elements.
    6. altpowerbar: Fix incorrect whitespace and move around some code.
    7. core: Hide frames during pet battles.
    8. classicons: The widgets are expected to be textures.
- _andy (1):_
    1. altpowerbar: use api to set statusbar colour
- _freebaser (3):_
    1. classicons: Chi powerType change
    2. range: Add offline fallback
    3. classicons: Make RequireSpell and RequireSpec local.
- _phanx (2):_
    1. totems: Prevent out-of-range error.
    2. colors: Other add-ons can implement custom colors.
- 10 files changed, 122 insertions(+), 26 deletions(-)

**Changes in 1.6.0:**

- _Adirelle (5):_
    1. assistant: Add missing 'and'.
    2. Added my own event dispatcher.
    3. Added a :IsElementEnabled meta ; use it in :EnableElement and :DisableElement to avoid enabling/disabling an element twice.
    4. Added arena units to :DisableBlizzard.
    5. Fixed the bug with Clique support that prevented the headers to update properly.
- _Adrian L Lange (12):_
    1. tags: Add shadoworbs tag
    2. tags: Add new chi tag
    3. shadoworbs: New element
    4. harmonyorbs: New element
    5. threat: Add some basic documentation.
    6. ricons: Add some basic documentation.
    7. resurrect: Add some basic documentation.
    8. resting: Add some basic documentation.
    9. qicon: Add some basic documentation.
    10. eclipsebar: Add some basic documentation.
    11. blizzard: Remove focus entries from all dropdown menus.
    12. Add resurrect icon element
- _Adrian Lund-Lange (2):_
    1. raidrole: Add support for main-assist
    2. maintank: Rename to RaidRole
- _Chris Bannister (1):_
    1. Dont use chat latency
- _Erik Raetz (2):_
    1. portrait: Reset settings before setting the new model.
    2. Portrait fix revised - Fixed model position not reseting correctly while swapping from model to questionmark and vise versa - Fixed bug where the questionmark model would persist because of the guid not reseting corretly - Fixed male worgen portraits - Removed else condition (obsolete) - Added ClearModel() to allow model value reseting correctly
- _Matt Emborsky (1):_
    1. aura: Fix calculation offset for columns based upon first being positioned at 0 instead of 1 offset.
- _Paul Owen (1):_
    1. holypower: Use UnitPowerMax to fetch maximum value.
- _Rainrider (3):_
    1. shadoworbs: can't call Show()/Hide() on an array
    2. power: Point power type colors to oUF.colors.power instead of PowerBarColors
    3. don't outsideAlpha units which UnitInRange does not check range for
- _Saiket (2):_
    1. blizzard: Prevent disabled player frame from animating while hidden.
    2. blizzard: Prevent tainting the default UI's AnimationSystem when hiding default unit frames.
- _Trond A Ekseth (290):_
    1. TOC: Bump interface version to 50001 (5.0).
    2. tags: Change RAID_ROSTER_UPDATE to GROUP_ROSTER_UPDATE.
    3. threat: Update TexCoord.
    4. threat: Check if there's a texture before we hide the frame.
    5. runebar: Add alt to :PostUpdateType().
    6. runebar: Add start, duration and runeReady to :PostUpdateRune().
    7. runebar: Remove a scope.
    8. runebar: Add :PostUpdateRune(rune, rid).
    9. runebar: Add :PostUpdateType(rune, rid).
    10. core: Remove maintank from the element list.
    11. runebar: Correct coloring when logging in without Factory.
    12. classbars: Is a stray file. :(
    13. classicons: Remove deprecated code.
    14. classicons: Add a third argumen to :PostUpdate().
    15. classicons: Only run :SetDesaturated() if it exists.
    16. classicons: Throw cpoints back to its own element.
    17. classicons: Merges cpoints, harmonyorbs, holypower, shadoworbs and soulshards.
    18. core: Change PARTY_MEMBERS_CHANGED to GROUP_ROSTER_UPDATE.
    19. Revert "core: Workaround GetAddOnMetadata not returning X-values in MoP."
    20. raidrole: Remove WoW4 compatibility.
    21. masterlooter: Remove WoW4 compatibility.
    22. lfdrole: Remove WoW4 compatibility.
    23. eclipsebar: Remove WoW4 compatibility.
    24. tags: Remove WoW4 compatibility.
    25. leader: Remove WoW4 compatibility.
    26. assistant: Remove WoW4 compatibility.
    27. blizzard: Fix default buffs not showing at login.
    28. shadoworbs: Add proper punctuation.
    29. harmonyorbs: Add proper punctuation.
    30. shadoworbs: Correct the number of orbs required in the docs.
    31. tags: Fix typo in [holypower].
    32. assistant: Additional MoP function changes.
    33. leader: Fix syntax error.
    34. eclipsebar: Merge in MoP function changes.
    35. raidrole: Merge in MoP event changes.
    36. masterlooter: Merge in MoP event changes.
    37. lfdrole: Merge in MoP event changes.
    38. assistant: Merge in MoP event changes.
    39. leader: Merge in MoP event changes.
    40. leader: Merge in MoP function changes.
    41. assistant: Merge in MoP function changes.
    42. pvp: Don't set the PvP icon to Neutral on MoP.
    43. tags: Merge in MoP function changes.
    44. core: Workaround GetAddOnMetadata not returning X-values in MoP.
    45. assistant: Document :PostUpdate().
    46. docs: Correct the order we close code and pre tags.
    47. assistant: Document :PreUpdate().
    48. assistant: Move the :Override() docs to the function.
    49. altpowerbar: Document :PostUpdate().
    50. altpowerbar: Document :PreUpdate().
    51. docs: Support short docs with only title and description.
    52. altpowerbar: Minor change to the indenting of the docs.
    53. totems: Use the default UIs priority lists.
    54. totems: Remove unused colors.
    55. totems: Initial documentation.
    56. soulshards: Initial documentation.
    57. eclipsebar: Correct the parent in the example.
    58. runebar: Apply textures in the same order we apply colors.
    59. runebar: Initial documentation.
    60. aura: Add missing punctuation.
    61. aura: Capitalize widget types in the docs.
    62. readycheck: Initial documentation.
    63. range: Initial documentation.
    64. docs: Arguments need to have the same padding.
    65. raidrole: Initial documentation.
    66. eclipsebar: Minor fixus to argument indentation.
    67. aura: Minor fixes to argument indentation.
    68. resurrect: Fix wrapping in docs.
    69. qicon: Fix wrapping and add punctuation in docs.
    70. eclipsebar: Change the wording in the docs slightly.
    71. eclipsebar: Simplify example code.
    72. eclipsebar: Move the function docs to the same indent level as the functions.
    73. ricons: Remove whitespace error in docs.
    74. threat: Remove whitespace error in docs.
    75. pvp: Add some basic documentation.
    76. power: Add some basic documentation.
    77. portraits: Add some basic documentation.
    78. picon: Add some basic documentation.
    79. masterlooter: Add some basic documentation.
    80. lfdrole: Add some basic documentation.
    81. leader: Add some basic documentation.
    82. holypower: Add some basic documentation.
    83. docs: Support different types within one section.
    84. docs: Correctly find the first block.
    85. health: Add some basic documentation.
    86. druidmana: Fix wrapping on sub-widget options.
    87. docs: Use :sub(3) instead of trim() on source code.
    88. healprediction: Add some basic documentation.
    89. druidmana: Add basic documentation.
    90. druidmana: Clean up comments.
    91. cpoints: Add some basic documentation.
    92. combat: Add some basic documentation.
    93. docs: Improve path handling.
    94. Assistant: All UI widgets support Show/Hide.
    95. aura: Remove indentation in :SetPosition() documentation.
    96. castbar: Add some basic documentation.
    97. altpowerbar: Change the widget wording slightly.
    98. altpowerbar: Add documentation.
    99. docs: Support multiple examples within a example section.
    100. assistant: Move Examples below notes.
    101. aura: Add documentation for :PostUpdateGapIcon.
    102. aura: Reword the description for :PostCreateIcon.
    103. aura: Add documentation for :SetPosition.
    104. aura: Change offset in :PostUpdateIcon to represent the actual aura icon index in the table.
    105. aura: Add documentation for :PostUpdateIcon.
    106. aura: Add documentation for :PostCreateIcon.
    107. aura: Add a description for :CreateIcion.
    108. aura: Rename Hooks to Hooks and Callbacks.
    109. aura: Add documentation for :CustomFilter.
    110. aura: Add documentation for :CreateIcon.
    111. aura: Add some documentation.
    112. assistant: Add some documentation.
    113. docs: Remove already fixed issue.
    114. docs: Move the 'cursor' further down after handling a section.
    115. docs: Remove false comment.
    116. docs: Replace [link](url) with an anchor.
    117. docs: Replace `sentence` with <code>sentence</code>.
    118. docs: Strip tab indents from comments.
    119. docs: Implement support for multiple comments.
    120. docs: split nextarg into two lines.
    121. docs: Correctly parse indented argument lists.
    122. docs: Remove restrictions around header names.
    123. docs: Initial commit for the documentation generator.
    124. aura: Change the arguments to :SetPosition() to be 1-based and not 0-based.
    125. aura: Bail out if we try to access out of bounds.
    126. aura: Re-run :SetPosition on ForceUpdates as well.
    127. aura: Fix the :SetPosition offset for updates through UpdateAllElements.
    128. aura: Add missing return checks for :PreSetPosition() on buffs and debuffs.
    129. aura: Allow :PreSetPosition() to define the re-anchoring range.
    130. power: Use type as a final color fallback.
    131. power: Allow layouts to override alternative colors.
    132. power: Allow power colors by type in self.colors.power.
    133. runebar: Check for a valid texture before we set colors.
    134. runebar: Don't call show/hide on enable/disable.
    135. LICENSE: Six years? Cool.
    136. blizzard: Move comments and add newlines for consistency.
    137. power: Use UNIT_POWER_FREQUENT instead of OnUpdate polling.
    138. soulshards: Use UNIT_POWER_FREQUENT instead of UNIT_POWER.
    139. tags: Add [holypower].
    140. tags: Add [soulshards].
    141. holypower: Use Hide/Show instead of Alpha for consistency.
    142. souldshards: Use Hide/Show instead of Alpha for consistency.
    143. masterlooter: Hide the icon when the unit isn't in raid/party.
    144. ricon: Move code around slightly.
    145. resurrect: Remove extra newline.
    146. resting: Remove extra newline.
    147. picon: Remove extra newline.
    148. masterlooter: Remove extra newline.
    149. maintank: Remove extra newline.
    150. lfdrole: Remove extra newline.
    151. leader: Remove extra newline.
    152. combat: Remove extra newline.
    153. resurrect: Add {Pre, Post}Update.
    154. resting: Add {Pre, Post}Update.
    155. qicon: Add {Pre, Post}Update.
    156. pvp: Add {Pre, Post}Update.
    157. pvp: Don't check for the existence of self.PvP.
    158. picon: Add {Pre, Post}Update.
    159. masterlooter: Only check for ML in raid/party.
    160. masterlooter: Add {Pre, Post}Update.
    161. masterlooter: Change function definition for consistency.
    162. lfdrole: Return on :PostUpdate().
    163. maintank: Add {Pre, Post}Update.
    164. leader: Add {Pre, Post}Update.
    165. combat: Add {Pre, Post}Update.
    166. assistant: Add {Pre, Post}Update.
    167. lfdrole: Add {Pre,Post}Update.
    168. cpoints: Don't return on :PreUpdate().
    169. ricons: Add {Pre,Post}Update.
    170. cpoints: Add :PreUpdate().
    171. soulshards: Remove unit from {Pre,Post}Update.
    172. holypower: Remove unit from {Pre,Post}Update.
    173. health: Remove unused variable.
    174. core: Correctly update pets on UNIT_PET.
    175. core: Fix two typos.
    176. core: Remove local references of globals.
    177. core: Remove definition of Private.OnEvent.
    178. core: Move updateActiveUnit() up to its local.
    179. castbar: Move SafeZone calculations out of the OnUpdate handler.
    180. castbar: Workaround GetNetStats() returning 0 instead of latencies.
    181. Bump TOC interface version to 4.3 (40300).
    182. core: Convert 'target' to 'Target' in generated names.
    183. core: Append 'Raid' to the generated name if its for a certain group.
    184. holypower: Add the number of holy powers to the :PostUpdate callback.
    185. soulshards: Add the number of soulshards to the :PostUpdate callback.
    186. cpoints: Add :PostUpdate(cp).
    187. aura: Remove unnecessary :EnableMouse() call.
    188. aura: Reset the size of the icons no every update.
    189. aura: Run a full :SetPoisition when :UpdateAllElements is called without arguments.
    190. changelog: Remove superfluous whitespace.
    191. core: Accidental prints is what happens when you code without coffee.
    192. core: Track enabled elements by name instead of update function.
    193. range: Enable should return true when we enabled.
    194. aura: Move definition of .owner and .isPlayer out of the internal CustomFilter function.
    195. aura: Rename .debuff to .isDebuff.
    196. aura: Expose .filter and .debuff to CustomFilter.
    197. aura: Corretly hide the count display on gap auras.
    198. changelog: Fix indentation fail. :(
    199. aura: Continue where left off when we have to anchor.
    200. aura: Reduce re-anchoring further by not skipping hidden icons.
    201. aura: Move the gap implementation out of the anchoring code.
    202. aura: Re-anchor when the amoun of visibleDebuffs has changed as well.
    203. events: Remove non-core shared unit events from the default list.
    204. totems: Tag PLAYER_TOTEM_UPDATE as shared.
    205. runebar: Tag RUNE_{TYPE,POWER}_UPDATE as shared.
    206. ricons: Tag RAID_TARGET_UPDATE as shared.
    207. resurrect: Tag INCOMING_RESURRECT_CHANGED as shared.
    208. resting: Tag PLAYER_UPDATE_RESTING as shared.
    209. readycheck: Tag READY_CHECK* as shared.
    210. picon: Tag UNIT_PHASE as shared.
    211. masterlooter: Tag PARTY_{MEMBERS,LOOT_METHOD}_CHANGED as shared.
    212. maintank: Tag events as shared.
    213. lfdrole: Tag events as shared.
    214. leader: Tag PARTY_{MEMBERS,LEADER}_CHANGED as shared.
    215. eclipsebar: Tag unitless events as shared.
    216. cpoints: Tag events as shared.
    217. combat: Tag PLAYER_REGEN_{ENABLED,DISABLED} as shared.
    218. assistant: Tag PARTY_MEMBERS_CHANGED as shared.
    219. tags: Change how we expose our internal tables.
    220. events: Add a third argument to :RegisterEvent() to populate the "shard" unit event table.
    221. auras: Re-anchor when gap is enabled and the amount of visible buffs changed.
    222. aura: Re-anchor on auras when gap is enabled, zero buffs and >0 debuffs.
    223. utils: Commit my shortlog -> bbcode generator.
    224. power: Remove divison by zero check and update arguments on ColorGradient.
    225. health: Remove divison by zero check and update arguments on ColorGradient.
    226. druidmana: Remove divison by zero check and update arguments on ColorGradient.
    227. colors: Move division into ColorGradient.
    228. power: Add check to prevent divison by zero.
    229. health: Add check to prevent division by zero.
    230. druidmana: Add check to prevent division by zero.
    231. colors: Remove inf and NaN check from ColorGradient.
    232. castbar: Don't process delay/update events when the castbar isn't shown.
    233. aura: Reduce the amount of needless re-anchoring.
    234. range: Add override function.
    235. runes: Verify the object type before we attempt to apply a texture.
    236. power: Verify the object type before we attempt to apply a texture.
    237. health: Verify the object type before we attempt to apply a texture.
    238. healprediction: Verify the object type before we attempt to apply a texture.
    239. eclipsebar: Verify the object type before we attempt to apply a texture.
    240. druidmana: Verify the object type before we attempt to apply a texture.
    241. castbar: Verify the object type before we attempt to apply a texture.
    242. power: Properly unregister all events on Disable.
    243. health: Remove unnecessary UnregisterEvent for UNIT_POWER.
    244. core: Change the position of where we call :HandleUnit().
    245. portrait: Remove bad indenting.
    246. Change the call order of things in :Spawn() so events are blocked correctly.
    247. Silently block OnUpdate polled frames from registering events.
    248. Tag frames with OnUpdate's as __eventless.
    249. Expose :IsEventRegistered as the frame one won't return the correct information anymore.
    250. Flip the shared event logic and drop the metatable.
    251. Kill the oUF.units table.
    252. Fix bad indenting.
    253. Prevent the ResurrectIcon element from executing on 4.1.
    254. Handle LoD layouts which use the factory correctly.
    255. Expose the r,g,b values to the PostUpdate function.
    256. We require additional events.
    257. Allow the power element to display alternative power as well.
    258. We don't OnUpdate poll anymore, so this check is redundant.
    259. UHF overlap with UH now, so we only have to register one of them \:D/.
    260. Set castbar.casting to nil when getting ready to start a channel. This is to work around edge cases where channels are started before the previous spell cast has been completed.
    261. Bump TOC interface version to 4.1 (40100).
    262. Add a totems element.
    263. Don't assume the call to :UnregisterEvent() is correct when there's only one event handler.
    264. Disable the arena frames through the CVar as well.
    265. Remove everything related to pet happiness.
    266. Use unit instead of value. Consistency change only.
    267. Check if the groupFilter is a string before attempting to match it.
    268. Copy/paste errors. We has them.
    269. Properly set the correct .unit for non-onlyProcessChildren frames as well.
    270. Handle the case where someone has modified the unitsuffix attribute after we have guessed the unit.
    271. Refactor initObject and extend oUFs guessUnit to support maintank and mainassist.
    272. So much fail today.
    273. Fix the default threat icon.
    274. Be consistent and always use 'unit'.
    275. Split the unit handling code from :DisableBlizzard() into :HandleUnit().
    276. Call :SetMinMaxValues() before :SetValue().
    277. Use ForceUpdate so we run the {Pre,Post}Update handlers.
    278. Cool, a print. This is what happens when you don't branch out from master like you should.
    279. Update happiness correctly while using frequentUpdates.
    280. Remove .parent from the buff icons.
    281. Update the player frame slightly less.
    282. Adopt Adirelle's changes, which correct updating of player pet when leaving a vehicle.
    283. Add missing return values from UnitAura.
    284. Don't allow frequentUpdates on frames that have a OnUpdate set.
    285. Revert "Don't think we need to force an OnUpdate on the bossN unitids anymore."
    286. Use UNIT_PET to update vehicles and change the code slightly.
    287. Bump TOC version to 1.6.0.
    288. For now, just expect that it should have a icon.stealable.
    289. We don't have spell ranks anymore.
    290. Use UNIT_HEALTH_FREQUENT instead of OnUpdate polling.
- _budha (2):_
    1. update totems display order: earth - fire - water - air
    2. update runes display order: blood - frost - unholy
- _zorker (1):_
    1. Fixing the male worgen portrait problem. You can now use SetPortraitZoom instead on SetCamera. That new and yet not documented WoW API function got introduces with the new SetDisplayID() functionality in Cataclysm. (Mainly for showing Quest NPC's that you do not have yet in your cache).
- 42 files changed, 2654 insertions(+), 576 deletions(-)

**Changes in 1.5.16:**

- _Trond A Ekseth (3):_
    1. Bump TOC interface version to 4.3 (40300).
    2. castbar: Workaround GetNetStats() returning 0 instead of latencies.
    3. Bump TOC version to 1.5.16.
- 2 files changed, 24 insertions(+), 10 deletions(-)

**Changes in 1.5.15:**

- _Trond A Ekseth (4):_
    1. core: Accidental prints is what happens when you code without coffee.
    2. core: Track enabled elements by name instead of update function.
    3. range: Enable should return true when we enabled.
    4. Bump TOC version to 1.5.15.
- 3 files changed, 22 insertions(+), 9 deletions(-)

**Changes in 1.5.14:**

- _Trond A Ekseth (15):_
    1. druidmana: Remove incorrect indentation.
    2. power: Add check to prevent divison by zero.
    3. health: Add check to prevent division by zero.
    4. druidmana: Add check to prevent division by zero.
    5. colors: Remove inf and NaN check from ColorGradient.
    6. runes: Verify the object type before we attempt to apply a texture.
    7. power: Verify the object type before we attempt to apply a texture.
    8. health: Verify the object type before we attempt to apply a texture.
    9. healprediction: Verify the object type before we attempt to apply a texture.
    10. eclipsebar: Verify the object type before we attempt to apply a texture.
    11. druidmana: Verify the object type before we attempt to apply a texture.
    12. castbar: Verify the object type before we attempt to apply a texture.
    13. Bump TOC version to 1.5.14.
    14. power: Properly unregister all events on Disable.
    15. health: Remove unnecessary UnregisterEvent for UNIT_POWER.
- 9 files changed, 37 insertions(+), 19 deletions(-)

**Changes in 1.5.13:**

- _Califpornia (3):_
    1. Renamed .lua file to match the .toc
    2. Cleanup
    3. Initial commit
- _Ennie (1):_
    1. Make changes according to haste's suggestions.
- _John Ross (4):_
    1. better vehicle support
    2. fixed gradient lookup, added check even if unit is in a vehicle
    3. added event to better track when to show and hide bar
    4. follow normal plugin format as well as add add a faster update for form switching
- _Trond A Ekseth (15):_
    1. Change indentation to be more consistent.
    2. Commas are required in Lua.
    3. Fix the tag events for curmana and maxmana.
    4. Add useful information to the post-callback.
    5. Add the missing 'then'.
    6. Remove some old defensive code.
    7. Remove unnecessary global oUF fallback.
    8. Remove unnecessary global oUF fallback.
    9. Split the mana tag into curmana and maxmana to be consistent with curpp and maxpp.
    10. Move the tag into the tag element.
    11. Remove extra newlines.
    12. Change OnPowerUpdate to OnDruidManaUpdate so we can tell the difference.
    13. Clean up the file.
    14. Rename and allow oUF_DruidMana to load.
    15. Bump TOC version to 1.5.13.
- 6 files changed, 169 insertions(+), 48 deletions(-)

**Changes in 1.5.12:**

- _Adirelle (1):_
    1. Added a :IsElementEnabled meta ; use it in :EnableElement and :DisableElement to avoid enabling/disabling an element twice.
- _Adrian L Lange (1):_
    1. Add resurrect icon element
- _Rainrider (1):_
    1. don't outsideAlpha units which UnitInRange does not check range for
- _Trond A Ekseth (11):_
    1. Bump TOC version to 1.5.12.
    2. Bump TOC interface version to 4.2 (40200).
    3. Remove dead code.
    4. Remove the 4.1 check.
    5. Only hide the default alt. power bar when we create one for a player unit.
    6. Don't error when we encounter units which aren't in a raid.
    7. Apply a round of sed and some manual style changes.
    8. Add MainTank icon element by Neav.
    9. Fix bad indenting.
    10. Prevent the ResurrectIcon element from executing on 4.1.
    11. Handle LoD layouts which use the factory correctly.
- 9 files changed, 152 insertions(+), 27 deletions(-)

**Changes in 1.5.11:**

- _Trond A Ekseth (9):_
    1. Bump TOC version to 1.5.11.
    2. Expose the r,g,b values to the PostUpdate function.
    3. We require additional events.
    4. Allow the power element to display alternative power as well.
    5. More leftover happiness fluff :-(.
    6. Don't need to piggyback no UP anymore, as pets can't be sad.
    7. We don't OnUpdate poll anymore, so this check is redundant.
    8. UHF overlap with UH now, so we only have to register one of them \:D/.
    9. Set castbar.casting to nil when getting ready to start a channel. This is to work around edge cases where channels are started before the previous spell cast has been completed.
- 5 files changed, 32 insertions(+), 19 deletions(-)

**Changes in 1.5.10:**

- _Adirelle (2):_
    1. Added arena units to :DisableBlizzard.
    2. Fixed the bug with Clique support that prevented the headers to update properly.
- _Trond A Ekseth (7):_
    1. Bump TOC version to 1.5.10.
    2. Looks like we had leftovers :(.
    3. Nuke pet happiness from orbit.
    4. Bump TOC interface version to 4.1 (40100).
    5. Add a totems element.
    6. Don't assume the call to :UnregisterEvent() is correct when there's only one event handler.
    7. Disable the arena frames through the CVar as well.
- 11 files changed, 145 insertions(+), 114 deletions(-)

**Changes in 1.5.9:**

- _Chris Bannister (1):_
    1. Dont use chat latency
- _Trond A Ekseth (20):_
    1. Bump TOC version to 1.5.9.
    2. Disable happiness related stuff on 4.1.
    3. Use unit instead of value. Consistency change only.
    4. Check if the groupFilter is a string before attempting to match it.
    5. Copy/paste errors. We has them.
    6. Properly set the correct .unit for non-onlyProcessChildren frames as well.
    7. Handle the case where someone has modified the unitsuffix attribute after we have guessed the unit.
    8. Refactor initObject and extend oUFs guessUnit to support maintank and mainassist.
    9. So much fail today.
    10. Fix the default threat icon.
    11. Be consistent and always use 'unit'.
    12. Split the unit handling code from :DisableBlizzard() into :HandleUnit().
    13. Call :SetMinMaxValues() before :SetValue().
    14. Use ForceUpdate so we run the {Pre,Post}Update handlers.
    15. Cool, a print. This is what happens when you don't branch out from master like you should.
    16. Update happiness correctly while using frequentUpdates.
    17. Use __owner instead of :GetParent().
    18. UH and UHF doesn't properly overlap, so we have to register the both.
    19. We only need to register one of the main health events as they overlap.
    20. Use UNIT_HEALTH_FREQUENT instead of OnUpdate polling.
- 14 files changed, 158 insertions(+), 134 deletions(-)

**Changes in 1.5.8:**

- _Trond A Ekseth (6):_
    1. Bump TOC version to 1.5.8.
    2. Update the player frame slightly less.
    3. Adopt Adirelle's changes, which correct updating of player pet when leaving a vehicle.
    4. Add missing return values from UnitAura.
    5. Don't allow frequentUpdates on frames that have a OnUpdate set.
    6. Revert "Don't think we need to force an OnUpdate on the bossN unitids anymore."
- 5 files changed, 24 insertions(+), 8 deletions(-)

**Changes in 1.5.7:**

- _Trond A Ekseth (2):_
    1. Bump TOC version to 1.5.7.
    2. Use UNIT_PET to update vehicles and change the code slightly.
- 2 files changed, 33 insertions(+), 30 deletions(-)

**Changes in 1.5.6:**

- _Chris Bannister (3):_
    1. Revert "Add caster"
    2. Incase groupFilter is a number, which it can be
    3. Add caster
- _Trond A Ekseth (32):_
    1. Bump TOC version to 1.5.6.
    2. Drop out of RaidIcon:ForceUpdate() if the frame doesn't have a unit.
    3. Merge the vehicle element into the core and fix a bug with party/raid units in vehicles being chain updated.
    4. Remove double space.
    5. There are four boss frmaes, not three.
    6. The readyCheck events don't use unitids, but send actual player names. Work around this and kill the 4.0.1 support code.
    7. Convert our event handler back to a pure function if we no longer have multiple registrations.
    8. Prevent double registration of the same function.
    9. Use :Hide() instead of an empty function.
    10. Actually, let's just kill the function instead.
    11. One less typo.
    12. Don't think we need to force an OnUpdate on the bossN unitids anymore.
    13. Unregister events on TargetofFocusFrame as well when we disable the FocusFrame.
    14. Unregister events om .powerBarAlt if it exists.
    15. Use the correct update function, and correctly check unit arguments.
    16. We might want to hide the element, and not the entire frame.
    17. Make :ForceUpdate() call the correct function.
    18. Remove some double spaces.
    19. Don't create hidden holes in the aura table.
    20. AltPowerBar should be a good element and use the namespace, and not the global.
    21. Kick out the coloring code and remove the global access to our internal namespace.
    22. Move the event system to its own file as well.
    23. Move disabling of blizzard frames to its own file.
    24. Four more years!
    25. Move the factory fluff to its own file.
    26. Start the 2011 clean-up.
    27. Hide the element on init.
    28. Add the element to the full-update list.
    29. Start on a alternative power bar element.
    30. Add frame wide {Pre,Post}Update.
    31. Fix broken logic.
    32. Fix indenting.
- _p3lim (2):_
    1. Bump the layer to prevent interfering with backdrops
    2. Vehicles still exists while the player has full control
- _tekkub (1):_
    1. That can get racey
- 21 files changed, 505 insertions(+), 384 deletions(-)

**Changes in 1.5.5:**

- _Evilpaul (1):_
    1. ensure new power elements display corretly when in-vehicle
- _Trond A Ekseth (6):_
    1. Bump TOC version to 1.5.5.
    2. Register PMC as we can't rely on the secure group header anymore.
    3. Properly hide the RuneFrame so it doesn't repop after exiting a vehicle on CC.
    4. Kill the OnClick handler on the aura icons.
    5. Use obj.onUpdateFrequency to check so we can change the value "on the fly".
    6. Allow layouts to se the OnUpdate frequency through obj.onUpdateFrequency.
- 8 files changed, 28 insertions(+), 33 deletions(-)

**Changes in 1.5.4:**

- _Trond A Ekseth (2):_
    1. Bump TOC version to 1.5.4.
    2. Fix the frameref fail.
- 2 files changed, 2 insertions(+), 2 deletions(-)

**Changes in 1.5.3:**

- _Trond A Ekseth (9):_
    1. Bump TOC version to 1.5.3.
    2. Always send nil instead of rank and add a note to kill it in 1.6.x.
    3. Allow custom values for fadeTimer and finishedTimer.
    4. Let the raid into the ready check fun.
    5. Extend the guessUnit to support the party pet header as well.
    6. Add a oUF-headerType attribute.
    7. Now with less 7AM coding. :(
    8. Require the event to be correct when validating powerType, so PEW updates and such can get through.
    9. Stricten the register event validation so you can't register events to handlers that don't exist.
- 5 files changed, 48 insertions(+), 31 deletions(-)

**Changes in 1.5.2:**

- _Trond A Ekseth (4):_
    1. Bump TOC version to 1.5.2.
    2. Fix the damn ready check icon and work around the bugs caused by RegisterAttributeDriver.
    3. Feed guessUnit to the elements function as well.
    4. Use self.id and not self:GetID().
- 3 files changed, 84 insertions(+), 15 deletions(-)

**Changes in 1.5.1:**

- _Trond A Ekseth (2):_
    1. Bump TOC version to 1.5.1.
    2. Damn you XML! (and how vim auto-completes your tags)
- 2 files changed, 1 insertion(+), 2 deletions(-)

**Changes in 1.5:**

- _Evilpaul (28):_
    1. addition of EclipseBar element
    2. addition of QuestIcon element
    3. change of power type name
    4. change of power type name
    5. addition of PhaseIcon element
    6. addition of SoulShards element
    7. addition of HolyPower element
    8. Add :ForceUpdate() support
    9. register Path as the update function
    10. use new return values from UnitGroupRolesAssigned
    11. update version
    12. adjust the minmax values on all events to ensure this works for targets
    13. set statusbar minmaxvalues at enable
    14. use the correct health reference
    15. use the new location for maxOverflow
    16. use short name for consistancy
    17. Update to use the new override method
    18. contain both indicator bars under .HealPrediction
    19. make sure something exists before we try to use it
    20. some tidying up
    21. add PreUpdate and PostUpdate functionality
    22. remove hide option
    23. consolidate into 1 update routine
    24. typo in name
    25. typo
    26. initial version of functionality
    27. use a better name
    28. first commit
- _Trond A Ekseth (123):_
    1. Bump TOC version to 1.5.
    2. Replace the not so true comment with typos with a new one.
    3. Add an example template for onlyProcessChildren.
    4. Remove some attributes from the template example.
    5. Change RegisterStateDrive to RegisterAttributeDrive.
    6. A copy/paste error walks into a bar and passes two people...
    7. Set interface version to 40000.
    8. Expose the unit variable so it can be used correctly in oUF-initialConfigFunction.
    9. Set the attributes on the correct frame.
    10. Add self.id to sub-objects.
    11. Use repeat until instaed of while do end.
    12. Simplify the event check in UNIT_POWER.
    13. Fix a leaked global.
    14. Don't assign 'false' to anything.
    15. Use unit instead of self.unit where we can.
    16. Add missing event and make some minor changes to the code.
    17. Make some micro-optimizations to tags.
    18. Add tagfs.overrideUnit to send realUnit as a second argument to the tag function(s).
    19. Always activate vehicle switch on frames by default.
    20. Add *type1 and toggleForVehicle to all frames.
    21. Call :SetAttribute('*type2', 'menu') on single units as well.
    22. Run oUF-initialConfigFunction on all header created frames, as the initial frame needs a sizes as well.
    23. Don't call oUF-initialConfigFunction on frame with oUF-onlyProcessChildren.
    24. Remove support code for initial-* attributes.
    25. Add a third argument to the style function which indicates if the frame was spawned from a header or not.
    26. Use a less generic name on the template.
    27. Remove double newline.
    28. Add support for Clique.
    29. Add a ReadyCheck element which mostly uses Blizzard's functions.
    30. Add missing commas.
    31. Use the correct function for event registration.
    32. Remove double newline.
    33. Remove 3.3.x support code.
    34. Fix the sub-frames to work correctly, and some other stuff.
    35. Don't style the main object spawned by a header if the attribute 'oUF-onlyProcessChildren' is defined.
    36. Access unit through self.__owner in the frequent update function.
    37. It's deficit, not defict.
    38. Switch license back to MIT.
    39. Make party frames work with the latest beta patch.
    40. Actually clean up the generated names.
    41. Remove local.
    42. Allow powerType to be nil so the soul shard element is correctly updated on login.
    43. Allow powerType to be nil so holy power is correctly updated on login.
    44. Allow powerType to be nil so happiness is correctly updated at login.
    45. Use element and not self in ForceUpdate on the happiness element.
    46. Add powerType to the argument list of happiness.
    47. Use element and not self in ForceUpdate on the holy power element.
    48. Correctly set ForceUpdate for Raid Icons.
    49. Add missing function argument.
    50. Add missing :ForceUpdate() function to Happiness.
    51. Check that the powertype is SOUL_SHARDS before updating.
    52. Fix :ForceUpdate().
    53. Check for holy power before updating.
    54. Fix the copy/paste error.
    55. Tail calls!
    56. Fix :ForceUpdate().
    57. Run a round of sed.
    58. Run a round of sed.
    59. Less defensive coding.
    60. Make :ForceUpdate() actually work.
    61. Tail call post update because we can.
    62. Run a round of sed.
    63. Remove the fallback variable and assert.
    64. Load the heal prediction element.
    65. Use UNIT_CONNECTION to refresh [status] and [offline].
    66. Use UNIT_CONNECTION to update connected state.
    67. Register UNIT_CONNECTION on CC to improve disconnected state.
    68. Rename __parent to __owner.
    69. Add :ForceUpdate() to Threat.
    70. Add :ForceUpdate() to Runes.
    71. Add :ForceUpdate() to RaidIcon.
    72. Add :ForceUpdate() to Resting.
    73. Add :ForceUpdate() to PvP.
    74. Remove unit argument from :ForceUpdate().
    75. Remove unit argument from :ForceUpdate().
    76. Remove unit argument from :ForceUpdate().
    77. Add :ForceUpdate() to Portrait.
    78. Add :ForceUpdate() to MasterLooter.
    79. Add :ForceUpdate() to LFDRole.
    80. Add :ForceUpdate() to Leader.
    81. Add :ForceUpdate() to Power.
    82. Add :ForceUpdate() to Health.
    83. Use the correct variable.
    84. Add :ForceUpdate() to Happiness.
    85. Add :ForceUpdate() to CPoints.
    86. Remove unit argument from :ForceUpdate().
    87. Add :ForceUpdate() to Combat.
    88. Fix syntax error.
    89. Add :ForceUpdate() to Castbar.
    90. Remove use of :GetParent().
    91. Add :ForceUpdate() to Auras.
    92. Add :ForceUpdate() to Assistant.
    93. Remove validation of parents and remove :GetParent() usage.
    94. Complain when the health statusbar is incorrectly parentend.
    95. Complain when the power statusbar is incorrectly parented.
    96. Clean up the generated names some.
    97. Change :SpawnHeader() to work on both live and beta.
    98. Remove unnecessary variable check.
    99. Now with two less syntax errors.
    100. Continue to support UNIT_HAPPINESS on live.
    101. Use UNIT_POWER instaed of UNIT_HAPPINESS.
    102. Use UNIT_POWER instaed of UNIT_HAPPINESS.
    103. Use UNIT_POWER and UNIT_MAXPOWER.
    104. Use UNIT_POWER and UNIT_MAXPOWER.
    105. Use UNIT_POWER instead of UNIT_HAPPINESS.
    106. Possible solution to the new initialConfigFunction requirements.
    107. Remove the runeMap code as it currently does nothing.
    108. Update Threat to the new override method.
    109. Update RaidIcon to the new override method.
    110. Update Resting to the new override method.
    111. Update PvP to the new override method.
    112. Update Power to the new override method.
    113. Update Portrait to the new override method.
    114. Update MasterLooter to the new override method.
    115. Update LFDRole to the new override method.
    116. Update Leader to the new override method.
    117. Update Health to the new override method.
    118. Update Happiness to the new override method.
    119. Update CPoints to the new override method.
    120. Update Combat to the new override method.
    121. Update Assistant to the new override method.
    122. Don't check for custom Update functions on elements.
    123. Kill :UpdateElement().
- _yaroot (1):_
    1. Add unitsuffix to the unit.
- 30 files changed, 1055 insertions(+), 293 deletions(-)

**Changes in 1.4.3:**

- _Trond A Ekseth (3):_
    1. Bump TOC version to 1.4.3.
    2. Convert SecureButton_GetUnit()'s playerpet return into pet.
    3. Add highlight for stealable buffs.
- 3 files changed, 24 insertions(+), 1 deletion(-)

**Changes in 1.4.2:**

- _Trond A Ekseth (5):_
    1. Bump TOC version to 1.4.2.
    2. Remove leftover code from the previous aura system.
    3. Continuation of previous commit.
    4. Prevent Auras from accidently overwriting buffs with debuffs.
    5. Revert "Make aura filters not prematurely break out of the update routine."
- 2 files changed, 9 insertions(+), 7 deletions(-)

**Changes in 1.4.1:**

- _Trond A Ekseth (11):_
    1. Bump TOC version to 1.4.1.
    2. Make the suffix matching greedy, so it doesn't match it's own symbol on the prefix.
    3. Correctly remove frequent update references when calling :Untag().
    4. Make aura filters not prematurely break out of the update routine.
    5. Fix the castingbar sheild not showing correctly at times.
    6. Fix invalid type checks.
    7. Now with even less copy/paste fail.
    8. Damn copy paste.
    9. Pop an error if the parent isn't `self`.
    10. Pop an error if the parent isn't `self`.
    11. Expose the error function.
- 7 files changed, 20 insertions(+), 7 deletions(-)

**Changes in 1.4:**

- _Adirelle (3):_
    1. Have the aura tooltip update itself using .UpdateTooltip callback.
    2. Fully refresh frame on vehicle event even if the modified unit hasn't changed.
    3. Fully refresh frame on vehicle event even if the modified unit hasn't changed.
- _Adrian L Lange (1):_
    1. Add a fallback texture to cpoints if its a texture.
- _Bastian Hoyer (2):_
    1. When Update is called by PARTY_MEMBER_ENABLE the unit parameter is sometimes nil. That caused UnitIsUnit to bug.
    2. elements/combat.lua was missing the header for embedded oUF
- _Trond A Ekseth (104):_
    1. Bump TOC version to 1.4.
    2. Fix the frequent updates OnUpdate cache, so it doesn't create a new updater for every eventless tag.
    3. Fix the drycode errors in the factory system.
    4. Swoosh, one less double newline.
    5. Fix the party condition to not work in raids.
    6. One less typo.
    7. Multitasking is hard :(.
    8. Make the range element use it's own table, instead of iterating over .objects.
    9. Add .IterateStyles().
    10. Add :{Enable,Disable}Factory().
    11. Add :Factory() for delayed spawning of frames.
    12. Properly set the difference between buffs and debuffs again.
    13. Remove text support in CPoints.
    14. Kill the status text and todo list.
    15. Fix the post-calls on the castbar and make the interrruptible ones work even without a CB shield.
    16. Add support for spacing-{x,y} on aura icon position.
    17. Update combo points on PLAYER_TARGET_CHANGED.
    18. Use PLAYER_TARGET_CHANGED on [cpoints] since it fires slightly faster than UNIT_TARGET.
    19. Update [cpoints] to work for vehicles and make it work when it isn't located on the player frame.
    20. Fix [perhp] and [perpp].
    21. Manually merge becc45bccf9805e7c053729ca2e04e38b2d78917, edit and fix errors.
    22. Use UnitIsUnit for the pet check.
    23. Add happiness tag.
    24. Comment out the XML header example.
    25. Needless defensive coding, yay!
    26. Fix broken update logic for unitless events.
    27. Remove a depricated comment.
    28. Add some missing unitless events.
    29. Disable the PlayerFrame first so we can actually register new events on it.
    30. Remove logic leftovers.
    31. Disable the party frames based on the attribute and not visibility.
    32. Possibly work around the "unit stuck as question mark bug".
    33. Correctly unregister UNIT_HEALTH.
    34. Use the party unit now that we have it.
    35. Deprecate initial-* stuff in the metatable.
    36. Remove the alpha trick.
    37. Move some of the variable initialization above the execution of the style function.
    38. Use the GUID instead of the name.
    39. Don't trust the rune duration to match across readiness.
    40. Don't trust the rune duration to match across readiness.
    41. Oh hi, it's 2010.
    42. Print less.
    43. Generate frame names for that aren's assigned one.
    44. Send party/raid as unit to the style function based on the showParty/showRaid attributes.
    45. Move some code around.
    46. Merge :SetManyAttributes into :SpawnHeader (again).
    47. Improve :DisableBlizzard slightly.
    48. Disable the party frames if 'party' is in the visibility list for headers.
    49. Fix syntax error in vehicle.
    50. Fix syntax error in vehicle.
    51. Allow custom states on the headers.
    52. Remove some debug output now that it's been tested.
    53. Simplify the visibility toggle for headers.
    54. Expose self.colors as _COLORS and remove _CLASS_COLORS.
    55. Overhaul most of the tag system.
    56. Allow ColorGradient to exist in the oUF namespace as well.
    57. Move the division by zero check up a bit we can return with less work done.
    58. Remove the function wrapper for some of the simpler tags.
    59. Simplify the pattern.
    60. Unmangle most of the tag functions.
    61. Change the tag syntax to be more robust.
    62. Change :SetManyAttributes() to be 'safer' by making sure the showX attributes are set last.
    63. Revert "Merge :SetManyAttributes into :SpawnHeader so we actually get to set attributes before the state drive shows the header."
    64. Let Blizzard handle updating of PlayerFrame.unit so we don't taint the UI into oblivion.
    65. Don't expose the internal metatable anymore.
    66. Update the arguments on the Post functions.
    67. Add the interruptible shield fluff.
    68. Merge :SetManyAttributes into :SpawnHeader so we actually get to set attributes before the state drive shows the header.
    69. Remove excess arguments in CreateIcon.
    70. Change the rune Update function to update all runes.
    71. Remove un-used variable.
    72. Convert a variable over to a string.
    73. Port the threat element over to the new system.
    74. Split the status element into resting and combat, and port them over to the new system.
    75. Port the raid icon element over to the new standard.
    76. Port the PvP element over to the new standard.
    77. Port the portrait element over to the new standard.
    78. Port the master looter element over to the new standard.
    79. Port the LFD element over to the new standard.
    80. Change the syntax of the LFD element to match the rest of oUF.
    81. Port the party leader element over to the new standard.
    82. Port the happiness element over to the new standard.
    83. Port over the assistant element to the new standard.
    84. Remove cruft from the rune element.
    85. Port over the aura element to the new standard.
    86. Port combo points over to the new standard, and remove the whole cpoints unit crap.
    87. Meh...
    88. Port the castbar element over to the new standard.
    89. Change {Enable,Disable,Update}Element to work with the new way to override update functions.
    90. Port the power element over to the new standard.
    91. Only allow oUF to use oUF as global.
    92. Port the health element over to the new standard.
    93. Add a quick tail call.
    94. Rename PLAYER_ENTERING_WORLD to UpdateAllElements.
    95. Remove oUF.ColorGradient.
    96. Always activate the visibility state drive.
    97. Rename the attributes that toggle visibility as the outcome can conflict with what the layout wants to display.
    98. Fix a typo.
    99. Remove highlight comment.
    100. Complete :SpawnHeader.
    101. Split :Spawn into :Spawn and :SpawnHeader.
    102. Fix a typo.
    103. Update and expose the function used to disable the blizzard unit frames.
    104. Remove 3.2 support code.
- _freebaser (1):_
    1. OCD combat TexCoord
- 25 files changed, 1104 insertions(+), 892 deletions(-)

**Changes in 1.3.28:**

- _Trond A Ekseth (2):_
    1. Bump TOC version to 1.3.28.
    2. Let Blizzard handle updating of PlayerFrame.unit so we don't taint the UI into oblivion.
- 3 files changed, 7 insertions(+), 7 deletions(-)

**Changes in 1.3.27:**

- _Adirelle (4):_
    1. Simplified vehicle switch again.
    2. Use gsub instead of table lookup to get master units.
    3. Update .realUnit on vehicle switch.
    4. Attempt at simplifying vehicle switching.
- _Trond A Ekseth (27):_
    1. Bump TOC version to 1.3.27.
    2. Don't allow external add-ons to set the global to oUF if oUF is present and loaded.
    3. Use UnitPower instead of UnitMana.
    4. Check the unitsuffix for target as well.
    5. Re-add Adirelle's event check as it prevents double updates.
    6. Change the PEW update to a tail call.
    7. Don't enable the vehicle element on target.
    8. Expose our update function so hidden units get updated on OnShow.
    9. Change syntax style to match the rest of oUF.
    10. Change syntax style to match the rest of oUF.
    11. Remove failspaces.
    12. Always lower the unit variable in :Spawn.
    13. Update the ClassColors code to handle the fact that oUF might now have a global.
    14. Remove most of the local cache of globals.
    15. Move the health color into the health element.
    16. Move the power colors into the power element.
    17. Use the max value for disconnected units.
    18. Fix that tab-completion error...
    19. Use the max value for disconnected units.
    20. Use UnitPower instead of UnitMana.
    21. Fix the copy/paste error for child units on exit.
    22. Make some fixes to the vehicle swapping so it doesn't bug out into oblivion.
    23. Correctly update the Blizzard buff frames unit.
    24. Experimental vehicle support based around toggleForVehicle.
    25. Update the print function.
    26. Kill the boss frames and set a onupdate on the boss object.
    27. Remove redundant check in the OnEvent handler.
- 6 files changed, 96 insertions(+), 82 deletions(-)

**Changes in 1.3.26:**

- _Trond A Ekseth (6):_
    1. Bump TOC version to 1.3.26.
    2. Add the missing arguments returned by UnitAura.
    3. Work around the alpha resetting crapness of playermodels.
    4. Use the alternative power color if it's available (and we have no color for that token).
    5. Don't go through the event system to update the power while using frequent updates.
    6. Register the UNIT_HEALTH event on party frames, even if we have frequent updates enabled.
- 5 files changed, 50 insertions(+), 42 deletions(-)

**Changes in 1.3.25:**

- _Hendrik Leppkes (1):_
    1. Add LFD Role element to show the current role of your party members in a LFD Dungeon.
- _Trond A Ekseth (12):_
    1. Bumping TOC version to 1.3.25.
    2. Sleep deprivation? Not at all.
    3. Correctly update the runes when they are reset by abilities.
    4. Add 1.4 note.
    5. Missed a tag update point.
    6. Don't use :EnableElement().
    7. Break out of the event UnregisterEvent loop as soon as we've removed the event.
    8. Don't use ipairs where we don't have to.
    9. Properly disable elements that don't have a update function.
    10. Make tags use the color table on the parent and not the one in the oUF global.
    11. Set a statusbar texture if it doesn't exist.
    12. Remove the 3.2 support code.
- 22 files changed, 113 insertions(+), 313 deletions(-)

**Changes in 1.3.24:**

- _Trond A Ekseth (2):_
    1. Bumping TOC version to 1.3.24.
    2. Don't have local lookup for colors as people like to swap table references.
- 2 files changed, 4 insertions(+), 4 deletions(-)

**Changes in 1.3.23:**

- _Trond A Ekseth (2):_
    1. Bumping TOC version to 1.3.23.
    2. Artificially set the runebar colors at login.
- 2 files changed, 6 insertions(+), 4 deletions(-)

**Changes in 1.3.22:**

- _Hendrik Leppkes (1):_
    1. Fix Target of Target Frame for 3.3
- _Trond A Ekseth (18):_
    1. Bumping TOC version to 1.3.22.
    2. Merge Zariel's code with Blizzard's.
    3. Fix a case were sorting auras would result in spacing.
    4. So much for trying to avoid another level of metatables!
    5. Make the ClassColor updater work for embedded oUF versions.
    6. Move frame only functions away from the oUF table.
    7. Use slightly more tail calls.
    8. Add (Pre|Post)UpdatePortrait().
    9. Expose what style the oUF object was created by.
    10. Check perc against itself, because we rely on the fact that NaN can't equal NaN.
    11. Check harder for invalid values in the color gradient function.
    12. Uhm, yes.
    13. Remove the divison by zero check, because... it's moved :D
    14. Translate divison by zeros into 1 in the ColorGradient function.
    15. Yes... Suddenly the 3.3 version works again.
    16. Make it work on 3.2 and 3.3!
    17. Put new addon namespace to good use Conflicts:
    18. Add the event var to some PEW calls.
- _Zariel (4):_
    1. Fix reload getting the color
    2. Fix runebar color
    3. Revert that fix
    4. Fix OnShow not calling PEW correctly
- 20 files changed, 601 insertions(+), 299 deletions(-)

**Changes in 1.3.21:**

- _Trond A Ekseth (3):_
    1. Bumping TOC version to 1.3.21.
    2. Correct logic for detecting conversion units and invalid units for children frames.
    3. Add children to the units table as well.
- _Zariel (1):_
    1. Whirly bird of options, up and down with a custom order
- 3 files changed, 45 insertions(+), 16 deletions(-)

**Changes in 1.3.20:**

- _Trond A Ekseth (6):_
    1. Bump the TOC version to 1.3.20.
    2. Allow headers to have unitsuffixes of multiple target's target.
    3. Remove support for .runes as it wasn't working in the first place.
    4. Make the event registrator correctly work with tags that contain symbols.
    5. Make some minor changes to Zariel's patch.
    6. Change interupt to interrupt.
- _Zariel (7):_
    1. Sed ftw
    2. Dont capitalize that
    3. Fix consistancy
    4. Fix update
    5. Interupts why?
    6. Remove unsued var
    7. Only update the updated runes colour
- 5 files changed, 32 insertions(+), 24 deletions(-)

**Changes in 1.3.19:**

- _Trond A Ekseth (15):_
    1. Bump TOC version to 1.3.19.
    2. Set the OnUpdate on the rune frame, and not the oUF object.
    3. Add a multiplier field to the color on the bar bg.
    4. Break out of the loop early if we need to update.
    5. Add a TODO comment.
    6. Add some comments for Zariel.
    7. Remove unused variables.
    8. Let the layout create the actual bars.
    9. Inject our colors into the table in the core.
    10. Actually use the local we set.
    11. Minor syntax changes.
    12. Remove unused variables.
    13. Only allow colors as arrays.
    14. Properly unregister the runebar events when the element is disabled.
    15. Only allow colors as arrays.
- _Zariel (4):_
    1. Add some usage
    2. Run OnUpdate for each bar
    3. Fix typos and remove uneeded BG setup
    4. Set color at PEW, add comments, clean up
- 2 files changed, 53 insertions(+), 81 deletions(-)

**Changes in 1.3.18:**

- _Trond A Ekseth (1):_
    1. Bump TOC version to 1.3.18.
- _Zariel (2):_
    1. Fix min max values
    2. Remove unneeded check
- 2 files changed, 3 insertions(+), 3 deletions(-)

**Changes in 1.3.17:**

- _= (2):_
    1. Hide original frame
    2. Runebarlol
- _Trond A Ekseth (14):_
    1. Bump TOC version to 1.3.17.
    2. Update TOC Interface version to 30200.
    3. Add :PreAuraSetPosition(auras, max).
    4. Properly set OnUpdate and OnEvent on headers with playertarget and playerpet units.
    5. Some more indent changes.
    6. Make [missingpp] return nil instead of zero.
    7. Make [missinghp] return nil instead of zero.
    8. Change the indentation on the pre-defined tags.
    9. Change GetDifficultyColor to GetQuestDifficultyColor in the difficulty tag.
    10. No longer escape the escaped!
    11. Add a [defict:name] tag, which I stole from Shadowed.
    12. Use the correct index on the [group] tag.
    13. Might want to actually load it too.
    14. Add an assistant modulem. Based on jyuny1's code.
- 7 files changed, 329 insertions(+), 38 deletions(-)

**Changes in 1.3.16:**

- _Trond A Ekseth (13):_
    1. Bump TOC version to 1.3.16.
    2. Drop out early if loot method is set to master, but we aren't actually in a party anymore.
    3. Remove an empty line (not OCD!)
    4. Not enough tails.
    5. [group] tag improvements from Shadowed!
    6. Add a [group] tag.
    7. Slightly less 3AM English.
    8. Work around elements disabling themselves during the update.
    9. That was slightly too strict.
    10. Add a retard check to the element functions.
    11. Use the correct variable to check for the OnUpdate.
    12. Make frequentUpdate on tags run on seperate timers.
    13. Update the license.
- 6 files changed, 69 insertions(+), 44 deletions(-)

**Changes in 1.3.15:**

- _Trond A Ekseth (6):_
    1. Bump TOC version to 1.3.15.
    2. Add CancelUnitBuff to auras on player units.
    3. Make tags use the internal colors instead of RAID_CLASS_COLORS.
    4. Add support for !ClassColors.
    5. Remove the unit specific events that aren't needed.
    6. Don't expose the style function on header units.
- 4 files changed, 37 insertions(+), 17 deletions(-)

**Changes in 1.3.14:**

- _Trond A Ekseth (8):_
    1. Bump TOC version to 1.3.14.
    2. Add :PostCastStop to the castbar OnUpdate.
    3. Add :PostChannelStop to the castbar OnUpdate.
    4. Make sure that we have a valid reaction return before we try to set it as the health color.
    5. Make sure that we have a valid reaction return before we try to set it as the power color.
    6. Make the cooldown on the aura icons optional.
    7. Fix issues with events not being correctly removed when untagging tags.
    8. Don't create more icons than we actually need on the Auras element.
- 6 files changed, 42 insertions(+), 20 deletions(-)

**Changes in 1.3.13:**

- _Trond A Ekseth (2):_
    1. Bump TOC version to 1.3.13.
    2. Quick fix to the border issue introduced in the previous revision.
- 2 files changed, 5 insertions(+), 1 deletion(-)

**Changes in 1.3.12:**

- _Trond A Ekseth (3):_
    1. Bump TOC version to 1.3.12.
    2. Always return true if the icon has a name.
    3. Avoid nil calls to the custom aura filter function.
- 2 files changed, 29 insertions(+), 26 deletions(-)

**Changes in 1.3.11:**

- _Trond A Ekseth (2):_
    1. Bump TOC version to 1.3.11.
    2. Remove PTR support code and make auras work correctly when onlyShowPlayer is active.
- 2 files changed, 4 insertions(+), 8 deletions(-)

**Changes in 1.3.10:**

- _Trond A Ekseth (2):_
    1. Bump TOC version to 1.3.10.
    2. Don't error when the unit isn't on the threat table.
- 2 files changed, 2 insertions(+), 2 deletions(-)

**Changes in 1.3.9:**

- _Hendrik Leppkes (2):_
    1. Don't have to run that code all the time, just when unit changes.
    2. Updated vehicle switch to work in combat using the restricted environment
- _Trond A Ekseth (6):_
    1. Bump the TOC version to 1.3.9.
    2. Set interface version to 3.1.
    3. Move stuff around.
    4. Make onlyShowPlayer work as intended on 3.1.
    5. Add :CustomAuraFilter and prepare for 3.1.
    6. Remove the :UpdateTag() function when we Untag a fontstring.
- 4 files changed, 87 insertions(+), 54 deletions(-)

**Changes in 1.3.8:**

- _Hendrik Leppkes (3):_
    1. Fix the debuff offset when updating icons in "Auras" mode.
    2. Fix a bug that counted buffs as debuffs and vice versa.
    3. Add "disableCooldown" option to aura element that hides the cooldown spiral if set to true.
- _Tekkub (1):_
    1. Fix the [plus] tag.
- _Trond A Ekseth (14):_
    1. Bump the TOC version to 1.3.8.
    2. Use next in some iterators.
    3. Use the internal table for reaction coloring.
    4. Re-add colors.reaction.
    5. Hopefully the last fix to the portraits.
    6. Happy new year!
    7. Take another stab at the portrait.
    8. Check if the name has changed before we update portraits.
    9. Fix a syntax error.
    10. Replace all the ipairs().
    11. Allow frequentUpdates on tags to set a lower OnUpdate timer.
    12. Add .colorClassPet to Power.
    13. Add .colorClassPet to Health.
    14. Add missing events to the power tags.
- 8 files changed, 53 insertions(+), 31 deletions(-)

**Changes in 1.3.7:**

- _Trond A Ekseth (2):_
    1. Bump version to 1.3.7.
    2. Fix syntax error.
- 2 files changed, 2 insertions(+), 2 deletions(-)

**Changes in 1.3.6:**

- _Trond A Ekseth (1):_
    1. Bump version to 1.3.6.
- _evl (1):_
    1. Reworked vehicle swapping.
- 3 files changed, 39 insertions(+), 87 deletions(-)

**Changes in 1.3.5:**

- _Trond A Ekseth (6):_
    1. Bump version to 1.3.5.
    2. Properly block events without handlers from registering.
    3. Validate that we have a channel before we continue.
    4. Add .isPlayer to the aura icons.
    5. Remove un-used variable.
    6. Allow the castbar to work on eventless units.
- 4 files changed, 25 insertions(+), 19 deletions(-)

**Changes in 1.3.4:**

- _Trond A Ekseth (9):_
    1. Bump version to 1.3.4.
    2. Validate that the unit has a vehicle UI before we swap the units.
    3. Strip away raid and party support on vehicles.
    4. Use the correct variables in :PostChannelUpdate.
    5. Use the correct variables in :PostChannelStart.
    6. Use the correct variables in :PostCastDelayed.
    7. Use the correct variables in :PostCastStart.
    8. Move the frequent update flag to the fontstring
    9. Add missing events to some tags.
- 4 files changed, 40 insertions(+), 45 deletions(-)

**Changes in 1.3.3:**

- _Trond A Ekseth (3):_
    1. Bump version to 1.3.3
    2. Make the unit swapping work when leaving a vehicle in combat.
    3. Make appends work on tags.
- 4 files changed, 11 insertions(+), 7 deletions(-)

**Changes in 1.3.2:**

- _Trond A Ekseth (45):_
    1. Fix [smartlevel].
    2. Seems like we missed one.
    3. Update internal tag references.
    4. Hack to fix the vehicles.
    5. Correctly hide the master loot icon when the player leaves the group.
    6. Make master loot work in raids.
    7. Remove the events we don't need for masterlooter.
    8. Untag the previous tag if people try to double tag.
    9. Fix event registration on tags.
    10. Add .frequentTagUpdates to force OnUpdate polling.
    11. Drop out early if we should in the tags.
    12. Dry-code improvements to masterlooter.
    13. Don't allow nil units on threat.
    14. Force an update to the default auras.
    15. Update comments in tags
    16. Update comments on tags.
    17. Actually print an error on invalid tags.
    18. Make argcheck not error.
    19. Minor clean up and saner variables.
    20. Let's stay at 1.3 for now.
    21. Update comments on tags.
    22. Update documentation on power.
    23. Add some minor castbar documentation.
    24. Update documentation on auras.
    25. Update documentation on auras.
    26. Add missing event to [cpoints].
    27. Slight improvement.
    28. More horrid changes.
    29. Pure madness...
    30. Don't update hidden fontstrings.
    31. Bump the version to 1.3.2
    32. Make the leader icon work on units inside our raid.
    33. Add the missing texcoord.
    34. Call the correct function in status.lua
    35. Clean up the mess that was masterlooter.
    36. Add TOC entry for MasterLooter.
    37. Import p3lims code.
    38. Too tired...
    39. Add fallback texture to Resting and Combat.
    40. Convert player(pet|taget) into (pet|target).
    41. Some mone argument validation.
    42. Add [cpoints].
    43. Correctly set PlayerFrame.unit when entering a vehicle.
    44. Fix syntax error.
    45. Kill the pet casting bar if we spawn a pet unit.
- 12 files changed, 274 insertions(+), 70 deletions(-)

**Changes in 1.3.1:**

- _Tekkub (1):_
    1. More fixes for player level
- _Trond A Ekseth (3):_
    1. Bump version to 1.3.1.
    2. Check if we should set :SetAuraPosition or not.
    3. Add missing unit argument in status.
- 5 files changed, 9 insertions(+), 6 deletions(-)

**Changes in 1.3:**

- _Tekkub (1):_
    1. Track PLAYER_LEVEL_UP for [level] tag
- _Trond A Ekseth (35):_
    1. Move the vehicle element to it's own file.
    2. Support __unit in tags.
    3. Experimental vehicle swapping.
    4. Remove dupe code.
    5. Revert "Allow unit overriding on tags."
    6. Allow unit overriding on tags.
    7. Create the .__elements table before we run the style function.
    8. Handle UnitName returning nil in the tag system.
    9. Add missing self.
    10. Make sure the safe zone has correct height.
    11. Axe the element system.
    12. Some minor fixes.
    13. Minor changes.
    14. Experimental event changes.
    15. Rename the var for the frame metatable.
    16. :(
    17. Sneaky sneaky!
    18. Clean up auras.
    19. Remove block in auras.
    20. Fix faulty logic.
    21. Added :CustomDelayText() and :CustomTimeText().
    22. Remove icons.onlyShowDuration and add icons.onlyShowPlayer.
    23. Properly nil out the casting state.
    24. Fix a typo.
    25. Bump version to 1.3.
    26. Remove .Name.
    27. Tag system redone.
    28. Remove double call in power.lua.
    29. Remove double call in health.lua.
    30. Add safe zone on channeled spells.
    31. Revert "Don't allow custom raid headers as it just confuses people."
    32. Don't allow custom raid headers as it just confuses people.
    33. Move the HandleUnit check to the correct position.
    34. Bump version to 1.2.2.
    35. Use the new castid.
- 18 files changed, 763 insertions(+), 385 deletions(-)

**Changes in 1.2.1:**

- _Trond A Ekseth (8):_
    1. Update the TOC interface version while we're at it.
    2. Possibly the end cpoint solution.
    3. Remove all 3.0 checks.
    4. Handle dtype being an empty string.
    5. Add .Health.colorHealth.
    6. Bump version to 1.2.1.
    7. Removet the variable requirement for model based portraits.
    8. Add fallback texture to threat.
- 8 files changed, 42 insertions(+), 108 deletions(-)

**Changes in 1.2:**

- _Trond A Ekseth (5):_
    1. Add fallback textures to the castbar.
    2. Prevent the castbar from hiding itself when targeting a casting unit.
    3. Bump version to 1.2.
    4. Add support for (multiple) suffix units on headers.
    5. Bump version to 1.1.5.
- 4 files changed, 155 insertions(+), 94 deletions(-)

**Changes in 1.1.4:**

- _Trond A Ekseth (3):_
    1. Fix castbar spark.
    2. Fix the [sex] tag.
    3. Bump version to 1.1.4.
- 4 files changed, 4 insertions(+), 4 deletions(-)

**Changes in 1.1.3:**

- _Trond A Ekseth (5):_
    1. Revert "Fix safe zone."
    2. Revert "And the battle RAGES on!"
    3. Bump version to 1.1.3.
    4. Hide the castbar when we aren't casting.
    5. Add missing comma in castbar code.
- 3 files changed, 7 insertions(+), 7 deletions(-)

**Changes in 1.1.2:**

- _Trond A Ekseth (11):_
    1. Make unit reaction work on beta.
    2. Increase version to 1.1.2.
    3. And the battle RAGES on!
    4. Add object :Enable() and :Object() disable.
    5. Fix safe zone.
    6. Should actually work now.
    7. Make sure we set the correct duration when we target a casting unit.
    8. Shorten the name of the tags file.
    9. Remove empty line.
    10. Button smasher friendlyness.
    11. Redo the castbar arithmetics.
- 7 files changed, 79 insertions(+), 55 deletions(-)

**Changes in 1.1.1:**

- _Tekkub (22):_
    1. Get rid of the string.sub calls
    2. More tags
    3. Seems party frames don't have a unit on creation, so lets just use the base frame's .unit value
    4. Typo
    5. First batch of converted tags... I'm taking a break
    6. Shove our tables into the oUF object so people can add custom tags easily
    7. Add stupid comment blocks
    8. Fix space compactor
    9. Flesh out event registration
    10. Add taggedstring to XML loader
    11. Remove testey stuffs
    12. Tweak gsubber design, calling string.gsub is so WoW 2.0
    13. Bring in Zariel's tags
    14. Move tagger into modules
    15. Super simple tag parser.  Pulled in the old WatchDog tags.  Doesn't actually do anything yet.
    16. Typo
    17. Allow HP bars to be class-colored for NPCs also
    18. Screw all the fancy shit, we're just gonna do a texture for threat
    19. Hide threat bits on init
    20. Forgot to rename a few vars
    21. Flesh out threat module, totally drycoded
    22. Add threat module placeholder
- _Trond A Ekseth (31):_
    1. Use a shorter path to get the parent.
    2. Use the correct metadata var.
    3. Make sure we use the correct global in taggedstring.
    4. Use the correct object reference.
    5. 2006 called, they want their XML back.
    6. The unit can be nil according to blizzards code.
    7. Might want to use the correct local to create a global reference.
    8. Allow parenting oUF.
    9. Rename .safezone to .SafeZone, but retain compat.
    10. Prevent the threat module from loading on 2.4.
    11. Remove check for self.Threat on updates.
    12. Allow power bars to be class-colored for NPCs also.
    13. Minor fix to the docs.
    14. Seems I missed quite a lot of the documentation.
    15. Add a missing entry in the aura docs.
    16. Only show the leader icon for your own party.
    17. Stricter validation of the happiness object.
    18. Stricter validation of the raid icon object.
    19. Use UNIT_MAXMANA instead of UNIT_MANA.
    20. Bump version to 1.1.1.
    21. Add a fallback texture to leader if it is a texture.
    22. Add a fallback texture to raid icons.
    23. Add a fallback texture to happiness.
    24. Add a fallback texture to health.
    25. Add a fallback texture to power.
    26. Add a multiplier to the health background.
    27. Only validate that we have b(lue).
    28. Add a multiplier to the power background.
    29. Only validate that we have b(lue).
    30. The frequent update on power is no longer hardcoded.
    31. Fix a typo.
- 17 files changed, 407 insertions(+), 44 deletions(-)

**Changes in 1.1:**

- _Tekkub (2):_
    1. Fix power bar for DKs
    2. Fix bug with UnitAura in wrath
- _Trond A Ekseth (61):_
    1. Fix invalid post call in the castbar code.
    2. Hajnal!
    3. Logic is hard on an empty stomach.
    4. That's what I get for not using auto-completion of words.
    5. Hide the focus frame on wotlk.
    6. Shorten the castbar post functions.
    7. More castbare changes.
    8. Fix file modes.
    9. Make the castingbar variables more consistent.
    10. Make compo points work on wotlk.
    11. Add documentation for range.
    12. Add documentation for health.
    13. Add missing entry in docs.
    14. Change local scoping.
    15. Add documentation for power.
    16. Add documentation for auras.
    17. Allow Auras.filter.
    18. Add an extra sanity check to prevent a possible division by zero.
    19. Experimental fix to the frequent health update issue.
    20. Allow frequent power updates on pets.
    21. Add a event handler for UNIT_MAXRUNIC_POWER.
    22. Check the events before we update it.
    23. Make the OnTargetUpdate report itself as an event.
    24. Renamed bar.colors to bar.smoothGradient.
    25. Added bar.colorDisconnected.
    26. Check if .PvP actually exists.
    27. Add callbacks for updating of tapped units.
    28. Check if .Happiness actually exists.
    29. Add callbacks for happiness updating.
    30. Don't darken the color on the health background.
    31. Don't darken the color on the power background.
    32. The Hopeless Pursuit Of Remission...
    33. Yet another copy paste error.
    34. Fix a copy paste error.
    35. .Power now has most of the .Health color types.
    36. Move tapped color to colors.tapped.
    37. Add .visibleBuffs, .visibleDebuffs and .visibleAuras on the aura elements.
    38. Bump version to 1.1.
    39. Allow the registered layout to only be a function.
    40. Revert "Make the initial-* vars "optional"."
    41. Make the initial-* vars "optional".
    42. Fix the health onupdate.
    43. How colors are used is now changed. Added Health.colorTapping. Added Health.colorHappiness. Added Health.colorClass. Added Health.colorReaction. Added Health.colorSmooth. Added support for WotLK built-in QuickHealth. Added support for WotLK predict power (player only).
    44. Fix error in :UNIT_SPELLCAST_CHANNEL_UPDATE().
    45. Add icons.showDebuffType and icons.showBuffType.
    46. Change the argument order on :OverrideUpdatePower and :PostUpdatePower to be consistent with the oUF event handler.
    47. Change the argument order on :OverrideUpdateHealth and :PostUpdateHealth to be consistent with the oUF event handler.
    48. Add icons.showType as both buffs/debuffs have type in beta.
    49. Make the last last debuff show.
    50. Use UnitAura for .Auras and allow extended WotLK filters.
    51. Make the swirly swirl swirl.
    52. Remove the dupe mapping registers.
    53. Remove unused vars.
    54. Make the aura changes work on live and beta.
    55. Make the power changes work on live and beta.
    56. I fail at using macros.
    57. I fail at using macros.
    58. Fixes issues with spell interruptions on the castbar. (cherry picked from commit 3f13c55cf1d6a19292a26b7e6843413f02f2e530)
    59. Fixes issues with spell interruptions on the castbar. (cherry picked from commit 3f13c55cf1d6a19292a26b7e6843413f02f2e530)
    60. Add credit for the original castbar codebase.
    61. Don't set the color on the statusbar.
- _evl (1):_
    1. Added .Spark to castbar.
- 10 files changed, 571 insertions(+), 267 deletions(-)

**Changes in 1.0.4:**

- _Trond A Ekseth (2):_
    1. Bump TOC version to 1.0.4.
    2. Fix error in :UNIT_SPELLCAST_CHANNEL_UPDATE(). (cherry picked from commit 372e0c6b5dd984e5aa33d9b51d6e40ee94cc4db5)
- 2 files changed, 2 insertions(+), 2 deletions(-)

**Changes in 1.0.3:**

- _Trond A Ekseth (4):_
    1. I fail at using macros.
    2. Bumping version to 1.0.3.
    3. Fixes issues with spell interruptions on the castbar.
    4. Add credit for the original castbar codebase. (cherry picked from commit 0b4e7a0cf1ea643c441674ad1e9000e1de85e3cf)
- 2 files changed, 11 insertions(+), 4 deletions(-)

**Changes in 1.0.2:**

- _Trond A Ekseth (3):_
    1. Bumping version to 1.0.2.
    2. Rename .OnCastBarUpdate to .OnCastbarUpdate for consistency.
    3. Added Castbars. Code by tekkub.
- 2 files changed, 215 insertions(+), 1 deletion(-)

**Changes in 1.0.1:**

- _Trond A Ekseth (3):_
    1. Bumping version to 1.0.1
    2. Remove locals so external add-ons can override.
    3. We are stable now. Fetch versions from the TOC.
- 3 files changed, 2 insertions(+), 16 deletions(-)

