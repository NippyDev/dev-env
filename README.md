# Building Boot2Qt raspbery image
git clone http://code.qt.io/cgit/yocto/meta-boot2qt.git/
cd meta-boot2qt
./b2qt-init-build-env init --device raspberrypi3
MACHINE=raspberrypi3 . ./setup-environment.sh


# Install git lfs on ubuntu 16.04
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
sudo apt-get install git-lfs
git lfs install

# fix issue with local
sudo locale-gen en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

# build raspberry image in build-raspberrypi3 directory
bitbake b2qt-embedded-qt5-image

# build tool for qt
bitbake meta-toolchain-b2qt-embedded-qt5-sdk
