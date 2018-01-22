#!/bin/sh

sudo apt update
sudo apt install -y doxygen graphviz cmake

# install oracle java 8 (will need to accept license during this)
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install java-common oracle-java8-installer

sudo apt-get install oracle-java8-set-default
source /etc/profile

# install android studio
sudo add-apt-repository ppa:maarten-fonville/android-studio
sudo apt update
sudo apt install android-studio