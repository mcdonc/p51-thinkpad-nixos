{ config, pkgs, ... }:

let
  user = "chrism";
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in
{
  imports =
    [ 
      ./hardware-configuration.nix
      <nixos-hardware/lenovo/thinkpad>
      <nixos-hardware/common/pc/laptop/acpi_call.nix>
      <nixos-hardware/common/cpu/intel>
      <home-manager/nixos>
    ];


  # Enable experimental features
  nix = { 
    package = pkgs.nixUnstable;
    extraOptions = "experimental-features = nix-command flakes"; 
  };
    
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
  networking.networkmanager.enable = true;  

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #  font = "Lat2-Terminus16";
  #  keyMap = "us";
  #  useXkbConfig = true; # use xkbOptions in tty.
  #};

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "ctrl:nocaps,terminate:ctrl_alt_bksp";
 
  # Enable the DontZap option (it is this, rather than the above that makes ctrl-alt-bs work)
  services.xserver.enableCtrlAltBackspace = true;

  # Make the DPI the same in sync mode as in offload mode.                      
  services.xserver.dpi = 96;

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

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # default shell for all users
  users.defaultUserShell = pkgs.zsh;

# Define a user account. Don't forget to set a password with ???passwd???.
  users.users.${user} = {
    isNormalUser = true;
    initialPassword = "pw321";
    extraGroups = [ "wheel" "networkmanager" ];
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
    permitRootLogin = "no";
  };

  # List software packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim_configurable
    wget
    obs-studio
    firefox
    thermald
    powertop
    libsForQt5.kdeconnect-kde
    libsForQt5.krdc
    gnome.gnome-disk-utility
    openvpn
    unzip
    ripgrep
    bpytop
    killall
    htop
    vlc
    google-chrome
    audacity
    #etcher
    gimp
    transmission-qt
    remmina
    baobab
    signal-desktop
    virtualbox
    python310
    xz
    libreoffice
    ffmpeg-full
    iperf
    nvidia-offload
    python310Packages.pyflakes
  ];

  fonts.fonts = with pkgs; [
    ubuntu_font_family
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

    programs.ssh = {
      enable = true;
      matchBlocks = {
        "lock802" = {
          user = "pi";
          hostname = "lock802";
        };
      };
    };

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
    programs.emacs.extraPackages = epkgs: [
      epkgs.nix-mode
      epkgs.flycheck
      epkgs.json-mode
      epkgs.python-mode
      epkgs.auto-complete
      epkgs.web-mode
      epkgs.smart-tabs-mode
      epkgs.whitespace-cleanup-mode
      epkgs.flycheck-pyflakes
    ];
    services.emacs.enable = true;

    home.file.".emacs.d" = {
      source = ./emacs/.emacs.d;
      recursive = true;
      };

    programs.git = {
      enable = true;
      userName  = "Chris McDonough";
      userEmail = "chrism@plope.com";
    };

    home.file.".p10k.zsh" = {
      source = ./p10k/.p10k.zsh;
      executable = true;
      };

    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      dotDir = ".config/zsh";

      sessionVariables = {
        LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.swp=00;90:*.tmp=00;90:*.dpkg-dist=00;90:*.dpkg-old=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:";
       };

      shellAliases =  {
         swnix = "sudo nixos-rebuild switch";
         ednix = "sudo emacs -nw /etc/nixos/configuration.nix";
         upnix = "sudo nixos-rebuild switch --upgrade";
         schnix = "nix search nixpkgs";
         rbnix = "sudo nixos-rebuild build --rollback";
	 mountzfs = "sudo zfs load-key z/storage; sudo zfs mount z/storage";
         restartemacs = "systemctl --user restart emacs";
         open = "kioclient exec";
         edit = "emacsclient -n -c";
 	 sgrep = "rg";
         ls = "ls --color=auto";
      };

      profileExtra = ''
         setopt interactivecomments
      '';

      initExtra = ''
         ## include config generated via "p10k configure" manually;
	 ## zplug cannot edit home manager's zshrc file.

         [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

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
         ];
       };
     };
  };
}

