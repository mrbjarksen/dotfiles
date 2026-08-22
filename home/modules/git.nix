{ config, lib, pkgs, ... }:

{
  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
      hosts = [ "https://github.com" ];
    };
  };

  programs.git = {
    enable = true;
    signing.format = null;
    settings = {
      user.name = "Bjarki B. Harksen";
      user.email = "bjarki@harksen.is";
      init = { defaultBranch = "main"; };
      core = { quoteBranch = false; };
      merge = { conflictStyle = "diff3"; };
      diff = { algorithm = "histogram"; };
      url = {
        "https://github.com/" = { insteadOf = [ "gh:" "github:" ]; };
        "https://gitlab.com/" = { insteadOf = [ "gl:" "gitlab:" ]; };
        "https://bitbucket.org/" = { insteadOf = [ "bb:" "bitbucket:" ]; };
        "https://codeberg.org/" = { insteadOf = [ "cb:" "codeberg:" ]; };
        "https://sr.ht/" = { insteadOf = [ "sh:" "sourcehut:" ]; };
      };
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
