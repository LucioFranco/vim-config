{ lib, ... }:
{
  plugins = {
    lsp = {
      enable = true;
      inlayHints = false;
      keymaps = {
        diagnostic = {
          "[d" = "goto_prev";
          "]d" = "goto_next";
          "<leader>e" = "open_float";
        };
        lspBuf = {
          "ca" = "code_action";
          "gD" = "declaration";
          "gd" = "definition";
          "K" = "hover";
          "gi" = "implementation";
          "gr" = "references";
          "<leader>D" = "type_definition";
          "<leader>rn" = "rename";
        };

        extra = [
          {
            key = "<leader>f";
            mode = [
              "n"
              "v"
            ];
            action =
              lib.nixvim.mkRaw # lua
                ''
                  function()
                    vim.lsp.buf.format({ async = true })
                  end
                '';
            options.desc = "Format the current buffer";
          }
        ];
      };

      servers = {
        nixd = {
          enable = true;
          settings.formatting.command = [ "nixfmt" ];
        };
      };
    };

    rustaceanvim.enable = true;
  };
}
