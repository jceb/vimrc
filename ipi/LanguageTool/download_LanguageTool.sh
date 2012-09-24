#!/bin/sh
# download language tool
wget=$(which wget)
[ -z "$wget" ] && echo "Please install wget to run this tool." && exit 1
unzip=$(which unzip)
[ -z "$unzip" ] && echo "Please install unzip to run this tool." && exit 1

# change this URI for newer versions of LanguageTool
wget http://www.languagetool.org/download/LanguageTool-stable.zip && unzip LanguageTool-stable.zip && rm LanguageTool-stable.zip
