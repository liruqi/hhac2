Generate a preview image for a FLV video file, using ffmpeg.

# Example #

$ ffmpeg -y -i input.flv -f image2 -ss 60 -vframes 1 -s 120x90 -an 60.jpg

# Options #

  * **-i** _filename_
> > input file name
  * **-f** _fmt_
> > force format
  * **-ss** _time_
> > timestamp in seconds
  * **-vframes** _number_
> > frame number in the very second
  * **-s** _widthxheight_
> > output image size
  * **-an** _filename_
> > output file name