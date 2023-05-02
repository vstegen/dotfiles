# git
abbr -ag gcom "git checkout mainline"

# directly work related
abbr -ag login 'kinit -f && mwinit -o -s'

abbr -a bb brazil-build
abbr -a br brazil-build release
abbr -a bre brazil-runtime-exec
abbr -a brc brazil-recursive-cmd
abbr -a bw brazil workspace
abbr -a bws brazil workspace sync
abbr -a bwscreate brazil ws create -n
abbr -a bwsuse brazil workspace use --gitMode -p
abbr -a bbr brazil-recursive-cmd brazil-build
abbr -a bbrall brazil-recursive-cmd --allPackages
abbr -a bbb brazil-recursive-cmd --allPackages brazil-build
abbr -a bbra brazil-recursive-cmd brazil-build apollo-pkg
abbr -a bte brazil-test-exec

abbr -a ebbr eda build brazil-build release

abbr -a third-party-promote ~/.toolbox/bin/brazil-third-party-tool promote
abbr -a third-party ~/.toolbox/bin/brazil-third-party-tool

abbr -a e emacs

abbr -a y env -i /usr/bin/yum
