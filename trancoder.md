# Introduction #

mencoder input.avi -sub input.srt -subcp cp936 -o output.flv -of lavf -oac mp3lame -lameopts abr:br=56 -srate 22050 -ovc lavc -lavcopts vcodec=flv:vbitrate=500:mbd=2:mv0:trell:v4mv:cbp:last\_pred=3

# Details #

input.avi 输入的视频文件

input.srt 输入的srt格式字幕文件

output.flv 输出文件名