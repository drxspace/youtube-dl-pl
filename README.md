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
