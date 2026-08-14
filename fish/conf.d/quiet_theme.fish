# quiet — fish syntax colours matching the Neovim/Ghostty palette.
#
# Loaded after fish_frozen_theme.fish (conf.d runs alphabetically), so these
# values win over the migrated Catppuccin ones without editing that file.
#
# Same rule as the editor: the command is the landmark, everything else is
# ordinary text.

set -l text      c5c9c5
set -l bright    e1e3df
set -l quiet     9aa39c
set -l comment   707a73
set -l inactive  424944
set -l orange    c47b5a
set -l ochre     c2ad72
set -l sand      bcae86
set -l teal      69a6a0
set -l green     718b78
set -l red       b76d68
set -l string    bcc4b8
set -l selection 2f3a35

set -g fish_color_normal $text
set -g fish_color_command $orange
set -g fish_color_keyword $sand
set -g fish_color_quote $string
set -g fish_color_redirection $text
set -g fish_color_end $text
set -g fish_color_error $red
set -g fish_color_param $text
set -g fish_color_valid_path $text
set -g fish_color_option $quiet
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $teal
set -g fish_color_escape $teal
set -g fish_color_autosuggestion $inactive
set -g fish_color_cancel $red
set -g fish_color_gray $comment
set -g fish_color_cwd $text
set -g fish_color_cwd_root $red
set -g fish_color_host $quiet
set -g fish_color_host_remote $ochre
set -g fish_color_user $quiet
set -g fish_color_history_current --bold
set -g fish_color_status $red
set -g fish_color_match $ochre

# completion pager
set -g fish_pager_color_progress $comment
set -g fish_pager_color_background
set -g fish_pager_color_prefix $ochre
set -g fish_pager_color_completion $text
set -g fish_pager_color_description $comment
set -g fish_pager_color_selected_background --background=$selection
set -g fish_pager_color_selected_prefix $ochre
set -g fish_pager_color_selected_completion $bright
set -g fish_pager_color_selected_description $quiet
set -g fish_pager_color_secondary_background
set -g fish_pager_color_secondary_prefix $ochre
set -g fish_pager_color_secondary_completion $text
set -g fish_pager_color_secondary_description $comment
