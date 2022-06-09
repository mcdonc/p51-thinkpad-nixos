NixOS 4: Using Home Manager to Configure SSH Credential Caching
===============================================================

- Companion to video at https://www.youtube.com/watch?v=MjpQnvSbaIs

- Builds on previous iteration https://github.com/mcdonc/p51-thinkpad-nixos/tree/thirdvid

Steps
-----

- disable touchpad in settings

- make ctrl-alt-T work

- if you're indecisive, forget NixOS.

- Install home manager channel::

    sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz home-manager
    sudo nix-channel --update

- Inside configuration.nix::

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
      ... etc ....
      
- Save our ssh passphrase in the KDE Wallet so we don't have to type it all the 
  time.  Also demonstrate home manager.
  
- Install ksshaskpass ("ksshaskpass").  Match wallet and user passwords.
  
- Set up dotfiles::

   home-manager.users.${user} = { pkgs, ... }: {
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
    };

- relogin to save ssh passphrase to kde wallet

- What is point of using home manager to install stuff over using
  users.chrism.chrism.packages?

