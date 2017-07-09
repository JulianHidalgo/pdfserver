Install service on CentOS
=========================

Install Dependencies
--------------------

```bash
#sudo curl --silent --location https://rpm.nodesource.com/setup_7.x | sudo bash -
sudo curl --silent --location https://rpm.nodesource.com/setup_8.x | bash -
sudo yum install -y nodejs
sudo npm install -g node-gyp
sudo yum install cairo cairo-devel cairomm-devel libjpeg-turbo-devel pango pango-devel pangomm pangomm-devel giflib-devel
```
* Reference: https://nodejs.org/en/download/package-manager/#enterprise-linux-and-fedora

Installing GCC
--------------
CentOS comes with an old version of GCC. The charts generation requires GCC 6+. These are the steps to compile it from source, it takes a very long time unfortunately.

```bash
sudo yum install gcc gcc-c++
sudo yum install svn texinfo-tex flex zip libgcc.i686 glibc-devel.i686
svn co svn://gcc.gnu.org/svn/gcc/tags/gcc_6_4_0_release/
cd gcc_6_4_0_release/
./contrib/download_prerequisites
cd ..
mkdir gcc_6_4_0_release_build/
cd gcc_6_4_0_release_build/
../gcc_6_4_0_release/configure && make
sudo make install && echo "success"

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
```bash
mkdir /code
sudo chown -R YOURUSER /code
cd code
sudo yum install git
git clone https://github.com/JulianHidalgo/pdfserver.git
cd pdfserver/src/server
npm install
```

Run the server
--------------
```bash
node server.js
```
If you see this message: Pango-WARNING **: failed to choose a font, expect ugly output. engine-type='PangoRenderFc', script='common'

Install the dejavu fonts:
yum install dejavu-sans-fonts.noarch dejavu-serif-fonts.noarch

Configure the server to start at boot
-------------------------------------
```bash
# Create a servicer user
sudo adduser -r pdfserver
```

Modify the script in server/scripts/pdfserver.conf with the path to the service folder, and place it in /etc/init/pdfserver.conf

# Reload the configuration
sudo initctl reload-configuration
# Check that the service is displayed
sudo initctl list
# Start the service
sudo initctl start pdfserver
# Check that the service is running, you should see "PDF Service up and running."
curl http://localhost:3000/
# If there are any errors check /var/log/messages
sudo tail /var/log/messages