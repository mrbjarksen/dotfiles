{ config, lib, pkgs, ... }:

{
  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
      hosts = [ "https://github.com" ];
    };
  };
  programs.gh-dash.enable = true;

  programs.git = {
    enable = true;
    userName = "Bjarki B. Harksen";
    userEmail = "bjarki@harksen.is";
    extraConfig = {
      init = { defaultBranch = "main"; };
      core = { quoteBranch = false; };
      merge = { conflictStyle = "diff3"; };
      diff = { algorithm = "histogram"; };
      url = { "https://github.com/" = { insteadOf = [ "gh:" "github:" ]; }; };
    };
  };

  programs.git.delta = {
    enable = true;
    options = {
      minus-style = "syntax \"#37222c\""; 
      minus-non-emph-style = "syntax \"#37222c\""; 
      minus-emph-style = "syntax \"#713137\""; 
      minus-empty-line-marker-style = "syntax \"#37222c\""; 
      line-numbers-minus-style = "\"#b2555b\""; 
      plus-style = "syntax \"#20303b\""; 
      plus-non-emph-style = "syntax \"#20303b\""; 
      plus-emph-style = "syntax \"#2c5a66\""; 
      plus-empty-line-marker-style = "syntax \"#20303b\""; 
      line-numbers-plus-style = "\"#266d6a\""; 
      line-numbers-zero-style = "\"#3b4261\""; 
      navigate = true; 
      side-by-side = true; 
      light = false; 
    };
  };

  # git.maintenance.enable = true;
  # git.signing.enable = true;
}
