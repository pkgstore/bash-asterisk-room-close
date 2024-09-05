#!/usr/bin/env -S bash -e
#
# Asterisk script for closing room.
# If there is only 1 user left in the room, the room is closed.
#
# @package    Bash
# @author     Yuri Dunaev
# @license    MIT
# @version    1.0.0
# @link       https://***REMOVED***/asterisk/asterisk-close-room
# -------------------------------------------------------------------------------------------------------------------- #

(( EUID != 0 )) && { echo >&2 'This script should be run as root!'; exit 1; }

# Settings.
SRC_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd -P ) # Source directory.
SRC_NAME="$(basename "$(readlink -f "${BASH_SOURCE[0]}")")" # Source name.
. "${SRC_DIR}/${SRC_NAME%.*}.ini" # Loading configuration data.


# Variables.
mapfile -t rooms < <( grep '^conf =>' '/etc/asterisk/meetme.conf' | cut -d ' ' -f '3' )

# -------------------------------------------------------------------------------------------------------------------- #
# INITIALIZATION
# -------------------------------------------------------------------------------------------------------------------- #

run() { close; }

# -------------------------------------------------------------------------------------------------------------------- #
# ROOM CLOSE
# -------------------------------------------------------------------------------------------------------------------- #

close() {
  for room in "${rooms[@]}"; do
    for phone in "${phones[@]}"; do
      users=$( asterisk -x "meetme list ${room}" | head -n -1 | awk '{ print NR }' )
      last=$( asterisk -x "meetme list ${room}" | grep "${phone}" | awk '{ print $4 }' )

      case ${users} in
        1) [[ ${phone} -eq ${last} ]] && asterisk -x "meetme kick ${room} all" ;;
        *) continue ;;
      esac
    done
  done
}

# -------------------------------------------------------------------------------------------------------------------- #
# EXIT
# -------------------------------------------------------------------------------------------------------------------- #

run && exit 0 || exit 1
