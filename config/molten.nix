_: {
  plugins = {
    molten = {
      enable = true;

      python3Dependencies =
        p: with p; [
          pandas
          numpy

          pynvim
          jupyter-client
          cairosvg
          ipython
          nbformat
          ipykernel
        ];

      # Configuration settings for molten.nvim. More examples at https://github.com/nix-community/nixvim/blob/main/plugins/by-name/molten/default.nix#L191
      settings = {
        auto_image_popup = false;
        auto_init_behavior = "init";
        auto_open_html_in_browser = false;
        auto_open_output = true;
        cover_empty_lines = false;
        copy_output = false;
        enter_output_behavior = "open_then_enter";
        image_provider = "none";
        output_crop_border = true;
        output_virt_lines = false;
        output_win_border = [
          ""
          "━"
          ""
          ""
        ];
        output_win_hide_on_leave = true;
        output_win_max_height = 15;
        output_win_max_width = 80;
        save_path.__raw = "vim.fn.stdpath('data')..'/molten'";
        tick_rate = 500;
        use_border_highlights = false;
        limit_output_chars = 10000;
        wrap_output = false;
      };
    };

    jupytext.enable = true;

    quarto = {
      enable = true;
    };
  };

  keymaps = [
    # evaluate operator
    {
      mode = "n";
      key = "<leader>e";
      action = ":MoltenEvaluateOperator<CR>";
      options = {
        desc = "evaluate operator";
        silent = true;
      };
    }

    # open output window
    {
      mode = "n";
      key = "<leader>os";
      action = ":noautocmd MoltenEnterOutput<CR>";
      options = {
        desc = "open output window";
        silent = true;
      };
    }

    # re-eval cell
    {
      mode = "n";
      key = "<leader>rr";
      action = ":MoltenReevaluateCell<CR>";
      options = {
        desc = "re-eval cell";
        silent = true;
      };
    }

    # execute visual selection
    {
      mode = "v";
      key = "<leader>r";
      action = ":<C-u>MoltenEvaluateVisual<CR>gv";
      options = {
        desc = "execute visual selection";
        silent = true;
      };
    }

    # close output window
    {
      mode = "n";
      key = "<leader>oh";
      action = ":MoltenHideOutput<CR>";
      options = {
        desc = "close output window";
        silent = true;
      };
    }

    # delete Molten cell
    {
      mode = "n";
      key = "<leader>md";
      action = ":MoltenDelete<CR>";
      options = {
        desc = "delete Molten cell";
        silent = true;
      };
    }

    # open output in browser (HTML outputs)
    {
      mode = "n";
      key = "<leader>mx";
      action = ":MoltenOpenInBrowser<CR>";
      options = {
        desc = "open output in browser";
        silent = true;
      };
    }
  ];

}
