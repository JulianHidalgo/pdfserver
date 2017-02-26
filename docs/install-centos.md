Install service on CentOS
=========================

https://nodejs.org/en/download/package-manager/#enterprise-linux-and-fedora
sudo curl --silent --location https://rpm.nodesource.com/setup_7.x | sudo bash -
sudo yum install -y nodejs
sudo npm install -g node-gyp
sudo yum install cairo cairo-devel cairomm-devel libjpeg-turbo-devel pango pango-devel pangomm pangomm-devel giflib-devel

http://serverfault.com/questions/720558/how-to-install-gcc-5-2-on-centos-7-1


https://www.vultr.com/docs/how-to-install-gcc-on-centos-6
sudo yum install svn texinfo-tex flex zip libgcc.i686 glibc-devel.i686
svn co svn://gcc.gnu.org/svn/gcc/tags/gcc_6_3_0_release/
cd gcc_6_3_0_release/
./contrib/download_prerequisites
cd ..
mkdir gcc_6_3_0_release_build/
cd gcc_6_3_0_release_build/
../gcc_6_3_0_release/configure && make && sudo make install && echo "success"
echo "/usr/local/lib64" > usrLocalLib64.conf
sudo mv usrLocalLib64.conf /etc/ld.so.conf.d/
sudo ldconfig

mkdir /code
sudo chown -R apexteam /code/
cd code
sudo yum install git
git clone https://github.com/JulianHidalgo/pdfserver.git


cd pdfserver/src/server
