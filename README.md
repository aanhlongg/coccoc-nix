# Cốc Cốc for NixOS

A Nix derivation to package [Cốc Cốc](https://coccoc.com/) for Nix/NixOS. \
Cốc Cốc is a popular browser optimized for vietnamese people, offering an built-in ad blocker, video downloading, sidebar integration, direct torrent support, vietnamese language support, Tor-based incognito mode, and more.


---
 
## Usage
 
### With Flakes
 
Add this repository as an input in your `flake.nix`:
 
```nix
{
inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    coccoc-nix = {
      url = "github:aanhlongg/coccoc-nix";
      inputs.nixpkgs.follows = "nixpkgs"; 
    };
  };
 
  outputs = { nixpkgs, coccoc-nix, ... }: {
    nixosConfigurations.my-host = nixpkgs.lib.nixosSystem {
      modules = [
        ({ pkgs, ... }: {
          environment.systemPackages = [
            coccoc-nix.packages.${pkgs.system}.default
          ];
        })
      ];
    };
  };
}
```
 
### Without Flakes
 
Clone this repository and build with:
 
```bash
NIXPKGS_ALLOW_UNFREE=1 nix-build -E 'with import <nixpkgs> {}; callPackage ./package.nix {}'
```
 
Or add it to your configuration by importing and calling the package:
 
```nix
{ pkgs, ... }:
let
  coccoc-browser = pkgs.callPackage /path/to/package.nix {};
in {
  environment.systemPackages = [ coccoc-browser ];
}
```
 
## License

This repository is [MIT-licensed](LICENSE).  
The packaged upstream browser is proprietary software from Cốc Cốc Company Limited (see [Cốc Cốc's Terms of Service](https://coccoc.com/en/termsofuse)), built on Chromium.
