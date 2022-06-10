NixOS 5: Steam and Olive Editor
===============================

- Companion to video at https://www.youtube.com/watch?v=yUbKWg-IbDI

- See prior videos in playlist at
  https://www.youtube.com/playlist?list=PLa01scHy0YEmg8trm421aYq4OtPD8u1SN 

Steps
-----

- Install Steam: ``programs.steam.enable = true``

- Try to install olive-editor via config.  WHen it doesn't work, ``nix-env -i
  /nix/store/4nq5wfa01vq6x00q8k777qhf47bp2wd4-olive-editor-0.1.2 --option
  binary-caches https://cache.nixos.org`` as per the last known good build at
  https://hydra.nixos.org/build/173379959
