{ inputs, pkgs, ... }: {
  imports = [
    inputs.disko.nixosModules.disko
    inputs.lanzaboote.nixosModules.lanzaboote
    ./filesystem.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "lenovo";
  networking.networkmanager.enable = true;

  users.users.root = {
    password = "password";
    packages = [ pkgs.neovim pkgs.nixfmt-rfc-style pkgs.sbctl ];
  };

  nix.settings.extra-experimental-features =
    [ "nix-command" "flakes" "repl-flake" ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "x86_64-linux";

  system.stateVersion = "24.05";
}
