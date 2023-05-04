{ config, pkgs, helix, ... }:

let haskell = pkgs.haskell.packages.ghc92;
    packages = p: with p; [
/*  adjunctions
    aeson
    async
    base
    bytestring
    comonad
    constraints
    containers
    contravariant
    criterion
    data-fix
    distributive
    effectful
    exceptions
    free
    foldl
    kan-extensions
    lens
    megaparsec
    mtl
    parser-combinators
*/  pretty-simple
/*  prettyprinter
    primitive
    profunctors
    QuickCheck
    random
    recursion-schemes
    semigroupoids
    text-short
    stm
    template-haskell
    text
    text-show
    transformers
    unordered-containers
*/  ];
in
{
  home.username = "mate";
  home.homeDirectory = "/home/mate";

  home.packages = with pkgs; [
    htop
    exa
    ripgrep
    fd
    wget
  ] ++ (with haskell; [
    cabal-fmt
    cabal-install
    cabal-plan
    fourmolu
    (ghcWithHoogle packages)
    haskell-language-server
    hlint
    ghcid
  ]);

  programs = {
    bat.enable = true;

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


  home.file = {
    ".ghc/ghci.conf".text = ''
      :def hoogle \x -> pure $ ":!hoogle \"" <> x <> "\" --count=20"
      :def! doc \x -> pure $ ":!hoogle --info \"" ++ x ++ "\""
      :set prompt "> "
      :set prompt-cont "  | "
      :set -XNoStarIsType
      :set -Wno-unused-top-binds
      :set +m

      :seti -Wall -Wno-type-defaults -Wno-name-shadowing
      :seti -fno-defer-type-errors -fno-show-valid-hole-fits
      :set -package pretty-simple
      :seti -interactive-print=Text.Pretty.Simple.pPrint
    '';
    ".haskeline".text = "editMode: Vi";
  };

  home.sessionVariables.CABAL_DIR = "${config.xdg.dataHome}/cabal";
  home.sessionPath = ["${config.xdg.dataHome}/cabal/bin"];

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
