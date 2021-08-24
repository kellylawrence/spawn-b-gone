@echo off
@REM # Spawn-B-Gone v1.0
@REM # (c) Oct 2020 Kelly Lawrence

@REM ####################
@REM # Static Variables #
@REM ####################
set dir=%~dp0
set monsterList=monster_armagon monster_army monster_army_rocket monster_bob monster_boss monster_death_guard monster_death_knight monster_death_lord monster_defender monster_demon1 monster_dog monster_dragon monster_drole monster_edie monster_eel monster_eliminator monster_enforcer monster_fish monster_gaunt monster_gremlin monster_gug monster_hell_knight monster_knight monster_lava_man monster_morph monster_mummy monster_ogre monster_ogre_flak monster_ogre_marksman monster_oldone monster_polyp monster_pyro monster_scourge monster_sentinel monster_shalrath monster_shambler monster_super_wrath monster_sword monster_tarbaby monster_vermis monster_voreling monster_wizard monster_wrath monster_zombie trap_spike_mine

@REM ####################
@REM # User Info Prompt #
@REM ####################
@REM # Ask user if they would like to see a list of all monster types
set /P seeMonsterList="Would you like to see a list of all monster types? (y/n) "
if %seeMonsterList%==y (
    echo.
    (for %%a in (%monsterList%) do (
        echo %%a
    ))
    echo.
)

@REM # Prompt user for which monster type they would like to remove
set /P monsterTarget="Which monster type would you like to remove? (Ex: monster_knight) "

@REM # Swap `monster_` prefix with `removed_`
if "%monsterTarget%"=="trap_spike_mine" (
    set monsterReplacement=%monsterTarget:trap_sp=removed%
) else (
    set monsterReplacement=%monsterTarget:monster=removed%
)

@REM #######################
@REM # Start map file edit #
@REM #######################
@REM # See if there are any .bsp files in the current directory
if exist %dir%*.bsp (

    @REM # Loop through all map files
    set count=0
    for /R %dir% %%s in (*.bsp) do (

        @REM # Check for %spawnTarget% references in map file
        findstr /r %monsterTarget% %%s > NUL

        @REM # No %spawnTarget% references in map file
        if errorlevel 1 (
            echo "No references of %monsterTarget% found in %%s"

        @REM # If %spawnTarget% reference exists in map file
        ) else (

            @REM # Create a backup of the original map file
            echo "%monsterTarget% found in %%s. Creating backup of map file."
            copy %%s %%s.bak

            @REM # Replace %spawnTarget% references with %spawnReplacement%
            echo "Replacing %monsterTarget% with %monsterReplacement% in %%s"
            powershell -Command "((Get-Content -path %%s -Raw) -replace '%monsterTarget%','%monsterReplacement%') | Set-Content -Path %%s"

        )
    )

rem # No .bsp files could be found
) else (
    echo "No .bsp files could be found in the current directory."
    exit /b
)
