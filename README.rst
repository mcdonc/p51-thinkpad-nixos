NixOS 3: More Low Level Utility Configuration on Thinkpad P51
=============================================================

- Companion to video at ...

- Builds on previous iteration https://github.com/mcdonc/p51-thinkpad-nixos/tree/secondvid

Steps
-----

- Install firefox.
  
- Change acpi_call config to use what's in nixos-hardware. See
  https://github.com/NixOS/nixos-hardware/blob/master/lenovo/thinkpad/p53/default.nix
  Use: nixos-hardware/common/pc.laptop/acpi_call.nix

- Use nixos-hardware/common/cpu/intel

- Set up thermald to address inappropriate throttling.  "As of thermald 2.4.3
  and Linux 5.12 it appears to be enough to just use thermald with no further
  workarounds."  nixos-hardware p53 uses "throttled" but it indicates it's a temporary
  workaround until "thermald" is fixed.  It's fixed.
  https://github.com/NixOS/nixos-hardware/blob/master/lenovo/thinkpad/p53/default.nix
  and
  https://wiki.archlinux.org/title/Lenovo_ThinkPad_X1_Carbon_(Gen_6)#Power_management.2FThrottling_issues ::

    add thermald package to environment.systemPackages
    services.thermald.enable = true;

- Check if there is a different version of nixos-hardware (different channel name).
  Nerp.
  
- Does an external monitor work?  Not in offload mode.  Sync mode worked.
  
- install powertop
