NixOS 9: Configure Emacs and More Declaratively Configure Zsh W/ Home-Manager
=============================================================================

- Companion to video at ...

- See the other videos in this series by visiting the playlist at
  https://www.youtube.com/playlist?list=PLa01scHy0YEmg8trm421aYq4OtPD8u1SN

Steps
-----

- Copy the "emacs" and "p10k" directories in this repo into /etc/nixos.

- Add the following for emacs::

    home.file.".emacs.d" = {
      source = ./emacs/.emacs.d;
      recursive = true;
      };

- To make our zsh setup more repeatable::

    home.file.".p10k.zsh" = {
      source = ./p10k/.p10k.zsh;
      executable = true;
      };

- Note that the extraInit of the zshrc laso changed to point at this
  ~/.p10k.zsh file instead of the prior location.

- ``nixos-rebuild switch``.

- Try out emacs, zsh.
