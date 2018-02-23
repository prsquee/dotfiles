#!/usr/bin/env zsh

announce_time () {
  say -v Samantha "the following takes place between $(/bin/date "+%I %p") and $(/bin/date -v+1H "+%I %p")"
  exit 0
}
# check if DnD is on
plutil -convert xml1 -o - ~/Library/Preferences/ByHost/com.apple.notificationcenterui.*.plist | egrep -A1 '>doNotDisturb<' | grep -q 'true'
[[ $? == 0 ]] && exit 1
#
pmset -g | grep -q 'coreaudiod'
[[ $? == 0 ]] && exit 2

announce_time
