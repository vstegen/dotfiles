alias random_string="cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-z0-9' | fold -w 8 | head -n 1"
alias random_pw="openssl rand -base64 40"
alias random_num="cat /dev/urandom | env LC_CTYPE=C tr -dc '0-9' | fold -w 3 | head -n 1"

# add nerdfonts to font
function patch-font {
	fontforge -script "$HOME/dev/tools/nerd-fonts/font-patcher" -s -q --complete --progressbars -out patched/ $1
}

# remove attributes from app
# this will fix the issue about a broken app that cannot be opened
function damaged() {
	xattr -cr "/Applications/$1.app"
}

function arkenfox:update {
	sh "${FIREFOX_PROFILE}/updater.sh"
	sh "${FIREFOX_PROFILE}/prefsCleaner.sh"
}
