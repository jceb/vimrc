#!/bin/sh
# download language tool
[ -z "$(which curl)" ] && echo "Please install curl to run this tool." && exit 1
[ -z "$(which unzip)" ] && echo "Please install unzip to run this tool." && exit 1

# change this URI for newer versions of LanguageTool
if [ -e LanguageTool ]; then
    rm LanguageTool
fi
curl -O https://languagetool.org/download/LanguageTool-5.2.zip && unzip LanguageTool-5.2.zip && rm LanguageTool-5.2.zip
ln -s LanguageTool-5.2 LanguageTool
