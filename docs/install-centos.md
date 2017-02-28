Install service on CentOS
=========================

Install Dependencies
--------------------

```bash
sudo curl --silent --location https://rpm.nodesource.com/setup_7.x | sudo bash -
sudo yum install -y nodejs
sudo npm install -g node-gyp
sudo yum install cairo cairo-devel cairomm-devel libjpeg-turbo-devel pango pango-devel pangomm pangomm-devel giflib-devel
```
* Reference: https://nodejs.org/en/download/package-manager/#enterprise-linux-and-fedora

Installing GCC
--------------
```bash
sudo yum install gcc gcc-c++
sudo yum install svn texinfo-tex flex zip libgcc.i686 glibc-devel.i686
svn co svn://gcc.gnu.org/svn/gcc/tags/gcc_6_3_0_release/
cd gcc_6_3_0_release/
./contrib/download_prerequisites
cd ..
mkdir gcc_6_3_0_release_build/
cd gcc_6_3_0_release_build/
../gcc_6_3_0_release/configure && make && sudo make install && echo "success"

# (Makes your login "forget" about the previously seen locations of gcc and g++)
hash -r
# May say: gcc (GCC) 5.1.0
gcc --version
# May say: g++ (GCC) 5.1.0
g++ --version
# /usr/local/bin/gcc
which gcc
# /usr/local/bin/g++
which g++
    
echo "/usr/local/lib64" > usrLocalLib64.conf
sudo mv usrLocalLib64.conf /etc/ld.so.conf.d/
sudo ldconfig
```
* Reference: https://www.vultr.com/docs/how-to-install-gcc-on-centos-6

Checkout
--------
mkdir /code
sudo chown -R YOURUSER /code
cd code
sudo yum install git
git clone https://github.com/JulianHidalgo/pdfserver.git


cd pdfserver/src/server
npm install