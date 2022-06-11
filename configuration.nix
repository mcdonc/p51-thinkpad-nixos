{ config, pkgs, ... }:

let
  user = "chrism";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <nixos-hardware/lenovo/thinkpad>
      <nixos-hardware/common/pc/laptop/acpi_call.nix>
      <nixos-hardware/common/cpu/intel>
      <home-manager/nixos>
    ];

  # Use GRUB
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.requestEncryptionCredentials = true;

  networking.hostId = "83540bcc";

  services.zfs.autoScrub.enable = true;

  networking.hostName = "thinknix51"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "ctrl:nocaps";
  
  # NVIDIA requires nonfree
  nixpkgs.config.allowUnfree = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    nvidia = {
      prime = {
        offload.enable = true; # enable to use intel gpu (hybrid mode)
        # sync.enable = true; # enable to use nvidia gpu (discrete mode)
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
      modesetting.enable = false;
    };

    # other opengl stuff is included via <nixos-hardware/common/cpu/intel> (including 
    # intel-media-driver and vaapiIntel)
    opengl = {
      enable = true;
      extraPackages = with pkgs; [ vaapiVdpau ];
      driSupport = true;
      driSupport32Bit = true;
    };
    bluetooth.enable = true;
  };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # default shell for all users
  users.defaultUserShell = pkgs.zsh;

# Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    initialPassword = "pw321";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh = {
      authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCnLD+dQsKPhCV3eY0lMUP4fDrECI1Boe6PbnSHY+eqRpkA/Nd5okdyXvynWETivWsKdDRlT3gIVgEHqEv8s4lzxyZx9G2fAgQVVpBLk18G9wkH0ARJcJ0+RStXLy9mwYl8Bw8J6kl1+t0FE9Aa9RNtqKzpPCNJ1Uzg2VxeNIdUXawh77kIPk/6sKyT/QTNb5ruHBcd9WYyusUcOSavC9rZpfEIFF6ZhXv2FFklAwn4ggWzYzzSLJlMHzsCGmkKmTdwKijkGFR5JQ3UVY64r3SSYw09RY1TYN/vQFqTDw8RoGZVTeJ6Er/F/4xiVBlzMvxtBxkjJA9HLd8djzSKs8yf amnesia@amnesia" ];
    };
  };

 environment.etc."vimrc".text = ''
    " get rid of maddening mouseclick-moves-cursor behavior
    set mouse=
    set ttymouse=
  '';
  
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  # List software packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim_configurable # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    obs-studio
    firefox
    thermald
    powertop
    libsForQt5.kdeconnect-kde
    gnome.gnome-disk-utility
    openvpn
    unzip
    ripgrep
    bpytop
    killall
    htop
  ];


  # Disable the firewall altogether.
  networking.firewall.enable = false;

  services.tlp = {
    settings = {
      START_CHARGE_THRESH_BAT0 = "75";
      STOP_CHARGE_THRESH_BAT0 = "80";
    };
  };

  services.fstrim.enable = true;
  services.thermald.enable = true;

  programs.steam.enable = true;

  system.stateVersion = "22.05"; # Did you read the comment?

  home-manager.users.${user} = { pkgs, ... }: {

    home.packages = with pkgs; [
      keybase-gui
      ];

    services.keybase.enable = true;
    services.kbfs.enable = true;

    xdg.configFile."environment.d/ssh_askpass.conf".text = ''
       SSH_ASKPASS="/run/current-system/sw/bin/ksshaskpass"
    '';

    xdg.configFile."autostart/ssh-add.desktop".text = ''
      [Desktop Entry]
      Exec=ssh-add -q
      Name=ssh-add
      Type=Application
    '';

    xdg.configFile."plasma-workspace/env/ssh-agent-startup.sh" = {
      text = ''#!/bin/sh
        [ -n "$SSH_AGENT_PID" ] || eval "$(ssh-agent -s)"
        '';
      executable = true;
    };

    xdg.configFile."plasma-workspace/shutdown/ssh-agent-shutdown.sh" = {
      text = ''#!/bin/sh
        [ -z "$SSH_AGENT_PID" ] || eval "$(ssh-agent -k)"
        '';
        executable = true;
    };

    programs.emacs.enable = true;
    services.emacs.enable = true;

    programs.git = {
      enable = true;
      userName  = "Chris McDonough";
      userEmail = "chrism@plope.com";
    };

     programs.zsh = {
       enable = true;
       enableAutosuggestions = true;
       enableCompletion = true;
       dotDir = ".config/zsh";

       shellAliases =  {
         nixcfgswitch = "sudo nixos-rebuild switch";
         nixcfgedit = "sudo emacs -nw /etc/nixos/configuration.nix";
         restartemacs = "systemctl --user restart emacs";
         open = "kioclient exec";
         edit = "emacsclient -n -c";
 	sgrep = "rg";
       };

       profileExtra = ''
         setopt interactivecomments
       '';

       initExtra = ''
         ## include config generated via "p10k configure" manually; zplug cannot edit home manager's zshrc file.
         ## note that I moved it from its original location to /etc/nixos/p10k
         [[ ! -f /etc/nixos/p10k/.p10k.zsh ]] || source /etc/nixos/p10k/.p10k.zsh

         ## Keybindings section
         bindkey -e
         bindkey '^[[7~' beginning-of-line                               # Home key
         bindkey '^[[H' beginning-of-line                                # Home key
         if [[ "''${terminfo[khome]}" != "" ]]; then
         bindkey "''${terminfo[khome]}" beginning-of-line                # [Home] - Go to beginning of line
         fi
         bindkey '^[[8~' end-of-line                                     # End key
         bindkey '^[[F' end-of-line                                     # End key
         if [[ "''${terminfo[kend]}" != "" ]]; then
         bindkey "''${terminfo[kend]}" end-of-line                       # [End] - Go to end of line
         fi
         bindkey '^[[2~' overwrite-mode                                  # Insert key
         bindkey '^[[3~' delete-char                                     # Delete key
         bindkey '^[[C'  forward-char                                    # Right key
         bindkey '^[[D'  backward-char                                   # Left key
         bindkey '^[[5~' history-beginning-search-backward               # Page up key
         bindkey '^[[6~' history-beginning-search-forward                # Page down key
         # Navigate words with ctrl+arrow keys
         bindkey '^[Oc' forward-word                                     #
         bindkey '^[Od' backward-word                                    #
         bindkey '^[[1;5D' backward-word                                 #
         bindkey '^[[1;5C' forward-word                                  #
         bindkey '^H' backward-kill-word                                 # delete previous word with ctrl+backspace
         bindkey '^[[Z' undo                                             # Shift+tab undo last action
         # Theming section
         autoload -U colors
         colors
       '';
       zplug = {
         enable = true;
         plugins = [
           { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
         # Installations with additional options. For the list of options,
         # please refer to Zplug README.
         ];
       };
     };
  };
}

