@echo off
if not exist bin (
mkdir bin
)
odin run . -out:./bin/pixel_unstuck.exe
