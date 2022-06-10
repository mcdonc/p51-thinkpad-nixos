NixOS 6: Fingerprint Reader, KDE Connect, Emacs, Git, Zsh on Thinkpad P51 and Final Thoughts
============================================================================================

- Companion to video at https://www.youtube.com/watch?v=GG4RzUBoLFs

- See prior videos in playlist at
  https://www.youtube.com/playlist?list=PLa01scHy0YEmg8trm421aYq4OtPD8u1SN 

Steps
-----

- show powertop tunables under battery.

- Attempt to make fingerprint reader work for login.  To do so, install fprint 
  (currently 1.94.3); but that doesn't work with validity 
  sensor, inc. USB id 138a:0097 in p51 OOTB.  This is supposed to make it work,
  but craps out during compilation::

    # Fingerprint reader: login and unlock with fingerprint (if you add one with `fprintd-enroll`)
    services.fprintd.enable = true;
    services.fprintd.tod.enable = true;
    services.fprintd.tod.driver = pkgs.libfprint-2-tod1-vfs0090;
  
- KDE Connect::

    libsForQt5.kdeconnect-kde

- Ignore caps lock::

    # Configure keymap in X11
    services.xserver.layout = "us";
    services.xserver.xkbOptions = "ctrl:nocaps";
   
  Log out and back in 

- Within home-manager stanza, install emacs::

    programs.emacs.enable = true;
    services.emacs.enable = true;

- Within home-manager stanza, install git::

    programs.git = {
      enable = true;
      userName  = "Chris McDonough";
      userEmail = "chrism@plope.com";
    };

  See ~/.config/git/config

- Within home manager stanza, set up zsh (thanks to 
  https://github.com/starcraft66/os-config/blob/master/home-manager/programs/zsh.nix)::

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
      };

      profileExtra = ''
        setopt interactivecomments
      '';

      initExtra = ''
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
    };

