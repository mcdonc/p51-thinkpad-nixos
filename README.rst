Partition the drive and generate the NixOS configuration
--------------------------------------------------------

- Credit to https://florianfranke.dev/posts/2020/03/installing-nixos-with-encrypted-zfs-on-a-netcup.de-root-server/

- ``sudo sgdisk --zap-all /dev/nvme0n1``

- ``sudo fdisk /dev/nvme0n1``, then::

    g
    n
    accept default part num
    accept default first sector
    last sector: +2G
    t
    use partiton type 1 (EFI System)
    n
    accept default partition number
    accept default first sector
    accept default last sector
    w

- No swap partition (huge amount of memory, also security)

- Create the boot volume::

   sudo mkfs.fat -F 32 /dev/nvme0n1p1
   sudo fatlabel /dev/nvme0n1p1 NIXBOOT

- Create a zpool::

    sudo zpool create -f \
    -o altroot="/mnt" \
    -o ashift=12 \
    -o autotrim=on \
    -O compression=lz4 \
    -O acltype=posixacl \
    -O xattr=sa \
    -O relatime=on \
    -O normalization=formD \
    -O dnodesize=auto \
    -O sync=disabled \
    -O encryption=aes-256-gcm \
    -O keylocation=prompt \
    -O keyformat=passphrase \
    -O mountpoint=none \
    NIXROOT \
    /dev/nvme0n1p2

- Create zfs volumes::

   zfs create -o mountpoint=legacy NIXROOT/root
   zfs create -o mountpoint=legacy NIXROOT/home

- ``sudo mount -t zfs NIXROOT/root /mnt``

  
- Mount subvolumes::
    
   sudo mkdir /mnt/boot
   sudo mkdir /mnt/home
   sudo mount /dev/nvme0n1p1 /mnt/boot
   sudo mount -t zfs NIXROOT/home /mnt/home

- ``sudo nixos-generate-config --root /mnt``

- Edit the config (see ``configuration.nix`` in this repository).

- ``sudo nixos-install``
