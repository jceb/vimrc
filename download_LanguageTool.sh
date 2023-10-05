#!/bin/sh
set -eEuo pipefail

# download language tool
[ -z "$(which curl)" ] && echo "Please install curl to run this tool." && exit 1
[ -z "$(which unzip)" ] && echo "Please install unzip to run this tool." && exit 1

if [ ! -e opt ]; then
	mkdir opt
fi
cd opt

# change this URI for newer versions of LanguageTool
# https://languagetool.org/download
VERSION="5.9"
if [ -e LanguageTool ] || [ -e "LanguageTool-${VERSION}" ]; then
	rm LanguageTool
	rm -rf "LanguageTool-${VERSION}"
fi
curl -O "https://languagetool.org/download/LanguageTool-${VERSION}.zip" && unzip "LanguageTool-${VERSION}.zip" && rm "LanguageTool-${VERSION}.zip"
ln -s "LanguageTool-${VERSION}" LanguageTool
