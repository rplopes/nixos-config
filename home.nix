{ config, pkgs, ... }:

{
  home.username = "ricardo";
  home.homeDirectory = "/home/ricardo";

  home.sessionVariables = {
    EDITOR = "vim";
    TERMINAL = "alacritty";
    XCURSOR_SIZE = "24";
  };

  home.packages = with pkgs; [
    bat
    eza
    feh
    fzf
    gxkb
    (gruvbox-gtk-theme.override {
      colorVariants = [ "dark" "light" ];
      tweakVariants = [ "medium" ];
      themeVariants = [ "default" ];
    })
    gruvbox-plus-icons
    jq
    lxappearance
    networkmanagerapplet
    (polybar.override { i3Support = true; })
    ripgrep
    rofi
    vim
    wget
    xsettingsd
  ];

  # Hide unwanted apps from rofi launcher
  xdg.desktopEntries.gxkb = {
    name = "gxkb";
    noDisplay = true;
  };

  home.file.".config/rofi" = {
    source = ./dotfiles/rofi;
    recursive = true;
  };
  home.file.".config/polybar" = {
    source = ./dotfiles/polybar;
    recursive = true;
  };
  home.file.".config/theme/gruvbox-dark" = {
    source = ./dotfiles/themes/gruvbox-dark;
    recursive = true;
  };
  home.file.".config/theme/gruvbox-light" = {
    source = ./dotfiles/themes/gruvbox-light;
    recursive = true;
  };
  home.file.".config/theme/theme-toggle.sh" = {
    source = ./dotfiles/themes/theme-toggle.sh;
    executable = true;
  };

  # i3 config needs to be mutable for theme switching (sed on color vars)
  home.activation.i3config = config.lib.dag.entryAfter ["writeBoundary"] ''
    src="${./dotfiles/i3/config}"
    dst="$HOME/.config/i3/config"
    mkdir -p "$(dirname "$dst")"
    if [ ! -f "$dst" ] || [ -L "$dst" ]; then
      cp "$src" "$dst"
      chmod 644 "$dst"
    fi
  '';

  # Create initial mutable configs for theme switching (survives rebuilds)
  home.activation.themeSetup = config.lib.dag.entryAfter ["writeBoundary"] ''
    if [ ! -L "$HOME/.config/theme/active" ]; then
      ln -sfn "$HOME/.config/theme/gruvbox-dark" "$HOME/.config/theme/active"
    fi
    if [ ! -f "$HOME/.xsettingsd" ]; then
      cat > "$HOME/.xsettingsd" << 'XEOF'
Net/ThemeName "Gruvbox-Dark-Medium"
Net/IconThemeName "Gruvbox-Plus-Dark"
Gtk/ApplicationPreferDarkTheme 1
XEOF
    fi
    for dir in "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"; do
      mkdir -p "$dir"
      if [ ! -f "$dir/settings.ini" ] || [ -L "$dir/settings.ini" ]; then
        rm -f "$dir/settings.ini"
        cat > "$dir/settings.ini" << 'GEOF'
[Settings]
gtk-icon-theme-name=Gruvbox-Plus-Dark
gtk-theme-name=Gruvbox-Dark-Medium
gtk-application-prefer-dark-theme=1
GEOF
      fi
    done
  '';

  dconf.enable = true;

  programs.firefox.enable = true;

  programs.git = {
    enable = true;
    userName = "Ricardo Lopes";
    userEmail = "mail@ricardolopes.net";
  };

  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      general.import = [ "~/.config/theme/active/alacritty-colors.toml" ];
      font = {
        size = 10;
      };
      terminal = {
        shell = "zsh";
      };
      window = {
        dynamic_padding = true;
        padding = {
          x = 3;
          y = 3;
        };
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.size = 99999;
    oh-my-zsh = {
      enable = true;
      plugins = ["fzf" "git"];
      theme = "fwalch";
    };
  };

  home.stateVersion = "25.05";
}
