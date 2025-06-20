if ! test -d bin; then mkdir bin; fi
odin run . -debug -out:./bin/pixel_unstuck
