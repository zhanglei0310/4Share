#!/bin/bash

cd "$(dirname "$0")" || exit
rm -r 'downloaded_rules/' 'whitelist.txt' 'icn_temp.txt'
if [ ! -f 'ori_white_domains.txt' ]; then
    rm ori_white_domains.txt
    touch ori_white_domains.txt
fi

cp 'ori_white_domains.txt' 'icn_temp.txt'
fromdos -- ./*.txt ./*.py
python3 gwl.py

(
cd 'downloaded_rules' || exit
fromdos -- ./*
# find . -maxdepth 1 -type f -print0 | xargs -0 sed -i -E -e '/^include:/d' -e 's/[^\S\r\n]*#[^\r\n]*//g'
find . -maxdepth 1 -type f -print0 | xargs -0 sed -i -E -e '/^include:/d' -e 's/[\t ]*#[^\r\n]*//g'
find . -maxdepth 1 -type f -print0 | xargs -0 sed -i -E -e '/^$/d' -e 's/^/\*\./g'

find . -maxdepth 1 -type f -print0 | xargs -0 cat >> '../icn_temp.txt'
# cat <(find . -maxdepth 1 -type f -print0 | xargs -0 cat) '../icn_temp.txt' | sort | uniq > '../whitelist.txt'
)

sed -i -E -e 's/\s//g' -e 's/\*\./\n\*\./g' -e '$a\''\n' icn_temp.txt
< 'icn_temp.txt' sort | uniq > whitelist.txt
sed -E -i '/^\s*$/d' whitelist.txt && fromdos -- ./*.txt
rm -r 'downloaded_rules/' 'icn_temp.txt'
