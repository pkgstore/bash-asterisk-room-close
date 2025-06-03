# Asterisk: Room Close

A script to close an Asterisk conference room if 1 user with a certain phone number remains in it.

## Install

```bash
export SET_DIR='/root/apps/asterisk'; export GH_NAME='bash-asterisk-room-close'; export GH_URL="https://github.com/pkgstore/${GH_NAME}/archive/refs/heads/main.tar.gz"; curl -Lo "${GH_NAME}-main.tar.gz" "${GH_URL}" && tar -xzf "${GH_NAME}-main.tar.gz" && { cd "${GH_NAME}-main" || exit; } && { for i in app_*; do install -m '0644' -Dt "${SET_DIR}" "${i}"; done; } && { for i in cron_*; do install -m '0644' -Dt '/etc/cron.d' "${i}"; done; } && chmod +x "${SET_DIR}"/*.sh
```

## Resources

- [Documentation (RU)](https://lib.onl/ru/2024/10/0a633c87-935c-54ba-bedf-9c95152b6b51/)
