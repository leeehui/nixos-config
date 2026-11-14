{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    baseIndex = 1;              # set -g base-index 1
    historyLimit = 10000;       # set -g history-limit 10000
    keyMode = "vi";             # setw -g mode-keys vi
    mouse = true;               # set -gF mouse on
    prefix = "C-l";             # set -g prefix c-l
    terminal = "tmux-256color"; # Recommended for true color and terminal compatibility
    escapeTime = 0;             # set -sg escape-time 0

    # TPM plugins (Home Manager handles cloning and loading automatically)
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
          '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          # set -g @continuum-save-interval '15'
          '';
      }
      # tpm itself is not listed; Home Manager takes care of it
    ];

    # Use extraConfig for raw lines that have no structured option
    extraConfig = ''
          # tmux-continuum settings
          set -g @continuum-restore 'on'
          set -g @resurrect-capture-pane-contents 'on'
          # set -g @continuum-save-interval '2'

          # Display duration
          set -g display-panes-time 2000

          # same key is valid when repeating within 1s, useful in zoom in/out panes
          set -g repeat-time 1000

          # Prefix key for nested tmux sessions
          bind-key -n c-g send-prefix
          bind-key -n c-t send-keys c-g

          # Automatically renumber windows
          set -g renumber-windows on

          # Pane numbering starts at 1
          setw -g pane-base-index 1

          # Toggle mouse on/off
          bind v set -gF mouse "#{?mouse,off,on}" \; display-message "#{?mouse,Mouse: ON,Mouse: OFF}"

          # New window/split uses the current path
          bind c new-window -c "#{pane_current_path}"
          bind '"' split-window -v -c "#{pane_current_path}"
          bind % split-window -h -c "#{pane_current_path}"

          # Reload config (note: Home Manager generates ~/.config/tmux/tmux.conf, not ~/.tmux.conf)
          bind R source ~/.config/tmux/tmux.conf \; display "tmux.conf reloaded"

          # Swap panes
          bind g swap-pane
        '';
  };
}
