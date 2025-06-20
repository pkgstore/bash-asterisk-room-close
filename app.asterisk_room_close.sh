#!/usr/bin/env -S bash -euo pipefail
# -------------------------------------------------------------------------------------------------------------------- #
# ASTERISK: CLOSING ROOM
# If there is only 1 user left in the room, the room is closed.
# -------------------------------------------------------------------------------------------------------------------- #
# @package    Bash
# @author     Kai Kimera <mail@kai.kim>
# @license    MIT
# @version    0.1.0
# @link       https://lib.onl/ru/2024/10/0a633c87-935c-54ba-bedf-9c95152b6b51/
# -------------------------------------------------------------------------------------------------------------------- #

(( EUID != 0 )) && { echo >&2 'This script should be run as root!'; exit 1; }

# -------------------------------------------------------------------------------------------------------------------- #
# CONFIGURATION
# -------------------------------------------------------------------------------------------------------------------- #

# Sources.
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd -P )"
SRC_NAME="$( basename "$( readlink -f "${BASH_SOURCE[0]}" )" )"
# shellcheck source=/dev/null
. "${SRC_DIR}/${SRC_NAME%.*}.conf"

# Parameters.
PHONES=("${PHONES[@]:?}"); readonly PHONES

# Variables.
mapfile -t ROOMS < <( grep '^conf =>' '/etc/asterisk/meetme.conf' | cut -d ' ' -f 3 )

# -------------------------------------------------------------------------------------------------------------------- #
# -----------------------------------------------------< SCRIPT >----------------------------------------------------- #
# -------------------------------------------------------------------------------------------------------------------- #

function room_close() {
  for room in "${ROOMS[@]}"; do
    for phone in "${PHONES[@]}"; do
      local users; users="$( asterisk -x "meetme list ${room}" | head -n -1 | awk '{ print NR }' )"
      local last; last="$( asterisk -x "meetme list ${room}" | grep "${phone}" | awk '{ print $4 }' )"
      case "${users}" in
        1) [[ "${phone}" -eq "${last}" ]] && asterisk -x "meetme kick ${room} all" ;;
        *) continue ;;
      esac
    done
  done
}

function main() {
  room_close
}; main "$@"
