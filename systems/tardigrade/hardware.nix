{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };
  boot.initrd = {
    availableKernelModules = [
      "ata_piix"
      "uhci_hcd"
      "xen_blkfront"
    ];
    kernelModules = [ "nvme" ];
  };
  # fileSystems = {
  #   "/" = {
  #     device = "/dev/mapper/ocivolume-root";
  #     fsType = "xfs";
  #   };
  #   "/boot" = {
  #     device = "/dev/disk/by-uuid/61A6-3EB9";
  #     fsType = "vfat";
  #   };
  # };

}
