{ config, pkgs, pkgs-unstable, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    max-jobs = "auto";
    cores = 0;
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

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
  time.timeZone = "Europe/Lisbon";

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
          i3lock
        ];
      };

      xkb =  {
        layout = "pt,us";
        variant = "mac,";
        options = "grp:shifts_toggle";
      };
    };
  };

  # Portal for dark/light theme detection (used by Firefox)
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  programs.dconf.enable = true;

  # Configure console keymap
  console.keyMap = "pt-latin1";

  security.rtkit.enable = true;

  systemd.services.accounts-daemon.enable = false;

  users = {
    defaultUserShell = pkgs.zsh;
    users.ricardo = {
      isNormalUser = true;
      description = "Ricardo";
      extraGroups = [ "networkmanager" "wheel" ];
};
  };

  programs = {
    i3lock.enable = true;

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
      ];
    };

    zsh.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment = {
    pathsToLink = [ "/libexec" ];
    shells = with pkgs; [zsh];

    systemPackages = with pkgs; [
      alsa-utils
      pkgs-unstable.claude-code
      dconf
      xfce.thunar-volman
      xfce.tumbler
    ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.hack
  ];

  system.stateVersion = "25.05";
}
