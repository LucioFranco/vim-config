{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./cmp.nix
    ./core.nix
    ./lsp.nix
    ./lualine.nix
    ./smart-splits.nix
    ./telescope.nix
  ];

  colorscheme = "solarized";

  colorschemes = {
    nightfox = {
      enable = true;

      settings.colorblind = {
        enable = true;
        severity = {
          deutan = 1;
          protan = 0;
          tritan = 0;
        };
      };
    };
  };

  viAlias = true;
  vimAlias = true;

  # TODO: not sure why I have this? Probably slow load times?
  withRuby = false;

  # lualoader.enable = true;

  plugins = {
    bufferline = {
      enable = true;
      settings.options.diagnostics = lib.mkIf config.plugins.lsp.enable "nvim_lsp";
    };
    chadtree = {
      enable = true;
    };
    dressing.enable = false;
    snacks.enable = true;
    fugitive.enable = true;
    indent-blankline = {
      enable = true;
      settings.indent.char = "▏";
    };
    gitsigns.enable = true;
    guess-indent.enable = true;
    multicursors.enable = true;
    nix-develop.enable = true;
    noice = {
      enable = true;
      settings = {
        lsp.override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
        };
        presets = {
          bottom_search = true; # use a classic bottom cmdline for search
          command_palette = true; # position the cmdline and popupmenu together
          long_message_to_split = true; # long messages will be sent to a split
          inc_rename = false; # enables an input dialog for inc-rename.nvim
          lsp_doc_border = true; # add a border to hover docs and signature help
        };
      };
    };
    notify.enable = true;
    nvim-autopairs.enable = true;
    sleuth.enable = true;
    todo-comments = {
      enable = true;
      keymaps.todoTelescope.key = "<leader>tc";
    };
    treesitter = {
      enable = true;
      nixGrammars = true;
      settings = {
        auto_install = false;
        highlight.enable = true;
        indent.enable = true;
        incremental_selection.enable = true;
      };
    };
    trim = {
      enable = true;
      settings = rec {
        ft_blocklist = [
          "TelescopePrompt"
          "dashboard"
          "help"
        ];
        highlight = true;
        # highlight_ctermbg = "DiffDelete";
        highlight_bg = lib.nixvim.mkRaw "vim.api.nvim_get_hl(0, {name= 'DiffDelete'}).bg";
        highlight_ctermbg = highlight_bg;
        trim_first_line = false;
        trim_last_line = false;
        trim_on_write = false;
      };
    };
    vim-matchup = {
      enable = true;
      settings.surround_enabled = 1;
    };
    vim-suda.enable = true;
    web-devicons.enable = true;
    which-key.enable = true;
    zen-mode.enable = true;
  };

  extraPlugins = with pkgs.vimPlugins; [ solarized-nvim ];

  keymaps = lib.mkMerge [
    [
      {
        key = "<leader>w";
        action = ":Trim<cr>";
        mode = [ "n" ];
        options.desc = "Trim leading/trailing whitespace";
      }
      {
        key = "<leader>gg";
        action = ":tab Git<cr>";
        mode = [ "n" ];
        options.desc = "Open fugitive in a new tab";
      }
    ]
    (lib.mkIf config.plugins.notify.enable [
      {
        key = "<C-d>";
        action = lib.nixvim.mkRaw "require('notify').dismiss";
        mode = [
          "n"
          "v"
          "i"
        ];
        options.desc = "Dismiss nvim-notify notifications";
      }
    ])
  ];
}
