Low Level Utilities in NixOS on a ThinkPad P51
==============================================

- Builds on previous iteration: https://github.com/mcdonc/p51-thinkpad-nixos/tree/zfsvid

- Companion to video at https://www.youtube.com/watch?v=aa5YuPclq-A

Steps
-----
  
- Change chrism user's password.

- Set up Konsole profile (manually, for now).

- Get ssh innbound configured::

    users.users.${user} = {
      isNormalUser = true;
      initialPassword = "pw321";
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      openssh = {
        authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCnLD+dQsKPhCV3eY0lMUP4fDrECI1Boe6PbnSHY+eqRpkA/Nd5okdyXvynWETivWsKdDRlT3gIVgEHqEv8s4lzxyZx9G2fAgQVVpBLk18G9wkH0ARJcJ0+RStXLy9mwYl8Bw8J6kl1+t0FE9Aa9RNtqKzpPCNJ1Uzg2VxeNIdUXawh77kIPk/6sKyT/QTNb5ruHBcd9WYyusUcOSavC9rZpfEIFF6ZhXv2FFklAwn4ggWzYzzSLJlMHzsCGmkKmTdwKijkGFR5JQ3UVY64r3SSYw09RY1TYN/vQFqTDw8RoGZVTeJ6Er/F/4xiVBlzMvxtBxkjJA9HLd8djzSKs8yf amnesia@amnesia" ];
     };
     };


     # Enable the OpenSSH daemon.
     services.openssh = {
       enable = true;
       passwordAuthentication = false;
     };

- Get ssh outbound configured::

     ssh bouncer.repoze.org (to create .ssh dir)
     cp usbstick id_rsa* to ~/.ssh, chmod

     There are ways to do this declaratively, but I'm not really ready for them yet (a bit complex).

- Get zsh set up.

  Under user::

      shell = pkgs.zsh;

  At config level::
    
      programs.zsh.enable = true;
      programs.zsh.promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";

  Inside environment.systemPackages::

     zsh-command-time
     zsh-powerlevel10k

     *Fire up a new terminal to configure.*

- Get configured with nixos-hardware::

    sudo nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
    sudo nix-channel --update

  Add to imports in configuration.nix::

   <nixos-hardware/lenovo/thinkpad>

- Get tlp battery charge throttling set up::

    services.tlp = {
      settings = {
        START_CHARGE_THRESH_BAT0 = "75";
        STOP_CHARGE_THRESH_BAT0 = "80";
      };
    };

    boot.kernelModules = [ "kvm-intel" "acpi_call" ];
    boot.extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];

- Get SSD TRIM support going::

    services.fstrim.enable = true;

- Fix stupid Vim mouse thing::

    environment.etc."vimrc".text = ''
    " get rid of maddening mouseclick-moves-cursor behavior
    set mouse=
    set ttymouse=
    '';


