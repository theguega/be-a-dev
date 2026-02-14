#!/bin/bash

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
# Prefer main variables (colors, fonts, paths) so we use your existing palette
[ -f "$CONFIG_DIR/variables.sh" ] && source "$CONFIG_DIR/variables.sh"
# Optional aerospace color overrides (non-fatal if missing)
[ -f "$CONFIG_DIR/colors.sh" ] && source "$CONFIG_DIR/colors.sh"
# Icon map helper (contains sketchybar-app-font mapping). Non-fatal if missing.
[ -f "$CONFIG_DIR/helpers/icon_map.sh" ] && source "$CONFIG_DIR/helpers/icon_map.sh"

# Ensure plugin/item dir fallbacks so click scripts resolve
PLUGIN_DIR="${PLUGIN_DIR:-$HOME/.config/sketchybar/plugins}"
ITEM_DIR="${ITEM_DIR:-$HOME/.config/sketchybar/items}"

aerospace_spaces() {
  CURRENT_WORKSPACE=$(aerospace list-workspaces --focused)
  # Always show workspaces 1..9 and highlight the focused one.
  # This forces the bar to display every workspace number even if empty.
  ACTIVE_WORKSPACES=()
  for ws in {1..9}; do
    ACTIVE_WORKSPACES+=("$ws")
  done

  args=()
  # Remove existing aerospace workspace items
  for i in {1..9}; do
    args+=(--remove aerospace.workspace.$i)
  done

  # Add active workspaces with app icons (as regular items so they always stay visible)
  for workspace in "${ACTIVE_WORKSPACES[@]}"; do
    # Get the first (focused) app in the workspace for the icon
    APP=$(aerospace list-windows --workspace "$workspace" --format '%{app-name}' | head -1)

    # Get icon from the sketchybar-app-font
    if [ -n "$APP" ]; then
      # Use the app icon if available
      __icon_map "$APP"
      ICON_RESULT="$icon_result"
      if [ "$ICON_RESULT" = "" ] || [ "$ICON_RESULT" = ":default:" ]; then
        ICON_RESULT="$workspace"  # Fallback to workspace number
      fi
    else
      ICON_RESULT="$workspace"  # Show workspace number when empty
    fi

    # Set colors based on current workspace with stronger highlighting
    if [ "$workspace" = "$CURRENT_WORKSPACE" ]; then
      BG_COLOR=$GREEN
      ICON_COLOR=$BLACK
      TEXT_COLOR=$BLACK
      HIGHLIGHT=on
    else
      BG_COLOR=$BACKGROUND_2
      ICON_COLOR=$WHITE
      TEXT_COLOR=$WHITE
      HIGHLIGHT=off
    fi

    # Add the workspace item as a regular item (not a space) so it always draws
    args+=(
      --add item aerospace.workspace.$workspace left
      --set aerospace.workspace.$workspace associated_display=active
      --set aerospace.workspace.$workspace icon="$ICON_RESULT"
      --set aerospace.workspace.$workspace icon.drawing=on
      --set aerospace.workspace.$workspace icon.padding_left=8
      --set aerospace.workspace.$workspace icon.padding_right=4
      --set aerospace.workspace.$workspace icon.color="$ICON_COLOR"
      --set aerospace.workspace.$workspace icon.font="sketchybar-app-font:Regular:16.0"
      --set aerospace.workspace.$workspace label="$workspace"
      --set aerospace.workspace.$workspace label.drawing=on
      --set aerospace.workspace.$workspace label.padding_left=4
      --set aerospace.workspace.$workspace label.padding_right=8
      --set aerospace.workspace.$workspace label.color="$TEXT_COLOR"
      --set aerospace.workspace.$workspace label.font="SF Pro:Semibold:13.0"
      --set aerospace.workspace.$workspace background.color="$BG_COLOR"
      --set aerospace.workspace.$workspace background.border_width=0
      --set aerospace.workspace.$workspace background.corner_radius=8
      --set aerospace.workspace.$workspace background.height=28
      --set aerospace.workspace.$workspace background.drawing=on
      --set aerospace.workspace.$workspace click_script="aerospace workspace $workspace"
      --set aerospace.workspace.$workspace script="$PLUGIN_DIR/aerospace_space_click.sh"
    )
  done

  sketchybar "${args[@]}" > /dev/null 2>&1 &
}

case "$SENDER" in
  "aerospace_workspace_change") aerospace_spaces
  ;;
  *) aerospace_spaces
  ;;
esac
