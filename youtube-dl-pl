#!/bin/bash
#
# _________        ____  ____________         _______ ___________________
# ______  /__________  |/ /___  ____/________ ___    |__  ____/___  ____/
# _  __  / __  ___/__    / ______ \  ___  __ \__  /| |_  /     __  __/
# / /_/ /  _  /    _    |   ____/ /  __  /_/ /_  ___ |/ /___   _  /___
# \__,_/   /_/     /_/|_|  /_____/   _  .___/ /_/  |_|\____/   /_____/
#                                    /_/           drxspace@gmail.com
#
set -e

# switch to debugging mode
DEBUG=

# quiet mode is the default mode
VERBOSE=0

# the directory that shall host the mp3 files
DIRECTORY=

# the m3u playlist filename
M3U=

# the youtube's playlist url
YTPLURL=

# perl-ish rename utility of your distro, if it exists
RENAMECMD=

usage () {
	echo "Usage: ${0##*/} [-h] [-v] [-d PATH] [-m [FILE]] URL" >&2
	exit $1
}

showhelp () {
	echo "Usage: ${0##*/} [-h] [-v] [-d PATH] [-m [FILE]] URL" >&2
	echo
	echo "Options:"
	echo -e "  -h\t\t\tprint this help text and exit"
	echo -e "  -v\t\t\tprint various debugging information"
	echo -e "  -d PATH\t\tcreate a directory named PATH and put the files in it"
	echo -e "  -m [FILE]\t\tcreate a .m3u playlist file. If the FILE argument is not"
	echo -e "\t\t\tspecified and the -d option exists, the m3u filename is similar to"
	echo -e "\t\t\tPATH argument"
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

# Check to see which is perl-ish rename utility of your distro
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
	[[ "${mp3tool}" ]] && "${mp3tool}" -p "%S" "$1" || echo -n "0"
}

# create the m3u playlist file
buildplaylist () {
	[[ -z $(ls *.mp3 2>/dev/null) ]] && senderror 1
	echo '#EXTM3U' > "${M3U}"
	for songfn in *.mp3; do
		echo "#EXTINF:"$(getTimeDuration "${songfn}")",${songfn}" >> "${M3U}"
		echo "${songfn}" >> "${M3U}"
	done
}

__main__ () {

	# First check that a perl-ish rename utility exists
	renameUtil

	# check command options
	# -- no long options for getopts :(
	# -- mandatory argument with optional option/argument ":hvd:m::" :'(
	while getopts ":hvd:m::" opt; do
		case "${opt}" in
			h)
				showhelp
				;;
			v)
				VERBOSE=1
				;;
			d)
				[[ "$OPTARG" ]] && DIRECTORY="$OPTARG" || usage 1
				;;
			m)
				[[ "$OPTARG" ]] && M3U="$OPTARG" || M3U="unnamed"
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
	# set a proper m3u filename
	if { [[ -z "${M3U}" ]] || [[ "${M3U}" == "unnamed" ]] ; } && [[ -n "${DIRECTORY}" ]]; then
		M3U="${DIRECTORY}".m3u
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
		[[ -z "${DEBUG}" ]] && youtube-dl "${YTPLURL}" -o "%(playlist_index)s. %(title)s.%(ext)s" -x --audio-format mp3 --audio-quality 1
		(( ${VERBOSE} )) && [ "${RENAMECMD}" ] && echo "Renaming downloaded files."
		[[ -z "${DEBUG}" ]] && {
			"${RENAMECMD}" 's/^0*//' *.mp3
			"${RENAMECMD}" 's/^(\d)\./0$1./' *.mp3
		}
	}
	[[ ${M3U} ]] && {
		# set a proper extension if needed
		[[ "${M3U##*.}" == "m3u" ]] || M3U="${M3U%.*}".m3u
		(( ${VERBOSE} )) && echo "Constructing the playlist “${M3U}” file."
		[[ -z "${DEBUG}" ]] && buildplaylist
	}

}

__main__ "$@"

exit 0
