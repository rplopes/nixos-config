{ config, pkgs, ... }:

{
  home.username = "ricardo";
  home.homeDirectory = "/home/ricardo";

  home.packages = with pkgs; [
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
  ];

  home.file.".config/i3/config".source = ./dotfiles/i3/config;
  home.file.".config/i3blocks/config".source = ./dotfiles/i3blocks/config;
  home.file.".config/i3blocks/scripts" = {
    source = ./dotfiles/i3blocks/scripts;
    recursive = true;
    executable = true;
  };
  home.file.".config/rofi" = {
    source = ./dotfiles/rofi;
    recursive = true;
  };

  dconf.enable = false;
  gtk = {
    enable = true;
    theme = {
      name = "Gruvbox-Dark";
      package = pkgs.gruvbox-gtk-theme;
    };
    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-plus-icons;
    };
  };

  programs.git = {
    enable = true;
    userName = "Ricardo Lopes";
    userEmail = "mail@ricardolopes.net";
  };

  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      colors = {
        primary = {
          background = "#1d2021";
          foreground = "#ebdbb2";
        };
        normal = {
          black   = "#282828";
          red     = "#cc241d";
          green   = "#98971a";
          yellow  = "#d79921";
          blue    = "#458588";
          magenta = "#b16286";
          cyan    = "#689d6a";
          white   = "#a89984";
        };
      };
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
    #autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = ["git"];
      theme = "fwalch";
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";
}
