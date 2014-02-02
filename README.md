youtube-dl-pl
=============
A bash script wrapper for [Ricardo Garcia's youtube-dl] **great** tool

Description
-----------
**youtube-dl-pl** is a small bash script wrapper for [Ricardo Garcia's youtube-dl] tool

Dependencies
------------
* [Ricardo Garcia's youtube-dl] tool

Prerequisites
-------------
* A perl-ish rename tool eg perl-rename for [Arch] Linux distros
* mp3info tool: a utility used to read and modify the ID3 tags in MPEG layer 3 (MP3) files

Installation
------------
```bash
sudo curl 'https://raw.github.com/drxspace/youtube-dl-pl/master/youtube-dl-pl.sh' -o /usr/local/bin/youtube-dl-pl
sudo chmod a+x /usr/local/bin/youtube-dl-pl
```

Usage
-----
The following two commands download two **awesome** albums of the group [Toundra]
```bash
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
[Arch]:https://www.archlinux.org/
[Toundra]:http://www.youtube.com/user/ToundraOfficial
