#!/bin/sh
for i in db/txt/**/*.txt; do nkf -w -Lu --overwrite $i; done
