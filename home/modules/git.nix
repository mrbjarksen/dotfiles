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
    settings = {
      user.name = "Bjarki B. Harksen";
      user.email = "bjarki@harksen.is";
      init = { defaultBranch = "main"; };
      core = { quoteBranch = false; };
      merge = { conflictStyle = "diff3"; };
      diff = { algorithm = "histogram"; };
      url = { "https://github.com/" = { insteadOf = [ "gh:" "github:" ]; }; };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true; 
      side-by-side = true; 
    };
  };

  # git.maintenance.enable = true;
  # git.signing.enable = true;
}
