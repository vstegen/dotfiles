function patch-font -d "Patch a font with NerdSympols"
    fd ".+\.(ttf|otf)" --exec fontforge -script "$HOME/dev/resources/nerd-fonts/font-patcher" -s -q --complete --progressbars -out ./patched/
end
