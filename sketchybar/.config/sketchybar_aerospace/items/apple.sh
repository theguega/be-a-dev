#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

POPUP_OFF="sketchybar --set apple.logo popup.drawing=off"
POPUP_CLICK_SCRIPT="sketchybar --set \$NAME popup.drawing=toggle"

apple_logo=(
  icon="⚒️"
  icon.font="0xProto Nerd Font Mono:Bold:18.0"
  icon.color=0xff50fa7b
  label="Valiant"
  label.font="0xProto Nerd Font Mono:Bold:16.0"
  label.color=0xffffffff
  padding_right=15
  padding_left=10
  click_script="$POPUP_CLICK_SCRIPT"
)

apple_prefs=(
  icon="⚙️"
  label="System Preferences"
  click_script="open 'x-apple.systempreferences:'; $POPUP_OFF"
)

apple_activity=(
  icon="📊"
  label="Activity Monitor"
  click_script="open -a 'Activity Monitor'; $POPUP_OFF"
)

apple_lock=(
  icon="🔒"
  label="Lock Screen"
  click_script="pmset displaysleepnow; $POPUP_OFF"
)

sketchybar --add item apple.logo left                  \
           --set apple.logo "${apple_logo[@]}"         \
                                                       \
           --add item apple.prefs popup.apple.logo     \
           --set apple.prefs "${apple_prefs[@]}"       \
                                                       \
           --add item apple.activity popup.apple.logo  \
           --set apple.activity "${apple_activity[@]}" \
                                                       \
           --add item apple.lock popup.apple.logo      \
           --set apple.lock "${apple_lock[@]}"