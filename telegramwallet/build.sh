#!/bin/bash

##### INPUT VALUE VERIFICATION #####
if [[ -z "$1" ]]; then
  echo '
        ############################################################
        # Script to install TelegramWallet from repository         #
        # https://github.com/EasyToken/Telegram-Wallet-Token-ERC20 #
        #                                                          #
        # Enter the directory parameter to install the application #
        # Example: > bash install.sh /tmp                          #
        ############################################################
        '
  exit 1
fi

DIR_INSTALL=$1
DIR_BOT=$DIR_INSTALL"/telegramwallet"
DIR_KEYSTORE=$DIR_BOT"/ethereum/keystore"
DIR_QRCODE=$DIR_BOT"/qr"
CONFIG_FILE=$DIR_BOT"/config.json"

DIR_BUILD=$DIR_INSTALL"/build"
APP_NAME="telegramwallet"

# Upgrade package
apt update && apt dist-upgrade

# Insall Java

echo 'Install Java'
apt install -y openjdk-11-jre openjdk-11-jdk && java -version

# Install git
echo 'Install Git'
apt install -y git

# Install gradle
echo 'Install Gradle'
apt install -y gradle

# Create App dir
if [ ! -e $DIR_BOT ]; then
echo "Add dir for Bot"
mkdir -p $DIR_KEYSTORE
fi

# Create config file
if [ ! -f $CONFIG_FILE ]; then
        echo "Add config files '$CONFIG_FILE'"
        echo '
{"settings": {
        "bot":{
                "username": "telegram bot name",
                "token": "telegram bot token"
        },
        "proxy":{
                "active": false,
                "address": "0.0.0.0",
                "port": 0000,
                "type": "socks5"
        },
        "wallet":{
                "dir":"ethereum/keystore/",
                "password": ""
        },
        "node":{
                "url":"https://urlnode",
                "tokenaddress":"0x0"
        },
	"qrcodedir":"qr/"
}
}
' > $DIR_BOT/config.json
fi

# Add dir for build
# Create App dir
mkdir -p $DIR_BUILD

# Clone repo
echo 'Clone repo'
git clone https://github.com/EasyToken/Telegram-Wallet-Token-ERC20.git $DIR_BUILD

# Build app
echo 'Build App'
cd $DIR_BUILD && gradle build
cp $DIR_BUILD/build/libs/telegramwallet-1.0.jar $DIR_BOT/$APP_NAME.jar

rm -r $DIR_BUILD
