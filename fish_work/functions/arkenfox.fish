function arkenfox -d "Update arkenfox configuration"
	sh "$FIREFOX_PROFILE/updater.sh"
	sh "$FIREFOX_PROFILE/prefsCleaner.sh"
end
