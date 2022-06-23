NixOS 15: Let Home-Manager Manage Emacs Packages and Set Up Per-Host SSH User Config
=====================================================================================

- Companion to video at https://www.youtube.com/watch?v=gZ4V_KpsLFo

- See the other videos in this series by visiting the playlist at
  https://www.youtube.com/playlist?list=PLa01scHy0YEmg8trm421aYq4OtPD8u1SN


Emacs
-----

- systemPackages: python310Packages.pyflakes

- home manager::

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

- remove elpa from .emacs.d

SSH per-host config
-------------------

Home manager::

    programs.ssh = {
      enable = true;
      matchBlocks = {
        "lock802" = {
          user = "pi";
          hostname = "lock802";
        };
      };
    };

Then, check out ~/.ssh/config
