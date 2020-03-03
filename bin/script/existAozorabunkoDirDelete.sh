#!/bin/sh
cd db/txt/
ls | grep -v -E '^list_person_all.csv$|^list_person_all_extended_utf8.csv$' | xargs -0 rm -rf
