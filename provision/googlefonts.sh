#!/usr/bin/env bash

echo "################################"
echo "### googlefonts.sh #############"
echo "################################"

# Test git installation
git --version > /dev/null 2>&1
GIT_IS_INSTALLED=$?

# Install git package
if [ $GIT_IS_INSTALLED -ne 0 ]; then
	sudo apt-get install -y git git-core
fi

# Config
GITREPO="https://github.com/w0ng/googlefontdirectory.git"
GITPATH="/var/googlefontdirectory"

# Git clone/pull
if [ -d "${GITPATH}/.git" ]; then
	echo "Updating git repository..."
	OUTPUT=$(cd $GITPATH && sudo git pull | tee /dev/tty)
	if [ "$OUTPUT" = "Already up-to-date." ]; then
		return 0
	fi
else
	sudo git clone $GITREPO $GITPATH
fi

# Install fonts in $GITPATH
echo "Installing webfonts..."
sudo mkdir -p /usr/share/fonts/truetype/google-fonts/
find $GITPATH/ -name "*.ttf" -exec sudo install -m644 {} /usr/share/fonts/truetype/google-fonts/ \; || return 1
sudo fc-cache -f > /dev/null
echo "Done."
