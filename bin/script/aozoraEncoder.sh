#!/bin/sh
nkf -w -Lu $1 > m.txt
cat m.txt | ruby -e 'puts ARGF.read.gsub(/--{20,}.[\s\S]+?--{20,}/,"").gsub(/｜/,"").gsub(/《.+?》/,"").gsub(/［.+?］/,"").gsub(/\n(\s|　)*\n/, "\n")'
rm -f m.txt
