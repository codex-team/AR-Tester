#!/bin/sh

# Function checking, installing and initing carthage and create file
installCarthage() {
   echo "Initializing Carthage" 
   touch Cartfile
   echo "Cartfile created"
   which -s carthage
    if [[ $? != 0 ]]; then 
      brew install carthage
    fi
   touch Cartfile
   echo "Now you should write necessary libs in Cartfile and run command 'carthage update --platform iOS'"
}

# Function checking, installing, and initing cocoapods in repository
installCocoapods() {
  echo "Initializing Cocoapods"
  which -s pod
  if [[ $? != 0 ]]; then 
    echo "Cocoapods is not installed, please enter the password for installing"
    sudo gem install cocoapods
  fi
  pod init
  echo "Pod initalized"
  echo "Now you should write necessary libs in Podfile and run command 'pod install'" 
}

echo FirstSetup script running...

# 1) Install HomeBrew
# #/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
echo HomeBrew:
echo Checking HomeBrew...
which -s brew
if [[ $? != 0 ]];
then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  echo brew installed
else
  brew update
  echo brew updated
fi

# 2) Install SwiftLint
brew install SwiftLint

# 3) Checking dependencies manager
echo Checking dependencies manager...
cd ../
if [ -f "Cartfile" ]; then
  which -s carthage
  if [[ $? != 0 ]]; then 
    brew install carthage
  fi
  carthage update --platform iOS
else
if [ -f "Podfile" ]; then
  which -s pod
  if [[ $? != 0 ]]; then 
    echo "Cocoapods is not installed, please enter the password for installing"
    sudo gem install cocoapods
  fi
  pod install
else 
  echo "You haven't any Dependecies manager, which would you like to use?"
  read -p "1) Carthage \n 2) Cocoapods " answer
  case $answer in
  "1" ) installCarthage ;;
  "2" ) installCocoapods ;;
  esac
fi
fi

