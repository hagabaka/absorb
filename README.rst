====================================================================
Absorb
====================================================================
Minimal web browser written in Ruby using QtWebkit and KDE libraries
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Features
--------

* Following a link by click

* Customization using Ruby files using KDE_/QtWebkit_ Ruby API

  To load Ruby scripts, pipe a space-separated list of their filenames to
  absorb's stdin when starting it. For example, to load all Ruby files in the
  current directory, use ``echo *.rb | absorb``.

.. _KDE: http://techbase.kde.org/Development/Languages/Ruby
.. _QtWebkit: http://doc.trolltech.com/main-snapshot/qtwebkit.html

The following features are provided by scripts:

* Opening a web page through command line: ``absorb <URL>``

* Setting the opened page's Favicon as the window icon

* Setting the opened page's title as the window title

* Resizing the window to fit the opened page

* Saving cookies using Redis

* Saving cookies using KIO::Integration::CookieJar (

* Basic VIm-like UI

Todo
----

* An actual API to configure and control the browser

