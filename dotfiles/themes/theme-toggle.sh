#!/usr/bin/env bash

THEME_DIR="$HOME/.config/theme"
ACTIVE="$THEME_DIR/active"

# Determine target theme
current=$(basename "$(readlink "$ACTIVE")")
if [ "$current" = "gruvbox-dark" ]; then
    TARGET="gruvbox-light"
else
    TARGET="gruvbox-dark"
fi

# Swap the symlink and source theme config
ln -sfn "$THEME_DIR/$TARGET" "$ACTIVE"
source "$ACTIVE/colors.sh"
source "$ACTIVE/theme.conf"

# Reload i3 colors (i3 has no include mechanism)
I3_CONFIG="$HOME/.config/i3/config"
sed -i "s/^set \$bg .*/set \$bg $THEME_BG/" "$I3_CONFIG"
sed -i "s/^set \$fg .*/set \$fg $THEME_FG/" "$I3_CONFIG"
sed -i "s/^set \$red .*/set \$red $THEME_RED/" "$I3_CONFIG"
sed -i "s/^set \$yellow .*/set \$yellow $THEME_YELLOW/" "$I3_CONFIG"
sed -i "s/^set \$blue .*/set \$blue $THEME_BLUE/" "$I3_CONFIG"
i3-msg reload

# Reload polybar (picks up new colors.ini via include-file)
pkill polybar
while pgrep -x polybar >/dev/null; do sleep 0.1; done
polybar main &disown

# Reload all alacritty windows via IPC
for socket in /run/user/$(id -u)/Alacritty-*.sock; do
    [ -S "$socket" ] && alacritty msg --socket "$socket" config -w -1 \
        "colors.primary.background=\"$THEME_BG\"" \
        "colors.primary.foreground=\"$THEME_FG\"" \
        "colors.normal.black=\"$THEME_BG_ALT\"" \
        "colors.normal.red=\"$THEME_RED\"" \
        "colors.normal.green=\"$THEME_GREEN\"" \
        "colors.normal.yellow=\"$THEME_YELLOW\"" \
        "colors.normal.blue=\"$THEME_BLUE\"" \
        "colors.normal.magenta=\"$THEME_MAGENTA\"" \
        "colors.normal.cyan=\"$THEME_CYAN\"" \
        "colors.normal.white=\"$THEME_FG_DIM\"" \
        2>/dev/null
done

# Write settings.ini for new GTK apps
for dir in "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"; do
    mkdir -p "$dir"
    cat > "$dir/settings.ini" << EOF
[Settings]
gtk-icon-theme-name=Gruvbox-Plus-Dark
gtk-theme-name=$GTK_THEME
gtk-application-prefer-dark-theme=$GTK_DARK
EOF
done

# Notify running GTK apps via xsettingsd
cat > "$HOME/.xsettingsd" << EOF
Net/ThemeName "$GTK_THEME"
Net/IconThemeName "Gruvbox-Plus-Dark"
Gtk/ApplicationPreferDarkTheme $GTK_DARK
EOF
pkill xsettingsd 2>/dev/null
while pgrep -x xsettingsd >/dev/null; do sleep 0.1; done
xsettingsd &disown
sleep 0.5

# Update dconf for xdg-desktop-portal (Firefox reads color-scheme via D-Bus)
if [ "$GTK_DARK" -eq 1 ]; then
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
else
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
fi
dconf write /org/gnome/desktop/interface/gtk-theme "'$GTK_THEME'"
