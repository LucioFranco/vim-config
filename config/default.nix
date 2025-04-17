{
  config,
  lib,
  pkgs,
  ...
}:
{
  colorscheme = "solarized";

  # plugins = {
  #   bufferline = {
  #     enable = true;
  #     settings.options.diagnostics = lib.mkIf config.plugins.lsp.enable "nvim_lsp";
  #   };
  #   lsp = {
  #     enable = true;
  #   };
  # };

  extraPlugins = with pkgs.vimPlugins; [ solarized-nvim ];
}
