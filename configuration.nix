# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Lisbon";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "pt_PT.UTF-8";
      LC_IDENTIFICATION = "pt_PT.UTF-8";
      LC_MEASUREMENT = "pt_PT.UTF-8";
      LC_MONETARY = "pt_PT.UTF-8";
      LC_NAME = "pt_PT.UTF-8";
      LC_NUMERIC = "pt_PT.UTF-8";
      LC_PAPER = "pt_PT.UTF-8";
      LC_TELEPHONE = "pt_PT.UTF-8";
      LC_TIME = "pt_PT.UTF-8";
    };
  };

  services = {
    displayManager = {
      defaultSession = "none+i3";
      autoLogin = {
        enable = true;
        user = "ricardo";
      };
    };

    gvfs.enable = true;

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };

    printing.enable = true;

    pulseaudio.enable = false; # disable pulseaudio to enable pipewire

    udisks2.enable = true;

    xserver = {
      enable = true;

      desktopManager = {
        xterm.enable = false;
      };
   
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu #application launcher most people use
          i3status # gives you the default i3 status bar
          i3blocks #if you are planning on using i3blocks over i3status
       ];
      };

      xkb =  {
        layout = "pt,us";
        variant = "mac,";
        options = "grp:shifts_toggle";
      };
    };
  };

  # Configure console keymap
  console.keyMap = "pt-latin1";

  security.rtkit.enable = true;

  users = {
    defaultUserShell = pkgs.zsh;
    users.ricardo = {
      isNormalUser = true;
      description = "Ricardo";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [];
    };
  };

  programs = {
    i3lock.enable = true; #default i3 screen locker

    firefox.enable = true;

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
      ];
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      enableBashCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      histSize = 99999;
      ohMyZsh = {
        enable = true;
        plugins = ["fzf" "git"];
        theme = "fwalch";
      };
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  environment = {
    pathsToLink = [ "/libexec" ];
    shells = with pkgs; [zsh];
    sessionVariables = {
      EDITOR = "vim";
      TERMINAL = "alacritty";
    };

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    systemPackages = with pkgs; [
      alacritty
      alsa-utils
      bat
      feh
      fzf
      git
      (pkgs.gruvbox-gtk-theme.override {
        colorVariants = [ "dark" "light" ];
        tweakVariants = [ "medium" ];
        themeVariants = [ "default" ];
      })
      gruvbox-plus-icons
      lxappearance
      oh-my-zsh
      vim
      wget
      xdotool # for i3blocks
      xfce.thunar-volman
      xfce.tumbler
      xkblayout-state
      yad # for i3blocks
    ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.hack
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
