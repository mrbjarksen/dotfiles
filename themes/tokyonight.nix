let
  colors = {
    fg = "#c0caf5";
    bg = "#1a1b26";
    bg-alt = "#16161e";

    choice-bg = "#7aa2f7";

    error = "#db4b4b";
    warning = "#e0af68";
    info = "#0db9d7";

    highlight = "#3d59a1";
    highlight-active = "#ff9e64";
  };
in
{
  nvim = { name = "tokyonight-night"; };
  kitty = { name = "Tokyo Night"; };
  zathura = {
    options = {
      adjust-open = "best-fit";
      guioptions = "s";

      page-padding = 2;

      recolor = true;
      recolor-keepue = true;
      recolor-reverse-video = true;
      
      recolor-darkcolor = colors.fg;
      recolor-lightcolor = colors.bg;

      default-bg = colors.bg;
      default-fg = colors.fg;

      statusbar-bg = colors.bg-alt;
      statusbar-fg = colors.fg;

      inputbar-bg = colors.bg-alt;
      inputbar-fg = colors.fg;

      completion-bg = colors.bg-alt;
      completion-fg = colors.fg;
      completion-group-bg = colors.bg-alt;
      completion-group-fg = colors.fg;
      completion-highlight-bg = colors.choice-bg;
      completion-highlight-fg = colors.bg-alt;

      notification-bg = colors.bg-alt;
      notification-fg = colors.info;
      notification-error-bg = colors.bg-alt;
      notification-error-fg = colors.error;
      notification-warning-bg = colors.bg-alt;
      notification-warning-fg = colors.warning;
      
      highlight-color = colors.highlight;
      highlight-fg = colors.highlight;
      highlight-active-color = colors.highlight-active;
      
      render-loading-bg = colors.bg;
      render-loading-fg = colors.fg;

      index-bg = colors.bg-alt;
      index-fg = colors.fg;
      index-active-bg = colors.choice-bg;
      index-active-fg = colors.bg-alt;
    };
  };
  mappings = {
    z = ''set "default-bg \${colors.bg}"'';
    Z = ''set "default-bg \${colors.bg-alt}"'';
  };
}
