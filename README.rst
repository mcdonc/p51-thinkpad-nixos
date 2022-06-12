NixOS 8: Using Private Internet Access VPN (Workaround)
=======================================================

- Companion to video at https://www.youtube.com/watch?v=WceoxqhsQBs

- See the other videos in this series by visiting the playlist at
  https://www.youtube.com/playlist?list=PLa01scHy0YEmg8trm421aYq4OtPD8u1SN

Steps
-----

- No GUI PIA client for NixOS in the Nix repos.  This video outlines a
  workaround.

- Download https://www.privateinternetaccess.com/openvpn/openvpn.zip and unzip
  to get *.ovpn files.

- Import any of those ovpn files into network manager by using the "import VPN
  connection" under "Other" in "Choose a Connection Type" when adding a new
  connection in the network manager.

- In the resulting connection pane, use the pia username and password assigned to you.

- Turn off IPV6 on the main connection and reconnect it.

- Connect to the VPN connection in the dropdown after reconnecting the main connection.

- Visit the dark web.
  



  
