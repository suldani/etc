#!/opt/bin/ash
##################################
# 모찌피치 유튜브 다운로더
# v2018.11.02
#---------------------------------
# crontab 등록
# cru a "execute mochi_down" "0 3 * * * /opt/usr/mochid.sh >> /opt/usr/mochid.log 2>&1"
##################################

#환경설정#########################
PLAYLIST="https://www.youtube.com/playlist?list=UUOiM8FuCUFJkuUjCmB14rgg"
TMP_DIR="/opt/usr/tmp_mp"
DOWN_DIR="/tmp/mnt/WD8TB/_AKMU/7-1.Youtube(MochiPeach)"
MAX_DW=1
##################################
YOUTUBE_DL=`which youtube-dl`
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

if [ $# -eq 1 ];then
	ID=$1
	if [ -f "$TMP_DIR/$ID.complete" ]; then
		echo "($ID) File exists."
	else
		echo "($ID) File does not exists."
		$YOUTUBE_DL -f 'bestvideo+bestaudio' -o $DOWN_DIR/'%(upload_date)s_%(title)s.%(ext)s' $ID
		echo "$ID" > $TMP_DIR/$ID.complete
	fi
	exit 1
fi


echo "=========Start=========="
date
echo "Please wait 15 seconds.." 

for ID in `$YOUTUBE_DL --dateafter now-1week --max-downloads $MAX_DW $PLAYLIST --get-id`; do
	echo "Please wait 10 seconds for Infomation [$ID] ..."
	FILE=`$YOUTUBE_DL --get-filename -o '%(upload_date)s_%(title)s.%(ext)s' $ID`

#	if [ -f $DOWN_DIR/$FILE ]; then
	if [ -f "$TMP_DIR/$ID.complete" ]; then
		echo "($ID) File [$FILE] exists."
	else
		echo "($ID) File [$FILE] does not exists. Now Downloading..."
		$YOUTUBE_DL -f 'bestvideo+bestaudio' -o $DOWN_DIR/'%(upload_date)s_%(title)s.%(ext)s' $ID
		echo "($ID) $FILE" > $TMP_DIR/$ID.complete
	fi

	done
date
echo "==========End==========="

exit 1
