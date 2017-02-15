https://nodejs.org/en/download/package-manager/#enterprise-linux-and-fedora
sudo curl --silent --location https://rpm.nodesource.com/setup_7.x | sudo bash -
sudo yum install -y nodejs
sudo npm install -g node-gyp
sudo yum install cairo cairo-devel cairomm-devel libjpeg-turbo-devel pango pango-devel pangomm pangomm-devel giflib-devel

http://serverfault.com/questions/720558/how-to-install-gcc-5-2-on-centos-7-1
/* Apt-get
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt-get update
sudo apt-get install gcc-5.1 g++-5.1
sudo rm /bin/usr/g++
sudo ln -s /usr/bin/g++-5 /usr/bin/g++
*/

mkdir /code
sudo chown -R apexteam /code/
cd code
sudo yum install git
git clone https://github.com/JulianHidalgo/pdfserver.git


cd pdfserver/src/server
