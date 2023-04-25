{ config, pkgs, helix, ... }:

{
  home.username = "mate";
  home.homeDirectory = "/home/mate";

  home.packages = with pkgs; [
    htop
    exa
    ripgrep
    fd
    wget
  ];

  programs = {
    bat.enable = true;
    helix.enable = true;

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    git.enable = true;

    helix = {
      enable = true;
      package = helix.packages."x86_64-linux".default;
      
      settings = {
        theme = "onedarker";

        editor = {
          line-number = "relative";

          rulers = [100];

          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };

          indent-guides = {
            render = true;
            rainbow = "dim";
          };

          rainbow-brackets = true;
         
          whitespace.render.tab = "all";
        };
      };

      languages = [{
        name = "nix";
        #language-server.command = lib.getExe inputs.nil.packages.${pkgs.system}.default;
      }];
    };

    home-manager.enable = true;

    nushell = {
      enable = true;
      configFile.text = ''
        let-env config = {
          show_banner: false
        }
      '';
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
        #nix_shell = {
        #  symbol = " ";
        #  format = "[$symbol]($style) ";
        #};
        hostname.format = "[$hostname]($style):";
        username.format = "[$user]($style)@";
      };
    };

    zsh = {
      enable = true;
      enableSyntaxHighlighting = true;
      defaultKeymap = "emacs";
    };
  };

  programs.neovim = {
    # package = (builtins.getFlake "github:nixos/nixpkgs/78cd22c1b8604de423546cd49bfe264b786eca13").legacyPackages.x86_64-linux.neovim-unwrapped;
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      vim-nix
      gruvbox-nvim
      lightline-vim
    ];
    extraPackages = with pkgs; [ rnix-lsp ];
    extraConfig = ''
      colorscheme gruvbox
      lua << EOF
      local lspc = require('lspconfig')
      lspc.rnix.setup{}
      EOF
    '';
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

}
