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

  programs.git = {
    enable = true;
    userName = "Ricardo Lopes";
    userEmail = "mail@ricardolopes.net";
  };

  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
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
