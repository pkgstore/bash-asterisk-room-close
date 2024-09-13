#!/bin/bash -e
#
# Asterisk script for closing room.
# If there is only 1 user left in the room, the room is closed.
#
# @package    Bash
# @author     Yuri Dunaev
# @license    MIT
# @version    0.0.1
# @link       https://fdn.im
# -------------------------------------------------------------------------------------------------------------------- #

(( EUID != 0 )) && { echo >&2 'This script should be run as root!'; exit 1; }

# Sources.
SRC_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd -P ) # Source directory.
SRC_NAME="$(basename "$(readlink -f "${BASH_SOURCE[0]}")")" # Source name.
. "${SRC_DIR}/${SRC_NAME%.*}.ini" # Loading configuration data.

# Variables.
mapfile -t rooms < <( grep '^conf =>' '/etc/asterisk/meetme.conf' | cut -d ' ' -f 3 )

# -------------------------------------------------------------------------------------------------------------------- #
# INITIALIZATION
# -------------------------------------------------------------------------------------------------------------------- #

run() { close; }

# -------------------------------------------------------------------------------------------------------------------- #
# ROOM CLOSE
# -------------------------------------------------------------------------------------------------------------------- #

close() {
  for room in "${rooms[@]}"; do
    for phone in "${phones[@]:?}"; do
      local users; users=$( asterisk -x "meetme list ${room}" | head -n -1 | awk '{ print NR }' )
      local last; last=$( asterisk -x "meetme list ${room}" | grep "${phone}" | awk '{ print $4 }' )

      case ${users} in
        1) [[ ${phone} -eq ${last} ]] && asterisk -x "meetme kick ${room} all" ;;
        *) continue ;;
      esac
    done
  done
}

# -------------------------------------------------------------------------------------------------------------------- #
# -------------------------------------------------< RUNNING SCRIPT >------------------------------------------------- #
# -------------------------------------------------------------------------------------------------------------------- #

run && exit 0 || exit 1
