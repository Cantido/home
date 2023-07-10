{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "rosa";
  home.homeDirectory = "/home/rosa";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".profile".text = ''
      . "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"
    '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/rosa/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    TZ = "America/Denver";

    # use xdg-ninja to find more victims

    ASDF_DATA_DIR = "${config.xdg.dataHome}/asdf";
    AWS_CONFIG_FILE = "${config.xdg.configHome}/aws/config";
    AWS_SHARED_CREDENTIALS_FILE = "${config.xdg.configHome}/aws/credentials";
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    DOCKER_CONFIG = "${config.xdg.configHome}/docker";
    GOPATH = "${config.xdg.dataHome}/go";
    GNUPGHOME = "${config.xdg.dataHome}/gnupg";
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=\"${config.xdg.dataHome}/java\"";
    KDEHOME = "${config.xdg.configHome}/kde";
    LESSHISTFILE = "${config.xdg.stateHome}/less/history";
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
    XINITRC = "${config.xdg.configHome}/X11/xinitrc";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.sessionVariables.GOPATH}/bin"
  ];

  targets.genericLinux.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.bat.enable = true;

  programs.gh.enable = true;

  programs.git = {
    enable = true;
    userName = "Rosa Richter";
    userEmail = "cosmic.lady.rosa@gmail.com";
    signing = {
      key = "FD583641";
      signByDefault = true;
    };
    aliases = {
      aa = "add .";
      b = "branch";
      ci = "commit";
      co = "checkout";
      cob = "checkout -b";
      st = "status";
      sb = "submodule";
      l = "log --oneline";
      sigs = "log --show-signature";
      lb = "lb = !git reflog show --pretty=format:'%gs ~ %gd' --date=relative | grep 'checkout:' | grep -oE '[^ ]+ ~ .*' | awk -F~ '!seen[$1]++' | head -n 10 | awk -F' ~ HEAD@{' '{printf(\"  \\033[33m%s: \\033[37m %s\\033[0m\\n\", substr($2, 1, length($2)-1), $1)}'";
    };

    extraConfig = {
      fetch.prune = true;
      init.defaultBranch = "main";
    };
  };

  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
    settings = {
      # Resources:
      # - https://github.com/drduh/YubiKey-Guide
      # - https://help.riseup.net/en/security/message-security/openpgp/best-practices

      default-key = "0xDD2C4F195E70A0D92F862D6F60BA2A8BFD583641";

      keyserver = "hkps://keyserver.ubuntu.com";
      keyserver-options = [
        "auto-key-retrieve"
        "include-revoked"
        "include-subkeys"
        "no-honor-keyserver-url"
      ];

      personal-cipher-preferences = "AES256 AES192 AES CAST5";
      personal-digest-preferences = "SHA512 SHA384 SHA256 SHA224";
      default-preference-list = "SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed";
      cert-digest-algo = "SHA512";
      charset= "utf-8";
      fixed-list-mode = true;

      # Disable comment string in clear text signatures and ASCII armored messages
      no-comments = true;

      # Disable inclusion of the version string in ASCII armored output
      no-emit-version = true;

      # Display long key IDs
      keyid-format = "0xlong";

      # Display the calculated validity of user IDs during key listings
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity";

      # List all keys (or the specified ones) along with their fingerprints
      with-fingerprint = true;

      require-cross-certification = true;
      use-agent = true;
    };
  };

  programs.kitty = {
    enable = true;

    font = {
      name = "FiraCode Nerd Font Mono";
      package = pkgs.nerdfonts;
      size = 24.0;
    };

    theme = "Rosé Pine";

    settings = {
      enable_audio_bell = false;
      remember_window_size = true;
      initial_window_width = 1280;
      initial_window_height = 800;
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraLuaConfig = builtins.readFile(./nvim/extra.lua);

    plugins = with pkgs.vimPlugins; [
      vim-sensible
      vim-fugitive
      git-blame-nvim
      vim-surround
      vim-commentary
      vim-sleuth
      vim-unimpaired
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
        require("nvim-treesitter.configs").setup {
          highlight = {
            enable = true
          }
        }
        '';
      }
      nvim-treesitter-context
      plenary-nvim
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = "require('gitsigns').setup()";
      }
      editorconfig-nvim
      {
        plugin = telescope-nvim;
        type = "lua";
        config = builtins.readFile(./nvim/telescope.lua);
      }
      vim-tmux-navigator
      undotree


      # lualine and dependencies
      {
        plugin = lualine-nvim;
        type = "lua";
        config = builtins.readFile(./nvim/lualine.lua);
      }
      nvim-web-devicons

      # theme
      rose-pine

      # LSP
      lsp-zero-nvim
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = builtins.readFile(./nvim/lspconfig.lua);
      }
      mason-nvim
      mason-lspconfig-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-nvim-lua
      luasnip
      friendly-snippets

    ];

    extraPackages = with pkgs; [
      cargo
      tree-sitter
      ripgrep
      fd
    ];
  };

  programs.starship.enable = true;

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    historyLimit = 10000;
    terminal = "tmux-256color";
    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
    ];
  };

  programs.zsh = {
    enable = true;
    # Needs to be a relative path to ~
    dotDir = ".config/zsh";

    initExtra = ''
      source "${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh"
      export SSH_AUTH_SOCK="$(${config.programs.gpg.package}/bin/gpgconf --list-dirs agent-ssh-socket)"
    '';

    history = {
      path = "${config.xdg.dataHome}/zsh/zsh_history";
    };

    oh-my-zsh = {
      enable = true;

      plugins = [
        "git"
        "asdf"
        "tmux"
      ];
    };
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
    enableScDaemon = true;

    sshKeys = [
      "1AE952793507FAD1AFA20A46CBC831D484495883"
    ];
  };
}
