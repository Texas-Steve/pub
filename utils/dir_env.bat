@echo off
echo Setting DIRCMD: /og /on
echo Setting PROMPT for 2 lines, too
set DIRCMD=/og /on
:: setting PROMPT to 2 lines, with time and dir on top line, 
:: use $H to erase ".SS"
set PROMPT=$T$h$h$h$S$S$P$_$G
