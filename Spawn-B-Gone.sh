#!/bin/bash
# Spawn-B-Gone v1.0
# (c) Dec 2019 Kelly Lawrence

#############
# Variables #
#############
bspCount=`ls -1 *.bsp 2>/dev/null | wc -l`
polypTarget="monster_polyp"
polypReplacement="monster_abcde"
spawnTarget="monster_tarbaby"
spawnReplacement="monster_rotfish"

# Check if Perl/Grep is installed
if command -v perl > /dev/null 2>&1 && command -v grep > /dev/null 2>&1
    then

        # See if there are any .bsp files in the current directory
        if [ $bspCount != 0 ]
            then

                # Loop through all map files
                for map in *.bsp ;
                    do

                        # If $spawnTarget reference exists in map file
                        if strings $map | grep "$spawnTarget" > /dev/null 2>&1
                            then

                                # Create a backup of the original map file
                                echo "$spawnTarget found in $map. Creating backup of map file."
                                cp $map $map.bak

                                # Replace $spawnTarget references with $spawnReplacement
                                echo "Replacing $spawnTarget with $spawnReplacement in $map"
                                perl -pi -e 's/'$spawnTarget'/'$spawnReplacement'/g' $map

                        # No $spawnTarget references in $map file
                        else
                            echo "No references of $spawnTarget found in $map"
                        fi
                    done

        # No .bsp files could be found
        else
            echo "No .bsp files could be found in the current directory."
        fi

# Perl and/or Grep is not installed
else
    echo "Please install Perl (https://www.perl.org) and/or GREP (http://gnuwin32.sourceforge.net/packages/grep.htm) to run this script."
fi
