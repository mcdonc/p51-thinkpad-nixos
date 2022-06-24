NixOS 16: Synchronize Nvidia and Intel GPU DPI/Scaling in X
===========================================================

- Companion to video at https://www.youtube.com/watch?v=-me0HuBOhvI

- See the other videos in this series by visiting the playlist at
  https://www.youtube.com/playlist?list=PLa01scHy0YEmg8trm421aYq4OtPD8u1SN

Steps
-----

- In offload mode, withih nix-shell -p xorg.xdpyinfo::
  
    xdpyinfo | grep -E 'dimensions|resolution'

    [nix-shell:~]$ xdpyinfo | grep -E 'dimensions|resolution'
    dimensions:    1920x1080 pixels (508x285 millimeters)
    resolution:    96x96 dots per inch

  Note that offload mode is 96dpi.

- In sync mode with same::

    [nix-shell:~]$ xdpyinfo | grep -E 'dimensions|resolution'
    dimensions:    1920x1080 pixels (652x366 millimeters)
    resolution:    75x75 dots per inch
    
- To make them the same, ednix::

    # Make the DPI the same in sync mode as in offload mode.                      
    services.xserver.dpi = 96;

  swnix

- nvidia-settings / About
  
 
