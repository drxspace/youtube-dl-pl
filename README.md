youtube-dl-pl
=============
A bash script wrapper for [Ricardo Garcia's youtube-dl] **great** tool

Description
-----------
**youtube-dl-pl** is a small bash script wrapper for [Ricardo Garcia's youtube-dl] tool
that will **download** the video files of a youtube playlist, **convert** them to audio
MPEG layer 3 (MP3) files (VBR 1) and finally **construct** a (M3U) file

Dependencies
------------
* [youtube-dl] tool

Prerequisites
-------------
* `ffmpeg` : a very fast video and audio converter 
* A perl-ish rename tool eg `perl-rename` for [Arch] Linux distros. debian distros
use the rename command.
* `mp3info` : a utility used to read and modify the ID3 tags in MPEG layer 3 (MP3) files

Installation
------------
```bash
sudo curl 'https://raw.github.com/drxspace/youtube-dl-pl/master/youtube-dl-pl.sh' -o /usr/local/bin/youtube-dl-pl
sudo chmod a+x /usr/local/bin/youtube-dl-pl
```

Usage
-----
The following commands download two **awesome** albums of the group [Toundra] inside
the folder `$HOME/Music`
```bash
cd ~/Music
youtube-dl-pl -v -d 'Toundra/Toundra (I)' -m 'Toundra (I)' 'http://www.youtube.com/playlist?list=PLA64899EF7305EFBF'
youtube-dl-pl -v -d 'Toundra/Toundra (II)' -m 'Toundra (II)' 'http://www.youtube.com/playlist?list=PL015CBE02BE2C6ECA'
```

Options
-------
```
  -h			print this help text and exit
  -v			print various debugging information
  -d PATH		create a directory named PATH and put the files in it
  -m [FILE]		create a .m3u playlist file. If the FILE argument is not
				specified and the -d option exists, the m3u filename is similar to
				PATH argument
```

[Ricardo Garcia's youtube-dl]:https://github.com/rg3/youtube-dl
[youtube-dl]:http://rg3.github.io/youtube-dl/download.html
[Arch]:https://www.archlinux.org/
[Toundra]:http://www.youtube.com/user/ToundraOfficial
