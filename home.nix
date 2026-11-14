{ config, pkgs, inputs, ...}:
let
  zigPkgs = inputs.zig-flake.packages.${pkgs.stdenv.hostPlatform.system};

in
{
  home.stateVersion = "26.05";

  imports = [
    ./tmux.nix
  ];

  programs.lazygit.enable = true;
  programs.fzf.enable = true;

  programs.helix = {
    enable = true;
    settings = {
      theme = "bogster";
  
      editor = {
        true-color = true;
        file-picker.hidden = false;
      };
  
      keys = {
        insert = {
          "esc" = [ "normal_mode" ":wa" ];
          "C-[" = "normal_mode";
        };
  
        normal = {
          X = "extend_line_above";
          space.n = [ ":insert-output echo %{buffer_name}:%{cursor_line}" "yank_to_clipboard" "delete_selection" "goto_line_start" ];
          space.m = [ ":insert-output echo br s -f %{buffer_name} -l %{cursor_line}" "yank_to_clipboard" "delete_selection" "goto_line_start" ];
          space.t = [ "split_selection_on_newline" ":sort" ];
        };
      };
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "bgb";
        email = "lihui71102@gmail.com";
      };
      core.sshCommand = "ssh -o HostName=ssh.github.com -o Port=443";
    };
  };

  home.packages = with pkgs; [
    zigPkgs.nightly
    inputs.zls.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
