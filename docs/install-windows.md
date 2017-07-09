Windows
=======

1. Installing node-canvas
-------------------------

node-canvas is used to simulate an HTML canvas in the service and render charts. node-canvas needs Cairo, a 2d graphics library.


Install .NET Framework 4.5.1+
-----------------------------

1.1 

Install Windows Build Tools (this also installs Python 2.7.x, v3.x.x is not supported)
npm install --global --production windows-build-tools

Install node-gyp globally
npm install -g node-gyp

Download
http://ftp.gnome.org/pub/GNOME/binaries/win64/gtk+/2.22/gtk+-bundle_2.22.1-20101229_win64.zip
Unzip to C:\GTK

Add python and gtk to path:
;C:\GTK\bin\;C:\Users\julian.hidalgo\.windows-build-tools\python27\;
;C:\GTK\bin\;C:\Users\venbouvet\.windows-build-tools\python27\;

https://github.com/nodejs/node-gyp/issues/972
npm -g install npm@next

Install as service on Windows
-----------------------------
Run as admin:

```
npm run install-windows-service

```

Other remarks
-------------

https://github.com/Automattic/node-canvas/issues/649

../src/JPEGStream.h:10:10: fatal error: 'jpeglib.h' file not found
xcode-select --install


