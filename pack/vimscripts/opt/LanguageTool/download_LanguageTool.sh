#!/bin/sh
# download language tool
[ -z "$(which curl)" ] && echo "Please install curl to run this tool." && exit 1
[ -z "$(which unzip)" ] && echo "Please install unzip to run this tool." && exit 1

# change this URI for newer versions of LanguageTool
curl -O https://languagetool.org/download/LanguageTool-4.1.zip && unzip LanguageTool-4.1.zip && rm LanguageTool-4.1.zip
ln -s LanguageTool-4.1 LanguageTool
