{ pkgs, inputs, config, lib, ...}:
{

  programs.bat = {
    enable = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;

  };

  programs.starship = {
    enable = true;
    settings = {
      format = "[╭─ ](bold blue)$battery$username$hostname$shlvl$kubernetes$directory$git_branch$git_commit$git_state$git_status$hg_branch$docker_context$package$cmake$dart$dotnet$elixir$elm$erlang$golang$helm$java$julia$kotlin$nim$nodejs$ocaml$perl$php$purescript$python$ruby$rust$scala$swift$terraform$vagrant$zig$nix_shell$conda$memory_usage$aws$gcloud$openstack$env_var$crystal$custom$cmd_duration$lua$line_break$jobs$time$status$shell$character ";
      add_newline = false;
      scan_timeout = 10;
      character = {
        success_symbol = "[╰▶](bold blue)";
        error_symbol = "[╰](bold blue)[▶](bold red) ";
      };
      git_branch = {
        symbol = " ";
        always_show_remote = false;
        format = "[on $symbol$branch]($style) ";
        style = "purple bold";
        truncation_length = 900000000000000000;
        truncation_symbol = "…";
        only_attached = false;
        disabled = false;
      };
      directory = {
        read_only = " 🔒";
        read_only_style = "fg:blue bold";
        style = "blue bold";
        format = "[$path ]($style)[$read_only]($read_only_style)";
      };
      hostname = {
        ssh_only = false;
        format =  "[@$hostname ](green bold)";
        disabled = false;
      };
      username = {
        style_user = "green bold";
        style_root = "red bold";
        format = "(bold green)[$user]($style)";
        disabled = false;
        show_always = true;
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "agnoster";
    };
    history = {
      size = 1000;
      path = "/home/tarkthloss/.config/zsh/history";
    };

    shellAliases = {
      home = "cd ~";
      vim = "nvim";
      please = "sudo";
      ls = "eza -laB --icons --git";
      cat = "bat";
      s = "fzf";
      renix = "sudo nixos-rebuild boot --flake /persist/nixos#default";
      h = "hyprland";
    };
  };
}
