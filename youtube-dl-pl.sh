#!/bin/bash
#
# _________        ____  ____________         _______ ___________________
# ______  /__________  |/ /___  ____/________ ___    |__  ____/___  ____/
# _  __  / __  ___/__    / ______ \  ___  __ \__  /| |_  /     __  __/
# / /_/ /  _  /    _    |   ____/ /  __  /_/ /_  ___ |/ /___   _  /___
# \__,_/   /_/     /_/|_|  /_____/   _  .___/ /_/  |_|\____/   /_____/
#                                    /_/           drxspace@gmail.com
#
#set -e

# switch to debugging mode
DEBUG=

# quiet mode is the default mode
VERBOSE=0

# the directory that may host the mp3 files
DIRECTORY=

# the m3u playlist filename
M3U=

#
ENCODEAUDIO="-x --audio-format mp3 --audio-quality 1"

# the youtube's playlist url
YTPLURL=

# perl-ish rename utility of your distro, if it exists
RENAMECMD=

usage () {
	echo "Usage: ${0##*/} [-d PATH] [-h] [-k] [-m FILE] [-v] URL" >&2
	exit $1
}

showhelp () {
	echo "Usage: ${0##*/} [-d PATH] [-h] [-k] [-m FILE] [-v] URL" >&2
	echo
	echo "Options:"
	echo -e "  -d PATH\t\tcreate a directory named PATH and put the files in it"
	echo -e "  -h\t\t\tprint this help text and exit"
	echo -e "  -k\t\t\tkeeps the videos in the playlist, don't extract audio"
	echo -e "  -m FILE\t\tcreate a .m3u playlist file. If this options don't"
	echo -e "\t\t\texist and the -d option exists, the m3u filename is similar to"
	echo -e "\t\t\tthe last part of the PATH argument"
	echo -e "  -v\t\t\tprint various debugging information"
	exit 0
}

senderror () {
	case $1 in
		1)
			echo "Error opening MP3: *.mp3: No such file or directory"
			exit 2
			;;
	esac
}

# Check to see which is the perl-ish rename utility of your distro
# and if it exists
renameUtil () {
	# Debian distros
	RENAMECMD=$(which rename 2>/dev/null)
	if [[ -z "$(${RENAMECMD} 2>&1 | grep perlexpr)" ]]; then
		# Arch distros
		RENAMECMD=$(which perl-rename 2>/dev/null) || {
			echo "Perl-ish rename utility is missing." >&2
			exit 1
		}
	fi
}

# use the mp3info utility, if it exists, to get the length of the track
# in whole seconds
getTimeDuration () {
	local mp3tool

	mp3tool=$(which mp3info 2>/dev/null)
	[[ "${mp3tool}" ]] && "${mp3tool}" -p "%S" "$*" 2>/dev/null || echo -n "0"
}

# create the given m3u playlist file
buildplaylist () {
	local multifn

	[[ -z $(ls *.mp[34] 2>/dev/null) ]] && senderror 1
	echo '#EXTM3U' > "$*"
	for multifn in *.mp[34]; do
		echo "#EXTINF:"$(getTimeDuration "${multifn}")",${multifn}" >> "$*"
		echo "${multifn}" >> "$*"
	done
}


__main__ () {

	# First check that a perl-ish rename utility exists
	renameUtil

	# check command options
	# -- no long options for getopts :(
	# -- mandatory argument with optional option/argument ":hvd:m::" :(
	while getopts ":d:hkm:v" opt; do
		case "${opt}" in
			d)
				[[ "$OPTARG" != -* ]] && DIRECTORY="$OPTARG" || usage 1
				;;
			h)
				showhelp
				;;
			k)
				ENCODEAUDIO=""
				;;
			m)
				[[ "$OPTARG" != -* ]] && M3U="$OPTARG" || M3U="unnamed"
				;;
			v)
				VERBOSE=1
				;;
			\?)
				echo "Invalid option: -$OPTARG" >&2
				usage 1
				;;
			:)
				echo "Option -$OPTARG requires an argument" >&2
				usage 1
				;;
		esac
	done
	# The easiest way to get rid of the processed options:
	shift $((OPTIND-1))
	# This will run all of the remaining arguments together with spaces between them:
	YTPLURL="$*"
	[[ $# -ne 1 ]] && {
		#echo "Oops... something's wrong. Maybe the youtube url's missing."
		usage 1
	}
	# set a m3u filename if it's not specified
	if { [[ -z "${M3U}" ]] || [[ "${M3U}" == "unnamed" ]] ; } && [[ -n "${DIRECTORY}" ]]; then
		M3U="${DIRECTORY##*/}".m3u
	fi

	[[ ${DIRECTORY} ]] && {
		(( ${VERBOSE} )) && echo "Creating the directory “${DIRECTORY}”."
		[[ -z "${DEBUG}" ]] && {
			mkdir -p "${DIRECTORY}"
			cd "${DIRECTORY}"
		}
	}
	[[ ${YTPLURL} ]] && {
		(( ${VERBOSE} )) && echo "Downloading playlist files. Please wait..."
		[[ -z "${DEBUG}" ]] && youtube-dl -c -i -o "%(playlist_index)s. %(title)s.%(ext)s" "${ENCODEAUDIO}" "${YTPLURL}"
		(( ${VERBOSE} )) && [ "${RENAMECMD}" ] && echo "Renaming downloaded files."
		[[ -z "${DEBUG}" ]] && {
			"${RENAMECMD}" 's/^0*//' *.mp[34]
			"${RENAMECMD}" 's/^(\d)\./0$1./' *.mp[34]
		}
	}
	[[ ${M3U} ]] && {
		# set a proper extension if needed
		[[ "${M3U##*.}" == "m3u" ]] || M3U="${M3U%.*}".m3u
		(( ${VERBOSE} )) && echo "Constructing the playlist “${M3U}” file."
		[[ -z "${DEBUG}" ]] && buildplaylist "${M3U}"
	}

}

__main__ "$@"

exit 0
