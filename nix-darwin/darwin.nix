{ pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
          pkgs.curl
          pkgs.difftastic
          pkgs.direnv
          pkgs.dust
          pkgs.flac
          pkgs.gh
          pkgs.git
          pkgs.jujutsu
          pkgs.ripgrep
          pkgs.wget
          pkgs.atuin
          pkgs.neovim
          pkgs.starship
          pkgs.tokei
          pkgs.nushell
        ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      nix.settings.substituters = [
	"https://cache.lix.systems"
      ];

      nix.settings.trusted-public-keys = [
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      ];

      nix.extraOptions = ''
        extra-nix-path = nixpkgs=flake:nixpkgs
      '';

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      # system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      users.users.graeme = {
        shell = pkgs.fish;
        description = "Graeme Coupar";
        home = "/Users/graeme";
      };
    }
