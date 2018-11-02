#!/bin/bash

# список разрешённых модов в hungergames.club
# 1240565842   Russian translation*          https://steamcommunity.com/sharedfiles/filedetails/?id=1240565842
# 352373173    Gesture wheel*		     https://steamcommunity.com/sharedfiles/filedetails/?id=352373173 
# 873350047    Quick Drop - Client Version   https://steamcommunity.com/sharedfiles/filedetails/?id=873350047 
# 727774324    Craft Pot*		     https://steamcommunity.com/sharedfiles/filedetails/?id=727774324 
# 369420067    Reverse Attack*		     https://steamcommunity.com/sharedfiles/filedetails/?id=369420067 
# 1240505368   KeepMoveOrFollow		     https://steamcommunity.com/sharedfiles/filedetails/?id=1240505368
# 362906105    Sticky Recipe*    	     https://steamcommunity.com/sharedfiles/filedetails/?id=362906105 
# 433644012    Friendship(PvP)               https://steamcommunity.com/sharedfiles/filedetails/?id=433644012 

# мои моды
# aerial-view        PVP, форк версии аериала, когда он ещё позволял использование в pvp-режиме
# local-coordinates  LOCALC, форк coordinates в виде локального мода

# внешние моды
# camera-tweaks      workshop-1161850231, тот же аериал, только лучше
# complete-your-map  workshop-459280938, мод на автодополнение карты всякой всячиной
# quick-emotes       workshop-344071294, эмоции на F1-F12, нравится мне больше, чем Gesture Wheel

DST_MODS_DIR="/home/freehck/.steam/steam/steamapps/common/Don't Starve Together/mods"

install_mod () {
    mod=$1 id=$2 extid=$3
    rm -rf "$DST_MODS_DIR"/workshop-$id
    cp -r $mod "$DST_MODS_DIR"/workshop-$id
    if [ -n "$extid" ]; then
	rm -rf "$DST_MODS_DIR"/workshop-$extid
    fi
}

# установка модов
#install_mod	aerial-view        362906105               # aerial-view -> Sticky Recipe
install_mod	local-coordinates  727774324               # local-coordinates -> Craft Pot
install_mod	camera-tweaks      362906105   1161850231  # camera-tweaks -> Sticky Recipe
install_mod     complete-your-map  352373173   459280938   # complete-your-map -> Gesture wheel
install_mod     quick-emotes       369420067   344071294   # quick-emotes -> Reverse Attack


