#!/bin/sh
# ##############################################################################################
# https://stackoverflow.com/questions/50594412/cut-multiple-parts-of-a-video-with-ffmpeg
# https://trac.ffmpeg.org/wiki/Concatenate
# http://blog.daum.net/nbdjj1998/83
# ##############################################################################################

path=$(/usr/bin/dirname "$1")
filename=$(/usr/bin/basename "$1")
extension="${filename##*.}"
filename="${filename%.*}"
trimed="${path}"/"${filename}"_trim

STTTIME=$(/bin/date +%Y.%m.%d' '%H:%M:%S)
echo "[$STTTIME] $0 $*" >> ./fm.log

if [ $# -eq 3 ];then
        /opt/bin/ffmpeg -y -threads 2 -i "$1" -ss "$2" -to "$3" -c copy "${trimed}".ts
elif [ $# -eq 5 ];then
        /opt/bin/ffmpeg -y -threads 2 -i "$1" -ss "$2" -to "$3" -c copy "${trimed}".part1.ts
        /opt/bin/ffmpeg -y -threads 2 -i "$1" -ss "$4" -to "$5" -c copy "${trimed}".part2.ts
        /opt/bin/ffmpeg -y -threads 2 -i "concat:${trimed}.part1.ts|${trimed}.part2.ts"                    -c copy "${trimed}".ts
elif [ $# -eq 7 ];then
        /opt/bin/ffmpeg -y -threads 2 -i "$1" -ss "$2" -to "$3" -c copy "${trimed}".part1.ts
        /opt/bin/ffmpeg -y -threads 2 -i "$1" -ss "$4" -to "$5" -c copy "${trimed}".part2.ts
        /opt/bin/ffmpeg -y -threads 2 -i "$1" -ss "$6" -to "$7" -c copy "${trimed}".part3.ts
        /opt/bin/ffmpeg -y -threads 2 -i "concat:${trimed}.part1.ts|${trimed}.part2.ts|${trimed}.part3.ts" -c copy "${trimed}".ts
else
        echo
        echo "************************************************************"
        echo " Usage : $0 FileName [starttime1] [endtime1]"
        echo "         $0 FileName [starttime1] [endtime1] [starttime2] [endtime2]"
        echo "         $0 FileName [starttime1] [endtime1] [starttime2] [endtime2] [starttime3] [endtime3]"
        echo "************************************************************"
	echo "[$STTTIME] Encoding Failure. Please check arguments." >> ./fm.log
        exit
fi

ENDTIME=$(/bin/date +%Y.%m.%d' '%H:%M:%S)
echo
echo "************************************************************"
echo "*** Start Time : $STTTIME ***"
echo "*** E n d Time : $ENDTIME ***"
echo "*** FileName : ${trimed}.ts"
echo "************************************************************"
echo "[$ENDTIME] ${trimed}.ts Encoding Completed." >> ./fm.log
